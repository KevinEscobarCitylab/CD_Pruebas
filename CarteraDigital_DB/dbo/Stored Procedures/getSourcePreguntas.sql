CREATE PROCEDURE [dbo].[getSourcePreguntas](@idEnc int, @idFormulario int,@idPreguntaLoop int,@searchLoop bit, @d varchar(max) output)as
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
