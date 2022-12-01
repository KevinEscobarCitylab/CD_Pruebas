
CREATE OR ALTER function [dbo].[getFormatR](@idTipo int,@tipo varchar(50),@multiple int)returns int as 
begin
	return case @idTipo
	when 1 then ( case @tipo
		when 'string' then 0					
		when 'int' then 1
		when 'float' then 2
		when 'date' then 3
		when 'img' then 4
		when 'file' then 5
		when 'math' then 6
		when 'gps' then 7
		when 'caps' then 8
		when 'name' then 9
		when 'geocode' then 10
		else -1
		end
	)
	when 2 then (case @tipo
		when 'autocomplete' then 14
		when 'list' then 
			iif(@multiple =1,23,22)
		when 'api' then 16
		when 'b64f' then 17
		when 'datasource' then iif(@multiple =1,24,18)
		when 'script' then 19
		when 'loop' then 20
		when 'int' then 13
		else -1
		end
	)
	when 3 then (case @tipo
		when 'datasource' then 24
		else 21
		end
	)
	else -1
	end
end

GO

--CREO CAMPO PARA FORMATOR
IF(col_length('preguntas','formatoR') IS NULL) ALTER TABLE preguntas add formatoR int

GO
--CREO TRIGGER PARA ACTUALIZAR FORMATOR
GO
CREATE OR ALTER TRIGGER UpdateFormatoR
   ON  dbo.preguntas
    FOR INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON; 
	UPDATE p
		set p.formatoR=dbo.getFormatR(p.idTipo,f.tipo,p.multiple)
		from preguntas p 
		inner join formatos f on f.idFormato=p.idFormato
		where idPregunta in(SELECT idPregunta FROM inserted) 
END
GO

--ACTUALIZO MASIVAMENTE PARA LAS PREGUNTAS ACTUALES PARA QUE TENGAN FORMATO POR DEFECTO
UPDATE p
	set p.formatoR=dbo.getFormatR(p.idTipo,f.tipo,p.multiple)
	from preguntas p 
	inner join formatos f on f.idFormato=p.idFormato

GO

if(col_length('preguntas','readonly')is null)alter table preguntas add readonly int
if(col_length('preguntas','disable')is null)alter table preguntas add disable int

GO
CREATE FUNCTION [dbo].[solicitudR2](@idProspecto int)returns @returntable table
(
	[idFormulario] [int] NOT NULL,
	[formulario] [varchar](50) NULL,
	[indexF] [bigint] NULL,
	[fechaCreacion] [datetime] NULL,
	[indexP] [bigint] NULL,
	[idPregunta] [int] NOT NULL,
	[pregunta] [varchar](max) NULL,
	[respuesta] [varchar](max) NULL,
	[path] [varchar](64) NOT NULL,
	[idRespuesta] [int] NULL,
	[idRespuestaT] [varchar](50) NULL,
	[observacion] [nvarchar](max) NULL,
	[observacion2] [nvarchar](max) NULL,
	[api] [nvarchar](max) NULL,
	[idRM] [varchar](max) NULL,
	[g] [varchar](max) NULL,
	[p] [varchar](max) NULL,
	[d1] [varchar](max) NOT NULL,
	[idRS] [varchar](max) NULL,
	[IDT] [nvarchar](max) NULL,
	[readOnly] [int] NULL
) as
begin
	insert @returntable
	select
		ds.idFormulario,
		ds.formulario,
		f.indexF,
		f.fechaCreacion,
		indexP = row_number() over(partition by f.indexF order by (select 1))-1,
		ds.idPregunta,
		ds.pregunta,
		respuesta = cast(ds.respuesta as varchar(max)),
		path = concat('$[',f.indexF,'].respuestas[',row_number() over(partition by f.indexF order by (select 1))-1,']'),
		ds.idRespuesta,
		ds.idRespuestaT,
		ds.observacion,
		ds.observacion2,
		ds.api,
		ds.idRM,
		ds.g,
		ds.p,
		ds.d1,
		ds.idRS,
		ds.IDT,
		ds.[readOnly]
	from (
		select
			f.idFormulario,
			f.nombre as formulario,
			p.idPregunta,
			p.pregunta,
			respuesta = coalesce(r.respuesta,s.observacion),
			s.idRespuesta,
			s.idRespuestaT,
			observacion = iif(ft.tipo = 'list',concat('[',s.observacion,']'),s.observacion),
			s.observacion2,
			s.api,
			s.idRM,
			s.g,
			s.p,
			d1 = concat('[', s.d1, ']'),
			s.IDT,
			s.idRS,
			s.[readOnly]
		from openjson(concat('[',dbo.fStuff((select concat(',',replace(replace(respuestas,'[',''),']','')) from openjson(((select respuestas from prospectos where idProspecto = @idProspecto)))with(respuestas nvarchar(max) as json) where respuestas is not null for xml path(''))),']'))with(idPregunta int, idRespuesta int, idRespuestaT varchar(50), observacion nvarchar(max), observacion2 nvarchar(max), api nvarchar(max),idRM varchar(max),g varchar(max),p varchar(max),d1 varchar(max),idRS varchar(max),IDT nvarchar(max), [readOnly] int) s
		inner join preguntas p on p.idPregunta = s.idPregunta
		inner join formatos ft on ft.idFormato = p.idFormato
		left join respuestas r on r.idRespuesta = s.idRespuesta
		inner join formularios f on f.idFormulario = p.idFormulario
	)ds
	inner join (select indexF = row_number() over(order by (select 1))-1,idFormulario,fechaCreacion from openjson((select respuestas from prospectos where idProspecto = @idProspecto))with(idFormulario int, fechaCreacion datetime)) f on f.idFormulario = ds.idFormulario
	
	RETURN
end
GO

CREATE OR ALTER PROCEDURE [dbo].[getSourcePreguntas](@idEnc int, @idFormulario int,@idPreguntaLoop int,@searchLoop bit, @d varchar(max) output)as
begin
	declare @ds table (idPregunta int,idRespuesta int,respuesta nvarchar(MAX),idRespuestaT nvarchar(max),referenceFk varchar(50), indexP int)
	declare @dt table (idPregunta int, _reference int)
	declare @identity int = coalesce((select max(idRespuesta) from respuestas),0)
	declare dt cursor FOR (	
		select 
			p.idPregunta,
			p.referenceTable,
			p.referenceId,
			p.referenceValue,
			p.referenceFk,
			ROW_NUMBER() OVER(partition by p.referenceTable,p.referenceFk  order by p.referenceTable,p._index) AS indexP,
			p.indexReference
		from preguntas p
		inner join formatos f on f.idFormato = p.idFormato
		inner join formularios fr on fr.idFormulario = p.idFormulario
		inner join encuestas e on e.idEncuesta = fr.idEncuesta
		where f.tipo = 'datasource' and p.referenceTable is not null and p.estado=1 and e.estado = 1 and fr.estado = 1 and p._default is null and p.idFormulario = @idFormulario
	)
	open dt
	declare @idPregunta int, @referenceTable nvarchar(max),@referenceId nvarchar(max),@referenceValue nvarchar(max),@referenceFk varchar(max), @indexP int,@reference int,@indexReference varchar(50)
	FETCH NEXT FROM dt INTO @idPregunta,@referenceTable,@referenceId,@referenceValue,@referenceFk,@indexP,@indexReference

	while @@FETCH_STATUS = 0   
	begin
		declare @w bit = iif((select 1 from information_schema.columns where table_name = @referenceTable and column_name = '_index')is not null,1,0)
		declare @fk nvarchar(max) = iif(@referenceFk is not null and @referenceFk !='',concat(',',@referenceFk,' as referencia'),',null as referencia')
		declare @sql nvarchar(max)= concat('select ',@idPregunta,' as idPregunta,(ROW_NUMBER() OVER(ORDER BY ',iif(@w = 1, concat('_index,',@referenceId), @referenceId),' ASC)+',@identity,') as idRespuesta,',@referenceValue,',',@referenceId,@fk,',',@indexP,'from ',@referenceTable)
		if(@indexP=1)begin
			insert @ds exec sp_executesql @sql
			set @reference = @idPregunta
		end
		else insert @dt(idPregunta,_reference) values(@idPregunta, @reference)
		set @identity = coalesce((select max(idRespuesta) from @ds),@identity)
		FETCH NEXT FROM dt INTO @idPregunta,@referenceTable,@referenceId,@referenceValue,@referenceFk,@indexP,@indexReference
	end

	close dt
	deallocate dt

	declare @pdp table (# int, idPregunta int,used bit,preguntas varchar(max))
	declare @idLopp int = (select idFormato from formatos where tipo = 'loop')

	if(@idPreguntaLoop is not null)begin
		insert @pdp(idPregunta,used) select p.idPregunta,1
		from dependenciasPregunta dp
		inner join  preguntas p on dp.idPregunta = p.idPregunta
		where dp.estado = 1 and dp.parent = @idPreguntaLoop and p.estado = 1 and p.idFormato != @idLopp
	end
	else begin
		insert @pdp(#,idPregunta,used) select row_number() over(order by (select 1))-1,p.idPregunta,0
		from  preguntas p
		inner join formularios _fr on _fr.idFormulario = p.idFormulario
		where _fr.idFormulario = @idFormulario and _fr.idEncuesta = @idEnc and p.estado = 1 and _fr.estado = 1 and p.idFormato = @idLopp
		if(@searchLoop = 1)begin
			declare @a varchar(max)
			declare @totalLoop int = (select count(1) from @pdp), @indexLoop int = 0

			while @indexLoop < @totalLoop begin
				declare @idPTMP int = 0
				select @idPTMP = idPregunta from @pdp where # = @indexLoop

				exec getSourcePreguntas @idEnc,@idFormulario,@idPTMP,0, @a output
				update @pdp set used = 1 , preguntas = @a  where idPregunta = @idPTMP

				set @indexLoop +=1
			end
		end
		else begin
			insert @pdp(idPregunta,used) select p.idPregunta ,1
			from  preguntas p
			inner join formularios _fr on _fr.idFormulario = p.idFormulario
			left join dependenciasPregunta dp on dp.estado = 1 and dp.idPregunta = p.idPregunta and dp.parent in (select idPregunta from @pdp where used = 0)
			where _fr.idFormulario = @idFormulario and _fr.idEncuesta = @idEnc and p.estado = 1 and _fr.estado = 1 and p.idFormato != @idLopp and dp.idDependencia is null
		end
			
	end
		
	    set @d = isNull((
		select
			ROW_NUMBER() over(partition by p.idFormulario order by p._index) _index,
			p.idPregunta,
			cast(p.pregunta as varchar(max))as pregunta,
			p.idFormulario,
			p.idTipo as tipoPregunta,
			f.tipo,
			p.formatoR,
			dependencias = isNULL((select
				ROW_NUMBER() over(partition by dp.indexG order by dp.indexG) id,
				dp.parent,
				dp.valorR ,
				dp.idOperador ,
				dp.idUnidad ,
	        	dp.parentR ,
				dp.valorT,
				dp.fieldD1,
				dp.indexG
	    	from dependenciasPregunta dp				
	    	where dp.estado = 1 and dp.idPregunta = p.idPregunta and ((dp.parent != @idPreguntaLoop and @idPreguntaLoop is not null) or @idPreguntaLoop is null)
	    	for json path),'[]'),
			p.mask,
			p.fx,
			p.idRF,
			p.idEncuesta,
			coalesce(p.requerir,0) requerir,
			p.idPreguntaFk,
			p.isHidden,
			p.maxLength,
			p.multiple,
			p.saved1 as saveD1,
			p.alias as [pivot],
			p.disable,
			p.readOnly,
			_ds._reference,
			_tf.typeGetPhoto,
			(select * from(
				select idRespuesta,cast(respuesta as varchar(max)) as respuesta,valor,ID as IDT,cast(d1 as varchar(max)) as d1,_index,null as idRespuestaT,null as referenceFk,null as indexP from respuestas r where r.idPregunta = p.idPregunta and r.estado = 1
				union
				select idRespuesta,respuesta,null as valor,null as IDT,null as d1,idRespuesta as _index,idRespuestaT,referenceFk,indexP from @ds where idPregunta = p.idPregunta
			)as dsr
			order by dsr._index for JSON path) respuestas,
			preguntas = JSON_QUERY(coalesce(pdp.preguntas,'[]'))
		from preguntas p
		inner join @pdp pdp on pdp.idpregunta = p.idpregunta and used = 1
		inner join formatos f on p.idFormato = f.idFormato
		left join tiposFoto _tf on _tf.idTipoPhoto = p.idTipoPhoto
		left join @dt _ds on _ds.idPregunta = p.idPregunta
		where p.estado = 1 and p._default is null order by p._index
	for JSON PATH),'[]')
end

GO

CREATE OR ALTER PROCEDURE [dbo].[getPreguntasFormulario](@idEnc int, @idFormulario int, @sessionid varchar(max)= null, @d varchar(max) output)as
begin
	declare @idUsuario int = (dbo.getIdUsuarioByToken(@sessionid))

	if (@idUsuario is not null or @sessionid is null) begin
		declare @source varchar(max)
		exec getSourcePreguntas @idEnc,@idFormulario,null,0, @source output

		declare @sourceI varchar(max)
		exec getSourcePreguntas @idEnc,@idFormulario,null,1, @sourceI output

		set @d = (
		select (
		select
			preguntas = json_query(@source),
			preguntasI = json_query(@sourceI)
			for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data)
	end	
	else begin 
		set @d =(select (select 403 as error,'Acceso Denegado' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data)
	end
end
GO

CREATE OR ALTER FUNCTION [dbo].[getformulariosR] (@idProspecto int)returns @returntable table
(
	[idFormulario] [int] NULL,
	[fechaCreacion] [datetime] NULL,
	[totalCampos] [int] NULL,
	[observado] [int] NULL
)
AS
BEGIN
	INSERT @returntable
	select 
		* 
	from openjson((select 
			respuestas 
		from prospectos 
		where idProspecto = @idProspecto)
	) with(
		idFormulario int, 
		fechaCreacion datetime,
		totalCampos int, 
		observado int
	)

	RETURN
END

GO

CREATE OR ALTER PROCEDURE [dbo].[getFormulariosEncuesta](@idEncuesta int,@idProspecto int,@usuario int, @d varchar(max) output)as
begin
	if(object_id('tempdb..#db_form') is not null)drop table #db_form

	select * into #db_form from (
	select 
	    iif(ge._index is null,1000,ge._index) _index,
		iif(ge.idGrupoE is null,1000,ge.idGrupoE) idGrupoE,
	    iif(ge.nombre is null,'Otros',ge.nombre) as grupoFormulario,
		f.idEncuesta,
	    ROW_NUMBER() OVER(ORDER BY ge._index ASC) AS ID
	from formularios f 
	left join grupoEncuesta ge on ge.idGrupoE = f.idGrupoE
	inner join encuestas e on e.idEncuesta = f.idEncuesta
	where f.idEncuesta = @idEncuesta and f.estado = 1)dt order by dt._index

	if(object_id('tempdb..#db_respuestas') is not null)drop table #db_respuestas
	select * into #db_respuestas from (
	select
	    p.idFormulario,
	    p.idPregunta,
	    p.pregunta,			
		s.idRespuesta,
		s.idRespuestaT,
		s.idRM,
		s.respuesta	as observacion,
		s.observacion2,
		s.g,
		s.p,
		s.d1,
		s.idRS,
		s.IDT,
		s.[readOnly],
		dbo.getFormatR(p.idTipo,f.tipo,p.multiple) formatoR
	from preguntas p
	inner join formatos f on f.idFormato = p.idFormato
	inner join solicitudR2(@idProspecto) s on s.idPregunta = p.idPregunta
	inner join formularios fr on fr.idFormulario = p.idFormulario
	where p.estado = 1 and fr.idEncuesta = @idEncuesta and fr.estado = 1) as dt

	if(object_id('tempdb..#db_prospecto') is not null)drop table #db_prospecto
	select * into #db_prospecto from (
	select
		isnull(p.d1,'{}') as d1,p.eventos,isnull(p.d3,'[]') as d3,p.d4
	from prospectos p
	inner join encuestas e on p.idEncuesta = e.idEncuesta
	where p.idEncuesta = @idEncuesta and p.idProspecto = @idProspecto) as dt

	declare @idFM int = (select top 1 idFormulario from formularios where idEncuesta = @idEncuesta and estado = 1 order by _index )

	    set @d = (
		select (select
			fmains = isNull((select -1 as idGrupoE,-1 _index,json_query('[]') as form,
			f.idFormulario,
			f.idEncuesta,
			f.nombre as grupoFormulario,
			cast(isnull(s.observado,0) as bit) as isObserved,
			isnull(s.totalCampos,0) as cont
		from formularios f
		inner join getformulariosR(@idProspecto) s on s.idFormulario = f.idFormulario
		where f.idFormulario = @idFM for json path),'[]'),
		groups = (select 
				s._index,
				s.idGrupoE,
				s.grupoFormulario,
				form = isNull((
					select 
						f.idFormulario,
						nombre,
						json_query(d1) as d1,
						conf,
						_index,
						cast(isnull(fr.observado,0) as bit) as isObserved,
						isnull(fr.totalCampos,0) as cont
					from formularios f 
					left join getformulariosR(@idProspecto) fr on fr.idFormulario=f.idFormulario
					where f.idFormulario <> @idFM and (idGrupoE = s.idGrupoE or (s.idGrupoE = 1000 and idGrupoE is null and idEncuesta = s.idEncuesta)) and estado = 1
					order by _index for json path)
				,'[]')
			from #db_form s							
			group by s._index,s.idGrupoE,s.grupoFormulario,s.idEncuesta for json path),
		respuestas = isnull((select * from #db_respuestas for JSON PATH),'[]'),
		prospecto = (select * from #db_prospecto for JSON PATH)
		for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
	)
end
GO

