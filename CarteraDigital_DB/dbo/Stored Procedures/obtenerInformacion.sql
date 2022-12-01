    create procedure [dbo].[obtenerInformacion](@text varchar(max))  as
	begin
		update parametros set tmp = @text
		declare @idGestor int, @fecha varchar(max),@fechaObservacion varchar(max)

		select
			@idGestor = idGestor,
			@fecha = fecha,
			@fechaObservacion = fechaObservacion
		from openjson(@text)with(idGestor int, fecha varchar(max), fechaObservacion varchar(max))

		set @fecha = cast(@fecha as datetime)
		--set @fechaObservacion = cast(@fechaObservacion as datetime)
		declare @fNow datetime = cast(GETDATE() as datetime)

		declare @ultFechaObservacion datetime

		select @ultFechaObservacion = ultFechaObservacion from gestores where idGestor = @idGestor

		if @idGestor is not null and @ultFechaObservacion > @fechaObservacion begin
			declare @cultureInfo varchar(max)
			select
				@cultureInfo = cultureInfo
			from openjson((select conf from parametros))with(useTransaction bit, version varchar(max), cultureInfo varchar(max))

			declare @idG int, @sid varchar(max)
			select
				@idG = g.idGestor,
				@sid = sessionid
			from usuarios u
			inner join gestores g on g.idGestor = u.idGestor
			where g.idGestor = @idGestor

			--Encabezados
			set nocount on
				declare @temp table(# int identity(1,1), idProspecto int, idPregunta int,idFormulario int,idEncuestaR int, ob int, idPreguntaRS int, observacion2 varchar(max),tApi int, api varchar(max),observacion varchar(max),B64 int,B64Name varchar(max),idFormato int,indexAPI int)
				declare @_rsp table(idProspecto int, idPregunta int,idFormulario int,idEncuestaR int, ob int, idPreguntaRS int, observacion2 varchar(max),tApi int, api varchar(max),observacion varchar(max),B64 int,B64Name varchar(max),idFormato int)
				declare @formulariosRespondidos table(idFormularioR int identity(1,1),idFormulario int,idProspecto int,fechaRegistro datetime,totalCampos int)
				declare @api int, @b64f int,@img int,@file int, @idPreguntaRS int = 1

				select
					@api=iif(tipo='api',idFormato,@api),
					@b64f=iif(tipo='b64f',idFormato,@b64f),
					@img=iif(tipo='img',idFormato,@img),
					@file=iif(tipo='file',idFormato,@file)
				from formatos
				where tipo in('api','b64f','img','file')

				declare @pp table(# int, idProspecto int, respuestas nvarchar(max))
				insert @pp
				select
					# = row_number() over(order by(select 1)),
					idProspecto,respuestas
				from prospectos
				where idGestor = @idG and  (etapa=1 or (etapa=2 and idGrupoAdesco is null))

				declare @totalPP int = (select count(1) from @pp),@indexPP int = 1

				while @indexPP <= @totalPP begin
					declare @idProspecto int = (select idProspecto from @pp where # = @indexPP)
					declare @fr table(# int,idFormulario int,fecha datetime, rsp nvarchar(max))
					declare @dat nvarchar(max) = (select respuestas from prospectos where idProspecto = @idProspecto and observado = 1 and fechaObservacion > @fechaObservacion);
					insert @fr select #=row_number() over(order by (select 1)), idFormulario,fechaCreacion,respuestas from openjson(@dat)with(idFormulario int,fechaCreacion datetime,respuestas nvarchar(max)as json)
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
							idPreguntaRS = @idPreguntaRS,
							t.observacion2,
							tApi = iif(p.idFormato=@api,1,0),
							api,
							observacion = iif(p.idFormato in(@api,@b64f,@img,@file),t.observacion,null),
							B64 = iif(p.idFormato in(@b64f,@img,@file),1,0),
							B64Name = iif(p.idFormato in(@b64f,@img,@file),p.pregunta,null),
							p.idFormato
						from openjson((select rsp from @fr where # = @indexF))with(idPregunta int, observacion varchar(max), api varchar(max),observacion2 varchar(max)) t
						inner join preguntas p on p.idPregunta = t.idPregunta and p.estado = 1
						inner join formularios f on f.idFormulario = @idFormulario
						where f.web = 0 or f.web is null and t.observacion2 is not null

						insert @temp select *,0 as indexAPI from @_rsp --where (dbo.notEmpty(observacion2) is not null or idFormato in(@api,@b64f,@img,@file))

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
					set @indexPP +=1
				end

				declare @max int = coalesce((select MAX(#) from @temp),0)
				update @temp set indexAPI = @max + # where tApi = 1
				update @temp set idPreguntaRS = #
				update @temp set observacion = concat('ws.svc/document/',idProspecto,'/',idFormulario,'/',idPregunta,'/0/',@sid)
			set nocount off
		end

		declare @newAnuncios int =(select count(1) from anuncios where estado = 1 and fechaCarga >= @fecha and fechaIn <= @fNow)

		declare @nCR int= (select top 1 count(1) from prospectos where isnew=1)
		select(
			select
				0 as error,
				'Verificado' as message,
				coalesce(@newAnuncios,0) as newAnuncios,
				@nCR as nCR,
				--(select coalesce(cantProspectosObs,0) from gestores g where g.idGestor = @idGestor) as prospectosObservados,
				prospectos = (select
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
					p.d4,
					p.rechazado,
					isNull((select B64Name as pregunta,observacion as respuesta,idPreguntaRS from @temp t where t.idProspecto = p.idProspecto and B64 =1 for json path),'[]')as b64Url,
					isNull((select idPreguntaRS,idPregunta,idEncuestaR,observacion2 from @temp t where t.idProspecto = p.idProspecto and ob=1 for json path),'[]') as observaciones,
					isNull((select idPreguntaRS,idPregunta,idEncuestaR,api,observacion from @temp t where t.idProspecto = p.idProspecto and tApi=1 for json path),'[]') as api,
					(select *from(
						select 'Prospecto' as Actividad,
						(select * from(
							select 'Tipo' as 'name',cast(e.nombre as varchar(max)) as 'value'
						) as dt for json path) as params
					)as ds for json path, WITHOUT_ARRAY_WRAPPER) as popup
					--p.idProspecto,
					--p.encabezado,
					--iif(p.nDoc is null,iif(cl.nDoc is null,cast(p.idProspecto as varchar(max)),cl.nDoc),p.nDoc) as nDoc,
					--observaciones = isNull((select idPreguntaRS,idPregunta,idEncuestaR,observacion2 from @temp t where t.idProspecto = p.idProspecto and ob=1 for json path),'[]')
				FROM prospectos p
				inner join encuestas e on e.idEncuesta = p.idEncuesta
				left join creditos c on c.idCredito = p.idCredito
				left join clientes cl on cl.idCliente = c.idCliente
				where p.idGestor = @idGestor and (p.etapa = 1) and p.observado = 1 and fechaObservacion > @fechaObservacion for JSON PATH)
			for JSON PATH, WITHOUT_ARRAY_WRAPPER
		)as data
	end
