CREATE PROCEDURE [dbo].[LoginGetProspecto](@idProspecto int)AS
BEGIN
	if(@idProspecto is not null) begin
		declare @cultureInfo varchar(5)
		select
			@cultureInfo = cultureInfo
		from openjson((select conf from parametros))with(cultureInfo varchar(max))
		
		--Encabezados
		set nocount on
			declare @temp table(# int identity(1,1), idProspecto int, idPregunta int,idFormulario int,idEncuestaR int, ob int, observacion2 varchar(max),tApi int, api varchar(max),observacion varchar(max),B64 int,B64Name varchar(max),idFormato int,indexAPI int)
			declare @_rsp table(idProspecto int, idPregunta int,idFormulario int,idEncuestaR int, ob int, observacion2 varchar(max),tApi int, api varchar(max),observacion varchar(max),B64 int,B64Name varchar(max),idFormato int)
			declare @formulariosRespondidos table(idFormularioR int identity(1,1),idFormulario int,idProspecto int,fechaRegistro datetime,totalCampos int)
			declare @api int, @b64f int,@img int,@file int

			select
				@api=iif(tipo='api',idFormato,@api),
				@b64f=iif(tipo='b64f',idFormato,@b64f),
				@img=iif(tipo='img',idFormato,@img),
				@file=iif(tipo='file',idFormato,@file)
			from formatos
			where tipo in('api','b64f','img','file')

			declare @fr table(# int,idFormulario int,fecha datetime, rsp nvarchar(max))
			declare @dat nvarchar(max) = (select respuestas from prospectos where idProspecto = @idProspecto);

			insert @fr select 
				#=row_number() over(order by (select 1)), 
				s.idFormulario,
				s.fechaCreacion,
				s.respuestas 
			from openjson(@dat)with(idFormulario int,fechaCreacion datetime,respuestas nvarchar(max)as json)s
			inner join formularios f on f.idFormulario = s.idFormulario
			where coalesce(f.web,0)=0
				
			declare @totalF int = (select count(1) from @fr),@indexF int = 1

			while @indexF <= @totalF begin
				declare @idFormulario int = null, @fechaRegistro datetime = null
				select
					@idFormulario = idFormulario,
					@fechaRegistro = fecha
				from @fr where # = @indexF

				insert @_rsp
				select
					idProspecto = @idProspecto,
					p.idPregunta,
					idFormulario = @idFormulario,
					idEncuestaR = @idProspecto,
					ob = iif(dbo.notEmpty(t.observacion2) is null,0,1),
					t.observacion2,
					tApi = iif(p.idFormato=@api,1,0),
					api,
					observacion = iif(p.idFormato in(@api,@b64f,@img,@file),t.observacion,null),
					B64 = iif(p.idFormato in(@b64f,@img,@file),1,0),
					B64Name = iif(p.idFormato in(@b64f,@img,@file),p.pregunta,null),
					p.idFormato
				from openjson((select rsp from @fr where # = @indexF))with(idPregunta int, observacion varchar(max), api varchar(max),observacion2 varchar(max)) t
				inner join preguntas p on p.idPregunta = t.idPregunta and p.estado = 1
				--where t.observacion is not null

				insert @temp select *,0 as indexAPI from @_rsp where (dbo.notEmpty(observacion2) is not null or idFormato in(@api,@b64f,@img,@file))

				insert @formulariosRespondidos
				(idFormulario,idProspecto,fechaRegistro,totalCampos)
				select
					idFormulario = @idFormulario,
					idProspecto = @idProspecto,
					fechaRegistro = @fechaRegistro,
					totalCampos = (select count(1) from @_rsp)

				delete from @_rsp
				set @indexF +=1
			end

			delete from @fr

			declare @max int = coalesce((select MAX(#) from @temp),0)
			update @temp set indexAPI = @max + # where tApi = 1
			update @temp set tApi = 1 , B64 = 0 where B64 = 1 and tApi = 0 and observacion not like '%/img_%'
			update @temp set B64 = 0 where B64 = 1 and observacion is null
		set nocount off

		select (select
			0 as error,
			'Verificado' as message,
			prospecto = json_query((SELECT 
                    p.idProspecto,
                    p.idCredito,
                    cl.nombre as nombreCr,
                    format(p.fecha,'dd MMM yyyy','es-ES')as fecha,
                    datediff(day,p.fecha,getdate())as diasProspecto,
                    formulariosR = (select
                            idFormularioR,
                            idFormulario,
                            fechaRegistro = format(fechaRegistro,'dd MMM yyyy',@cultureInfo),
                            horaRegistro = format(fechaRegistro,'HH:mm',@cultureInfo),
                            totalCampos
                        from @formulariosRespondidos
                        where idProspecto = p.idProspecto for JSON PATH
                    ),
                    p.latitud,
                    p.longitud,
                    p.latitudNegocio,
                    p.longitudNegocio,
                    p.d1,
                    p.idEncuesta,
                    p.idGrupoAdesco,
                    p.renovado,
                    p.encabezado,
                    iif(p.nDoc is null,iif(cl.nDoc is null,cast(p.idProspecto as varchar(max)),cl.nDoc),p.nDoc) as nDoc, 
                    p.extra,
                    p.edad,
                    p.d2,
                    p.d3,
                    p.d4,
                    p.rechazado,
                    (case when p.isNew=1 then 1 else 0 end) isNew,
                    isNull((select B64Name as pregunta,observacion as respuesta,idFormulario,idPregunta from @temp t where B64 =1 for json path),'[]')as b64Url,
                    isNull((select idPregunta,idEncuestaR,observacion2 from @temp t where ob=1 for json path),'[]') as observaciones,
                    isNull((select idPregunta,idEncuestaR,api,observacion from @temp t where tApi=1 and ob=0 for json path),'[]') as api,
                    (select *from(
                        select 'Prospecto' as Actividad,
                        (select * from(
                            select 'Tipo' as 'name',cast(e.nombre as varchar(max)) as 'value'
                            union select 'Etapa' as 'name',(select etapa from etapasGestionProspecto where idEtapaG = p.etapa) as 'value'
                        ) as dt for json path) as params
                    )as ds for json path, WITHOUT_ARRAY_WRAPPER) as popup
                FROM prospectos p
                inner join encuestas e on e.idEncuesta = p.idEncuesta
                left join creditos c on c.idCredito = p.idCredito
                left join clientes cl on cl.idCliente = c.idCliente
                where p.idProspecto = @idProspecto for JSON PATH, WITHOUT_ARRAY_WRAPPER
			))
		from inicioSesionJS i 
		where i.ID = 1 for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
	end
	else begin
        select (select 1 as error,'Prospecto incorrecto' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data
    end
end