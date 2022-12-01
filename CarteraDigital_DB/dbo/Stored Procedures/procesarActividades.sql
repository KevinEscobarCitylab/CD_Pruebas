create procedure [dbo].[procesarActividades](@data varchar(max),@indexL int = 0, @debug bit = 0)as
begin
	if(@data is null and @indexL != 0)set @data = (select data from logs with(nolock) where id = @indexL)
	set nocount on
	--begin tran t
		declare @autorizarGeoPic bit
		declare @addVRRuta bit
		declare @addAPRuta bit
		declare @etapaAnteriorProspecto bit
		declare @sendMailDB bit

		select
			@autorizarGeoPic = coalesce(autorizarGPSPic,0),
			@addVRRuta = coalesce(addVRRuta,1),
			@addAPRuta = coalesce(addAPRuta,1),
			@etapaAnteriorProspecto = coalesce(etapaAnteriorProspecto,0),
			@sendMailDB = coalesce(sendMailDB,0)
		from openjson((select top 1 conf from parametros))with(autorizarGPSPic bit, addVRRuta bit, addAPRuta bit,agregarVisitaReprogramadaRuta bit,agregarAcuerdoPagoRuta bit,etapaAnteriorProspecto bit,sendMailDB bit)

		declare @us table(
			idGestor int,
			UID varchar(max),
			sessionid varchar(max)
		)
		declare @ra table(
			idRegistroActividad int,
			idActividad int,
			idReaccion int,
			idDetalle int,
			idMotivo int,
			idCredito int,
			idCliente int,
			idClienteP int,
			idClienteCampania int,
			idCampania int,
			idEncuesta int,
			idProspecto int,
			idFiador int,
			idOrganizacion int,
			idGrupo int,
			diasGestion int,
			idPrioridad int,
			diasPrioridad int,
			distancia float,
			tipoP int,
			fechaGestion varchar(max),
			fechaVisitaReprogramada varchar(max),
			horaGPS varchar(max),
			idGestor int,
			latitud varchar(max),
			longitud varchar(max),
			observacion varchar(max),
			participantes int,
			telefono varchar(max),
			etapa int,
			d1 varchar(max),
			d2 varchar(max),
			d3 varchar(max),
			d4 varchar(max),
			eventos varchar(max),
			ID int,
			idProspectoS int,
			idEncuestaRS int,
			whatsapp int,
			gestionado int,
			idRuta int
		)
		declare @img table(
			idImagen int,
			idPreguntaR int,
			idPreguntaRS int,
			idRegistroActividad int,
			idGestor int,
			idActividad int,
			idCliente int,
			idFiador int,
			idGrupoAdesco int,
			alias varchar(max),
			casa int,
			interior int,
			nombre varchar(max),
			tipo int,
			idPregunta int,
			idImagenS int,
			idProspectoS int,
			fecha varchar(max),
			GPS int,
			received int,
			d4 int
		)
		declare @e table(
			idEncuestaR int,
			idRegistroActividad int,
			idCredito int,
			idProspecto int,
			idEncuesta int,
			idFormulario int,
			codigo varchar(max),
			fecha varchar(max),
			idGestor int,
			latitud varchar(max),
			longitud varchar(max),
			prospecto int,
			puntosP float,
			idEncuestaRS int,
			idProspectoS int,
			rechazado int,
			etapa int,
			totalF int,
			totalFR int
		)
		declare @f table(
			idFormularioR int,
			idEncuestaR int,
			idFormulario int,
			totalCampos int,
			fechaCreacion varchar(max),
			idFormularioRS int,
			idEncuestaRS int,
			idProspectoS int
		)
		declare @rsp table(
			idPreguntaR int,
			idEncuestaR int,
			idPregunta int,
			idFormulario int,
			idRespuesta int,
			idRespuestaT varchar(max),
			observacion varchar(max),
			api varchar(max),
			idFormularioR int,
			idEncuestaRS int,
			idProspectoRS int,
			idPreguntaRS int,
			idRM varchar(max),
			IDT varchar(max),
			d1 varchar(max),
			g int,
			p int,
			lp int,
			gp int,
			[readOnly] int,
			incorrect int
		)
		declare @pp table(
			idPromesa int,
			idRegistroActividad int,
			idCredito int,
			idGrupoAdesco int,
			idGestor int,
			montoPrometido float,
			fechaPromesa varchar(max)
		)
		declare @dr table(
			idDeposito int,
			idRegistroActividad int,
			idCredito int,
			idGrupoAdesco int,
			idGestor int,
			montoDepositoo float,
			fechaDeposito varchar(max)
		)
		declare @dp table(
			idDetalle int,
			montoPorCobrar float,
			numeroComprobante varchar(max),
			fechaPago varchar(max),
			idCredito int,
			idGestor int,
			idRegistroActividad int
		)
		declare @pc table(
			idDetalle int,
			montoPorCobrar float,
			numeroComprobante varchar(max),
			fechaPago varchar(max),
			idCredito int,
			idGestor int,
			idRegistroActividad int,
			idGrupoAdesco int
		)
		declare @cl table(
			idCliente int,
			latitud varchar(max),
			longitud varchar(max),
			latitudNegocio varchar(max),
			longitudNegocio varchar(max),
			autorizarGEOCasa int,
			autorizarGEONegocio int
		)
		declare @cp table(
			idProspecto int,
			latitud varchar(max),
			longitud varchar(max),
			latitudNegocio varchar(max),
			longitudNegocio varchar(max)
		)
		declare @gps table(
			idGPSGEO  int,
			idCliente int,
			idProspecto  int,
			idFiador int,
			idGrupoAdesco int,
			latitud varchar(50),
			longitud varchar(50),
			casa int,
			address varchar(200),
			street_number varchar(50),
			route varchar(100),
			locality varchar(100),
			administrative_area_level_2 varchar(100),
			administrative_area_level_1 varchar(100),
			country varchar(50),
			postal_code varchar(50),
			autorizarGEO int
		)
		declare @gp table(
			idProspecto int,
			idGrupoAdesco int
		)
		declare @cg table(
			idGrupoAdesco int,
			latitud varchar(max),
			longitud varchar(max)
		)
		declare @tc table(
			idCliente int,
			telefono varchar(max),
			fecha varchar(max)
		)
		declare @fd table(
			idFiador int,
			latitud varchar(max),
			longitud varchar(max),
			latitudNegocio varchar(max),
			longitudNegocio varchar(max),
			autorizarGEOCasa int,
			autorizarGEONegocio int
		)
		declare @ga table(
			idGrupoAdesco int,
			estado int
		)
		declare @rch table(
			idProspecto int,
			rechazado int
		)
		declare @obs table(
			idPreguntaRS int,
			idPregunta int,
			idEncuestaR int,
			idProspecto int,
			observacion varchar(max),
			api varchar(max),
			idRespuesta int,
			idRespuestaT varchar(max),
			idRM varchar(max),
			idRegistroActividad int
		)
		declare @api table(
			idPreguntaRS int,
			idPregunta int,
			idEncuestaR int,
			idProspecto int,
			observacion varchar(max),
			api varchar(max),
			idRespuesta int,
			idRespuestaT int,
			idRegistroActividad int
		)
		declare @acp table(
			isValid bit,
			idAP int,
			idRegistroActividad int,
			idCredito int,
			asistencia int,
			renovacion int,
			idCF int,
			cuota float,
			ahorro decimal(10,2)
		)

		insert @ra select *from openjson(@data,'$.registroActividades')
			with(
				idRegistroActividad int,
				idActividad int,
				idReaccion int,
				idDetalle int,
				idMotivo int,
				idCredito int,
				idCliente int,
				idClienteP int,
				idClienteCampania int,
				idCampania int,
				idEncuesta int,
				idProspecto int,
				idFiador int,
				idOrganizacion int,
				idGrupo int,
				diasGestion int,
				idPrioridad int,
				diasPrioridad int,
				distancia float,
				tipoP int,
				fechaGestion varchar(max),
				fechaVisitaReprogramada varchar(max),
				horaGPS varchar(max),
				idGestor int,
				latitud varchar(max),
				longitud varchar(max),
				observacion varchar(max),
				participantes int,
				telefono varchar(max),
				etapa int,
				d1 varchar(max),
				d2 varchar(max),
				d3 varchar(max),
				d4 varchar(max),
				eventos varchar(max),
				ID int,
				idProspectoS int,
				idEncuestaRS int,
				whatsapp int,
				gestionado int,
				idRuta int
			)
		insert @us select *from openjson(@data,'$.usuario')
		with(
			idGestor int,
			UID varchar(max),
			sessionid varchar(max)
		)
		declare @idActividad int,@idGestor int,@idAgencia int, @fecha datetime,@parcial bit=0,@prospectos bit=0,@grupos bit=0,@action varchar(max),@strParcial nvarchar(max)=''
		declare @sp varchar(max)=''''

		select
			@idGestor = g.idGestor,
			@idAgencia = g.idAgencia
		from @us u inner join
		gestores g on  g.idGestor = u.idGestor

		select top 1 @idActividad = idActividad, @fecha = try_parse(fechaGestion as datetime using 'es-ES') from @ra
		select @parcial = parcial from openjson(@data)with(parcial bit)
		insert @img select *from openjson(@data,'$.imagenes')
		with(
			idImagen int,
			idPreguntaR int,
			idPreguntaRS int,
			idRegistroActividad int,
			idGestor int,
			idActividad int,
			idCliente int,
			idFiador int,
			idGrupoAdesco int,
			alias varchar(max),
			casa int,
			interior int,
			nombre varchar(max),
			tipo int,
			idPregunta int,
			idImagenS int,
			idProspectoS int,
			fecha varchar(max),
			GPS int,
			received int,
			d4 int
		)
		insert @e select *from openjson(@data,'$.encuestas')
		with(
			idEncuestaR int,
			idRegistroActividad int,
			idCredito int,
			idProspecto int,
			idEncuesta int,
			idFormulario int,
			codigo varchar(max),
			fecha varchar(max),
			idGestor int,
			latitud varchar(max),
			longitud varchar(max),
			prospecto int,
			puntosP float,
			idEncuestaRS int,
			idProspectoS int,
			rechazado int,
			etapa int,
			totalF int,
			totalFR int
		)
		insert @f select *from openjson(@data,'$.formularios')
		with(
			idFormularioR int,
			idEncuestaR int,
			idFormulario int,
			totalCampos int,
			fechaCreacion varchar(max),
			idFormularioRS int,
			idEncuestaRS int,
			idProspectoS int
		)
		insert @rsp select *from openjson(@data,'$.respuestas')
		with(
			idPreguntaR int,
			idEncuestaR int,
			idPregunta int,
			idFormulario int,
			idRespuesta int,
			idRespuestaT varchar(max),
			observacion varchar(max),
			api varchar(max),
			idFormularioR int,
			idEncuestaRS int,
			idProspectoRS int,
			idPreguntaRS int,
			idRM varchar(max),
			IDT varchar(max),
			d1 varchar(max),
			g int,
			p int,
			lp int,
			gp int,
			[readOnly] int,
			incorrect int
		)
		insert @pp select *from openjson(@data,'$.promesas')
		with(
			idPromesa int,
			idRegistroActividad int,
			idCredito int,
			idGrupoAdesco int,
			idGestor int,
			montoPrometido float,
			fechaPromesa varchar(max)
		)
		insert @dr select *from openjson(@data,'$.depositos')
		with(
			idDeposito int,
			idRegistroActividad int,
			idCredito int,
			idGrupoAdesco int,
			idGestor int,
			montoDepositoo float,
			fechaDeposito varchar(max)
		)
		insert @dp select *from openjson(@data,'$.detallePagos')
		with(
			idDetalle int,
			montoPorCobrar float,
			numeroComprobante varchar(max),
			fechaPago varchar(max),
			idCredito int,
			idGestor int,
			idRegistroActividad int
		)
		insert @pc select *from openjson(@data,'$.pagos')
		with(
			idDetalle int,
			montoPorCobrar float,
			numeroComprobante varchar(max),
			fechaPago varchar(max),
			idCredito int,
			idGestor int,
			idRegistroActividad int,
			idGrupoAdesco int
		)
		insert @cl select *from openjson(@data,'$.clientes')
		with(
			idCliente int,
			latitud varchar(max),
			longitud varchar(max),
			latitudNegocio varchar(max),
			longitudNegocio varchar(max),
			autorizarGEOCasa int,
			autorizarGEONegocio int
		)
		insert @cp select *from openjson(@data,'$.GPSProspectos')
		with(
			idProspecto int,
			latitud varchar(max),
			longitud varchar(max),
			latitudNegocio varchar(max),
			longitudNegocio varchar(max)
		)
		insert @gps select * from openjson(@data,'$.gpsgeo')
		with(
			idGPSGEO  int,
			idCliente int,
			idProspecto  int,
			idFiador int,
			idGrupoAdesco int,
			latitud varchar(50),
			longitud varchar(50),
			casa int,
			address varchar(200),
			street_number varchar(50),
			route varchar(100),
			locality varchar(100),
			administrative_area_level_2 varchar(100),
			administrative_area_level_1 varchar(100),
			country varchar(50),
			postal_code varchar(50),
			autorizarGEO int
		)
		insert @gp select *from openjson(@data,'$.gruposProspecto')
		with(
			idProspecto int,
			idGrupoAdesco int
		)
		insert @cg select *from openjson(@data,'$.gruposGEO')
		with(
			idGrupoAdesco int,
			latitud varchar(max),
			longitud varchar(max)
		)
		insert @tc select *from openjson(@data,'$.telefonosCliente')
		with(
			idCliente int,
			telefono varchar(max),
			fecha varchar(max)
		)
		insert @fd select *from openjson(@data,'$.fiadores')
		with(
			idFiador int,
			latitud varchar(max),
			longitud varchar(max),
			latitudNegocio varchar(max),
			longitudNegocio varchar(max),
			autorizarGEOCasa int,
			autorizarGEONegocio int
		)
		insert @ga select *from openjson(@data,'$.gruposAdesco')
		with(
			idGrupoAdesco int,
			estado int
		)
		insert @rch select *from openjson(@data,'$.rechazados')
		with(
			idProspecto int,
			rechazado int
		)
		insert @obs select *from openjson(@data,'$.observaciones')
		with(
			idPreguntaRS int,
			idPregunta int,
			idEncuestaR int,
			idProspecto int,
			observacion varchar(max),
			api varchar(max),
			idRespuesta int,
			idRespuestaT varchar(max),
			idRM varchar(max),
			idRegistroActividad int
		)
		insert @api select *from openjson(@data,'$.respuestasApi')
		with(
			idPreguntaRS int,
			idPregunta int,
			idEncuestaR int,
			idProspecto int,
			observacion varchar(max),
			api varchar(max),
			idRespuesta int,
			idRespuestaT int,
			idRegistroActividad int
		)
		insert @acp select *from openjson(@data,'$.acuerdos')
		with(
			isValid bit,
			idAP int,
			idRegistroActividad int,
			idCredito int,
			asistencia int,
			renovacion int,
			idCF int,
			cuota float,
			ahorro decimal(10,2)
		)

		update @tc
		set
			fecha = @fecha
		where fecha is null

		update @ra
		set
			fechaGestion = format(try_parse(fechaGestion as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff'),
			fechaVisitaReprogramada = format(try_parse(fechaVisitaReprogramada as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff'),
			horaGPS = format(try_parse(horaGPS as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss'),
			idActividad = IIF(idActividad = -1,dbo.fActividad('SLC'),idActividad),
			d1=iif(d1='',null,d1),
			d2=iif(d2='',null,d2),
			d3=iif(d3='',null,d3),
			d4=iif(d4='',null,d4)

		update s
		set
			fecha = format(try_parse(fecha as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff'),
			totalF = (select count(1) from formularios with(nolock) where estado=1 and idEncuesta= t.idEncuesta),
			codigo = tp.codigo
		from @e s
		inner join encuestas t with(nolock) on t.idEncuesta = s.idEncuesta
		inner join tiposEncuesta tp with(nolock) on tp.idTipoEncuesta = t.idTipoEncuesta

		update @f
		set
		fechaCreacion = format(try_parse(fechaCreacion as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff')

		update @pp
		set
		fechaPromesa = format(try_parse(fechaPromesa as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff')

		update @dr
		set
		fechaDeposito = format(try_parse(fechaDeposito as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff')

		update @dp
		set
		fechaPago = format(try_parse(fechaPago as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff')

		update @gps
		set
			latitud = iif(latitud = '',null,latitud),
			longitud = iif(longitud = '',null,longitud),
			autorizarGEO = coalesce(autorizarGEO,0)

		update @img set fecha = format(try_parse(fecha as datetime using 'es-ES'),'yyyy-MM-dd HH:mm:ss.fff')

		update t
			set observacion = format(try_parse(t.observacion as datetime using 'es-ES'),'yyyy-MM-dd')
		from @rsp t
		inner join preguntas p with(nolock) on t.idPregunta = p.idPregunta
		inner join formatos f with(nolock) on f.idFormato = p.idFormato
		where f.tipo = 'date'

		update ra
		set
			ra.ID = r.idRegistroActividad,
			ra.gestionado = 1,
			ra.idRuta = 0
		from @ra ra
		left join registroActividades r with(nolock) on r.fecha = ra.fechaGestion and r.idGestor = ra.idGestor

		--Insertar coordenadas
			if((select count(1) from @gps) > 0 ) begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Coordenadas')

				insert GEO (idCliente, idProspecto, idFiador, idGrupoAdesco, latitud, longitud, casa, address, street_number, route
				,locality, administrative_area_level_2, administrative_area_level_1, country,postal_code,fechaGEO,IdGestor)
				select
					t.idcliente,
					t.idProspecto,
					t.idFiador,
					t.idGrupoAdesco,
					t.latitud,
					t.longitud,
					t.casa,
					t.address,
					t.street_number,
					t.route,
					t.locality,
					t.administrative_area_level_2,
					t.administrative_area_level_1,
					t.country,
					t.postal_code,
					getdate(),
					null
				from @gps t

			end

		--Actualizando coordenadas de cliente
			if(select count(1) from @gps where idCliente is not null) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Coordenadas de cliente')

				update @gps
				set
					autorizarGEO = iif((s.latitud is null and t.casa = 1) or (s.latitudNegocio is null and t.casa = 0),0,@autorizarGeoPic)
				from @gps t
				inner join clientes s with(nolock) on s.idCliente = t.idCliente

				update t
				set
					t.latitud = iif(s.autorizarGEO = 1 and t.latitud is not null, t.latitud, coalesce(s.latitud,t.latitud)),
					t.longitud = iif(s.autorizarGEO = 1 and t.longitud is not null, t.longitud, coalesce(s.longitud,t.longitud)),
					t.pendienteCasa = iif(s.autorizarGEO = 1 and s.latitud is not null,1,0),
					t.fechaGPSCasa = iif(s.autorizarGEO = 1 and t.latitud is not null,t.fechaGPSCasa, iif(s.latitud is not null,current_timestamp,t.fechaGPSCasa))
				from @gps s
				inner join clientes t with(nolock) on s.idCliente = t.idCliente
				where s.casa = 1

				update t
				set
					t.latitudNegocio = iif(s.autorizarGEO = 1 and t.latitudNegocio is not null, t.latitudNegocio, coalesce(s.latitud,t.latitudNegocio)),
					t.longitudNegocio = iif(s.autorizarGEO = 1 and t.longitudNegocio is not null, t.longitudNegocio, coalesce(s.longitud,t.longitudNegocio)),
					t.pendienteNegocio = iif(s.autorizarGEO = 1 and s.latitud is not null,1,0),
					t.fechaGPSNegocio = iif(s.autorizarGEO = 1 and t.latitudNegocio is not null,t.fechaGPSNegocio, iif(s.latitud is not null,current_timestamp,t.fechaGPSNegocio))
				from @gps s
				inner join clientes t with(nolock) on s.idCliente = t.idCliente
				where s.casa = 0

			end
			
			if(select count(1) from @cl) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Coordenadas de cliente')

				update @cl
				set
					autorizarGEOCasa = iif(s.latitud is null,0,@autorizarGeoPic),
					autorizarGEONegocio = iif(s.latitudNegocio is null,0,@autorizarGeoPic)
				from @cl t
				inner join clientes s with(nolock) on s.idCliente = t.idCliente

				update t
				set
					latitud = iif(s.autorizarGEOCasa = 1 and t.latitud is not null, t.latitud, coalesce(s.latitud,t.latitud)),
					longitud = iif(s.autorizarGEOCasa = 1 and t.longitud is not null, t.longitud, coalesce(s.longitud,t.longitud)),
					latitudNegocio = iif(s.autorizarGEONegocio = 1 and t.latitudNegocio is not null, t.latitudNegocio, coalesce(s.latitudNegocio,t.latitudNegocio)),
					longitudNegocio = iif(s.autorizarGEONegocio = 1 and t.longitudNegocio is not null, t.longitudNegocio, coalesce(s.longitudNegocio,t.longitudNegocio)),
					pendienteCasa = iif(s.autorizarGEOCasa = 1 and s.latitud is not null,1,0),
					pendienteNegocio = iif(s.autorizarGEONegocio = 1 and s.latitudNegocio is not null,1,0),
					fechaGPSCasa = iif(s.autorizarGEOCasa = 1 and t.latitud is not null,t.fechaGPSCasa, iif(s.latitud is not null,current_timestamp,t.fechaGPSCasa)),
					fechaGPSNegocio = iif(s.autorizarGEONegocio = 1 and t.latitudNegocio is not null,t.fechaGPSNegocio, iif(s.latitudNegocio is not null,current_timestamp,t.fechaGPSNegocio))
				from @cl s
				inner join clientes t with(nolock) on t.idCliente = s.idCliente
			end

		--Insertando TelefonosCliente
			if(select count(1) from @tc) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Teléfonos de cliente')

				insert telefonosCliente
				(idCliente,telefono,fecha)
				select
					s.idCliente,
					s.telefono,
					GETDATE()
				from @tc s
				left join telefonosCliente t with(nolock) on s.idCliente = t.idCliente and s.telefono = t.telefono
				where t.idTelefono is null

				update t
				set
					telefono = s.telefono,
					fecha = GETDATE()
				from @tc s
				inner join telefonosCliente t with(nolock) on s.idCliente = t.idCliente and s.telefono = t.telefono
			end

		--Insertando Coordendas de fiador
			if(select count(1) from @fd)>0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Coordendas de fiador')

				update @fd
				set
					autorizarGEOCasa = iif(s.latitud is null,0,@autorizarGeoPic),
					autorizarGEONegocio = iif(s.latitudNegocio is null,0,@autorizarGeoPic)
				from @fd t
				inner join fiadores s with(nolock) on s.idFiador = t.idFiador

				update t
				set
					latitud = iif(s.autorizarGEOCasa = 1 and t.latitud is not null, t.latitud, coalesce(s.latitud,t.latitud)),
					longitud = iif(s.autorizarGEOCasa = 1 and t.longitud is not null, t.longitud, coalesce(s.longitud,t.longitud)),
					latitudNegocio = iif(s.autorizarGEONegocio = 1 and t.latitudNegocio is not null, t.latitudNegocio, coalesce(s.latitudNegocio,t.latitudNegocio)),
					longitudNegocio = iif(s.autorizarGEONegocio = 1 and t.longitudNegocio is not null, t.longitudNegocio, coalesce(s.longitudNegocio,t.longitudNegocio)),
					pendienteCasa = iif(s.autorizarGEOCasa = 1 and s.latitud is not null,1,0),
					pendienteNegocio = iif(s.autorizarGEONegocio = 1 and s.latitudNegocio is not null,1,0),
					fechaGPSCasa = iif(s.autorizarGEOCasa = 1 and t.latitud is not null,t.fechaGPSCasa, iif(s.latitud is not null,current_timestamp,t.fechaGPSCasa)),
					fechaGPSNegocio = iif(s.autorizarGEONegocio = 1 and t.latitudNegocio is not null,t.fechaGPSNegocio, iif(s.latitudNegocio is not null,current_timestamp,t.fechaGPSNegocio))
				from @fd s
				inner join fiadores t with(nolock) on s.idFiador = t.idFiador
			end

		--Actualizando CoordenadasProspecto
			if(select count(1) from @gps where idProspecto is not null) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Coordenas de prospectos ')

				update t
				set
					latitud = iif(s.latitud != '' or s.latitud is not null,s.latitud,t.latitud),
					longitud = iif(s.longitud != '' or s.longitud is not null,s.longitud,t.longitud),
					fechaGPSCasa = iif(s.latitud is not null,current_timestamp,t.fechaGPSCasa)
				from @gps s
				inner join prospectos t with(nolock) on s.idProspecto = t.idProspecto and s.casa = 1

				update t
				set
					latitudNegocio = iif(s.latitud != '' or s.latitud is not null,s.latitud,t.latitudNegocio),
					longitudNegocio = iif(s.longitud != '' or s.longitud is not null,s.longitud,t.longitudNegocio),
					fechaGPSNegocio = iif(s.latitud is not null,current_timestamp,t.fechaGPSNegocio)
				from @gps s
				inner join prospectos t with(nolock) on s.idProspecto = t.idProspecto and s.casa = 0
			end

            if(select count(1) from @cp) > 0 begin
                if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Coordenas de prospectos ')

                update t
                set
                    latitud = iif(s.latitud != '' or s.latitud is not null,s.latitud,t.latitud),
                    longitud = iif(s.longitud != '' or s.longitud is not null,s.longitud,t.longitud),
                    latitudNegocio = iif(s.latitudNegocio != '' or s.latitudNegocio is not null,s.latitudNegocio,t.latitudNegocio),
                    longitudNegocio = iif(s.longitudNegocio != '' or s.longitudNegocio is not null,s.longitudNegocio,t.longitudNegocio),
                    fechaGPSCasa = iif(s.latitud is not null,current_timestamp,t.fechaGPSCasa),
                    fechaGPSNegocio = iif(s.latitudNegocio is not null,current_timestamp,t.fechaGPSNegocio)
                from prospectos t
                inner join @cp s on s.idProspecto = t.idProspecto
            end

		--Actualizando GrupoAdesco a prospecto
			if(select count(1) from @gp) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Grupos a prospecto ')

				update t
				set
					idGrupoAdesco = s.idGrupoAdesco
				from @gp s
				inner join prospectos t with(nolock) on s.idProspecto = t.idProspecto
			end

		--Actualizando coordenadas a gruposAdescco
			if(select count(1) from @cg) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Coordenadas a grupo ')

				update t
				set
					latitud = iif(s.latitud != '' or s.latitud is not null,s.latitud,t.latitud),
					longitud = iif(s.longitud != '' or s.longitud is not null,s.longitud,t.longitud)
				from @cg s
				inner join gruposAdesco t with(nolock) on s.idGrupoAdesco = t.idGrupoAdesco
			end

		--Cerrando gruposAdesco
			if(select count(1) from @ga) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Cerrando grupos ')

				update t
				set
					idEstado = 3
				from @ga s
				inner join gruposAdesco t with(nolock) on s.idGrupoAdesco = t.idGrupoAdesco
			end

		--Rechazando prospectos desde Android
			if(select count(1) from @rch) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Prospectos rechazados desde Aplicativo ')

				insert etapasProspecto
				(idProspecto,fecha,idFormulario,idGestor,totalCampos,etapa)
				select
					p.idProspecto,
					current_timestamp,
					null,--idFormulario
					p.idGestor,
					null,--totalCampos
					6 --rechazado
				from etapasProspecto et with(nolock)
				right outer join @rch s on s.idProspecto = et.idProspecto
				inner join prospectos p with(nolock) on p.idProspecto = s.idProspecto
				where p.rechazado is null

				update t
				set
					etapa = 6,	--etapa de rechazado
					rechazado = s.rechazado --Enlazado con motivoActividades
				from @rch s
				inner join prospectos t with(nolock) on s.idProspecto = t.idProspecto
			end

		--Insertando registroActividades
			--Insertando RegistroActividades inexistentes
			if (select count(1) from @ra where ID is null) > 0  begin
				insert registroActividades
				(idActividad,idReaccion,idDetalle,idMotivo,idCredito,idCliente,idClienteP,idClienteCampania,idCampania,idProspecto,idOrganizacion,idGrupo,diasGestion,idPrioridad,
				diasPrioridad,fecha,fechaVisitaReprogramada,horaGPS,idGestor,latitud,longitud,observacion,participantes,telefono,etapa,fechaRegistro,idFiador,whatsapp)
				select
					s.idActividad,
					s.idReaccion,
					s.idDetalle,
					s.idMotivo,
					s.idCredito,
					s.idCliente,
					s.idClienteP,
					s.idClienteCampania,
					s.idCampania,
					s.idProspecto,
					s.idOrganizacion,
					s.idGrupo,
					s.diasGestion,
					s.idPrioridad,
					s.diasPrioridad,
					s.fechaGestion,
					s.fechaVisitaReprogramada,
					s.horaGPS,
					s.idGestor,
					s.latitud,
					s.longitud,
					s.observacion,
					s.participantes,
					s.telefono,s.etapa,
					current_timestamp,
					s.idFiador,
					s.whatsapp
				from @ra s
				where s.ID is null

				update s
				set
					ID = r.idRegistroActividad
				from @ra s
				inner join registroActividades r with(nolock) on r.fecha = s.fechaGestion and r.idGestor=s.idGestor
			end

			--Marcando bandera de gestionado para clientes de campaña
			if (select count(1) from @ra where idClienteCampania is not null ) > 0 begin
				--Buscando creditos gestionados para evitar volver a actualizar bandera
				update r
				set
					gestionado = 0
				from @ra r
				inner join clientesCampania cc with(nolock) on cc.idClienteCampania = r.idClienteCampania
				where cc.gestionado = 1

				update cc
				set
					gestionado = 1
				from @ra r
				inner join clientesCampania  cc with(nolock) on cc.idClienteCampania = r.idClienteCampania
				where r.gestionado = 1
			end

			--Marcando como gestionado los creditos encontrados.
			if(select count(1) from @ra where idCredito is not null) > 0 begin
				--Buscando creditos gestionados para evitar volver a actualizar bandera
				update r
				set
					gestionado = 0
				from @ra r
				inner join creditos c with(nolock) on c.idCredito = r.idCredito
				where c.gestionado = 1 and r.idClienteCampania is null

				update c
				set
					gestionado = 1
				from @ra r
				inner join creditos c with(nolock) on c.idCredito = r.idCredito
				where r.gestionado = 1 and r.idClienteCampania is null
			end

			--Marcando bandera de gestionado para grupos de clientes
			if (select count(1) from @ra where idGrupo is not null) > 0 begin

				update r
				set
					gestionado = 0
				from @ra r
				inner join gruposAdesco ga with(nolock) on ga.idGrupoAdesco = r.idGrupo
				where ga.gestionado = 1

				update ga
				set
					gestionado = 1
				from @ra r
				inner join gruposAdesco ga with(nolock) on ga.idGrupoAdesco = r.idGrupo
				where r.gestionado = 1
			end

			--Marcando bandera gestionado para clientes en ruta
			if (select count(1) from @ra where coalesce(idCredito,idClienteCampania,idGrupo,idProspecto) is not null) > 0 begin
				update r
				set
					idRuta = rt.idRuta
				from @ra r
				inner join rutas rt with(nolock) on rt.fecha = cast(r.fechaGestion as date) and rt.idGestor = r.idGestor and  coalesce(rt.idClienteCampania,rt.idCredito,rt.idProspecto,rt.idGrupoAdesco) =  coalesce(r.idClienteCampania,r.idCredito,r.idProspecto,r.idGrupo)
				where coalesce(rt.gestionado,0)=0

				update rt
				set
					gestionado = 1
				from @ra r
				inner join rutas rt with(nolock) on rt.idRuta = r.idRuta
			end

			--Procesando visitas reprogramadas
			if (select count(1) from @ra where fechaVisitaReprogramada is not null) > 0 begin
				insert VisitasReprogramadas
				(fechaGestion,idCredito,idGestor,realizada,idRegistroActividad,idActividad,fechaVisita,idCampania,idClienteP)
				select
					s.fechaGestion,
					s.idCredito,
					s.idGestor,
					0,
					s.ID,
					s.idActividad,
					s.fechaVisitaReprogramada,
					s.idCampania,
					s.idClienteP
				from @ra s
				left join VisitasReprogramadas t with(nolock) on t.idRegistroActividad = s.ID and t.idGestor = s.idGestor
				where t.idRegistroActividad is null and fechaVisitaReprogramada is not null

				-- Insertando visitas reprogramadas a Agenda
				if(@addVRRuta = 1) begin
					insert rutasAgendadas
					(fecha,idCredito,idGestor,idActividad,idClienteCampania,estado)
					select
						r.fechaVisitaReprogramada,
						r.idCredito,
						r.idGestor,
						null,
						r.idClienteCampania,
						1
					from @ra r
					left join rutasAgendadas rua on rua.idGestor = r.idGestor and rua.fecha = r.fechaVisitaReprogramada and coalesce(rua.idClienteCampania,rua.idCredito) = coalesce(r.idClienteCampania,r.idCredito)
					where r.fechaVisitaReprogramada is not null and rua.idRutaAgendada is null
				end
			end

		--Insertando Promesas de pago
			if(select count(1) from @pp) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Promesas de pago')

				insert promesasPago
				(idRegistroActividad,idCredito,idGrupoAdesco,idGestor,montoPrometido,montoPagado,fechaPromesa,fechaGestion,diasPromesa)
				select
					ra.ID as idRegistroActividad,
					s.idCredito,
					s.idGrupoAdesco,
					ra.idGestor,
					s.montoPrometido,
					0 as montoPagado,
					s.fechaPromesa,
					ra.fechaGestion,
					0 as diasPromesa
				from @pp s
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad
				left join promesasPago t with(nolock) on t.idRegistroActividad = ra.ID
				where t.idRegistroActividad is null

				-- Insertando promesas a Agenda
				if(@addAPRuta = 1) begin
					insert rutasAgendadas(fecha,idCredito,idGrupoAdesco,idGestor,estado)
					select
						s.fechaPromesa,
						s.idCredito,
						s.idGrupoAdesco,
						s.idGestor,
						1
					from @pp s
					left join rutasAgendadas rua with(nolock) on rua.idGestor = s.idGestor and rua.fecha = s.fechaPromesa and coalesce(rua.idCredito,rua.idGrupoAdesco) = coalesce(s.idCredito,s.idGrupoAdesco)
					where rua.idRutaAgendada is null
				end
			end

		---Insertando Deposito de Pago
			if(select count(1) from @dr) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Deposito de pago')

				insert depositoPago
				(idRegistroActividad,idCredito,idGrupoAdesco,idGestor,montoDepositoo,fechaDeposito)
				select
					ra.ID as idRegistroActividad,
					s.idCredito,
					s.idGrupoAdesco,
					ra.idGestor,
					s.montoDepositoo,
					s.fechaDeposito
				from @dr s
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad
				left join depositoPago t with(nolock) on t.idRegistroActividad = ra.ID
				where t.idRegistroActividad is null
			end

		--Insertando Detalles de pago
			if (select count(1) from @dp) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Detalles de pago')

				insert detallePago
				(montoPorCobrar,numeroComprobante,fechaPago,idCredito,idGestor,idRegistroActividad)
				select
					s.montoPorCobrar,
					s.numeroComprobante,
					s.fechaPago,
					s.idCredito,
					ra.idGestor,
					ra.ID as idRegistroActividad
				from @dp s
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad
				left join detallePago t with(nolock) on t.idRegistroActividad = ra.ID
				where t.idRegistroActividad is null
			end

		--Insertando Pagos
			if (select count(1) from @pc) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Detalles de pago')

				insert detallePago
				(montoPorCobrar,numeroComprobante,fechaPago,idCredito,idGestor,idRegistroActividad,idGrupoAdesco)
				select
					s.montoPorCobrar,
					s.numeroComprobante,
					s.fechaPago,
					s.idCredito,
					ra.idGestor,
					ra.ID as idRegistroActividad,
					s.idGrupoAdesco
				from @pc s
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad
				left join detallePago t with(nolock) on t.idRegistroActividad = ra.ID
				where t.idRegistroActividad is null
			end

		--Insertando imagenesActividad
			if(select count(1) from @img where idRegistroActividad is not null and idPreguntaR is null) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Imágenes de actividad ')

				insert imagenesActividad
				(nombre,idRegistroActividad,fecha,estado)
				select
					s.nombre,
					r2.idRegistroActividad,
					s.fecha,
					0 as estado
				from imagenesActividad t with(nolock)
				right outer join @img s on s.fecha = t.fecha
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad
				inner join registroActividades r2 with(nolock) on r2.fecha = ra.fechaGestion and r2.idGestor = @idGestor
				where t.idImagen is null and s.idCliente is null and s.idFiador is null and s.idGrupoAdesco is null and idPreguntaR is null and idPreguntaRS is null

				update t
				set
					idImagenS = s.idImagen
				from @img t
				inner join imagenesActividad s with(nolock) on s.fecha = t.fecha

				update t
				set
					url = concat('agencia',g.idAgencia,'/gestor',g.idGestor,'/actividad',r.idActividad,'/img_',s.idImagenS,substring(s.nombre,PatIndex('%.%',s.nombre),len(s.nombre)))
				from imagenesActividad t with(nolock)
				inner join @img s on s.fecha = t.fecha
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad
				inner join registroActividades r with(nolock) on r.fecha = ra.fechaGestion and r.idGestor = @idGestor
				inner join gestores g with(nolock) on g.idGestor = s.idGestor
				where t.estado = 0
			end

		--Insertando imagenesGPS
			if(select count(1) from @img where idRegistroActividad is null) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Imágenes GPS')

				if(object_id('tempdb..#img') is not null)drop table #img
				select
					img.idImagen,
					img.nombre,
					img.idCliente,
					img.idFiador,
					img.idGrupoAdesco,
					c.autorizarGEO as autorizarGEOCasa,
					n.autorizarGEO as autorizarGEONegocio,
					anchor = iif((c.autorizarGEO=1 and img.casa = 1) or (n.autorizarGEO=1 and img.casa = 0),'#autorizar',''),
					latitud = coalesce(c.latitud,coalesce(fd.latitud,ga.latitud)),
					longitud = coalesce(c.longitud,coalesce(fd.longitud,ga.longitud)),
					latitudNegocio = coalesce(n.latitud,fd.latitudNegocio),
					longitudNegocio = coalesce(n.longitud,fd.longitudNegocio),
					img.casa,
					img.interior,
					img.idGestor,
					coalesce(img.fecha,format(current_timestamp,'yyyy-MM-dd HH:mm:ss')) as fecha
				into #img from @img img
				left join @gps c on c.idCliente = img.idCliente and c.casa = 1
				left join @gps n on n.idCliente = img.idCliente and n.casa = 0
				left join @fd fd on fd.idFiador = img.idFiador
				left join @cg ga on ga.idGrupoAdesco = img.idGrupoAdesco
				where img.GPS = 1

				insert imagenesGPS
				(nombre,idCliente,idFiador,casa,interior,idGrupo,idGestor,fecha,estado)
				select
					s.nombre,
					s.idCliente,
					s.idFiador,
					s.casa,
					s.interior,
					s.idGrupoAdesco,
					s.idGestor,
					s.fecha,
					0 as estado
				from imagenesGPS t with(nolock)
				right outer join #img s on s.fecha = t.fecha and (s.idCliente = t.idCliente or s.idFiador = t.idFiador or s.idGrupoAdesco = t.idGrupo) and s.casa = t.casa and s.interior = t.interior and (t.estado != 1 or t.idImagen is not null)
				inner join gestores g with(nolock) on g.idGestor = s.idGestor
				where t.idImagen is null

				update t
				set
					url = concat(
						'agencia',g.idAgencia,
						'/gestor',g.idGestor,
						'/GPS',iif(s.idCliente is not null,'clientes',iif(s.idFiador is not null,'fiadores',iif(s.idGrupoAdesco is not null,'grupos','undefined'))),
						'/',iif(s.interior=1,'int_','ext_'),iif(s.casa=1,'c','n'),coalesce(s.idCliente,coalesce(s.idFiador,s.idGrupoAdesco)),'_TMP',substring(s.nombre,PatIndex('%.%',s.nombre),len(s.nombre)),s.anchor
					),
					latitud = iif(s.casa = 1, s.latitud, s.latitudNegocio),
					longitud = iif(s.casa = 1, s.longitud,s.longitudNegocio),
					fecha = s.fecha,
					estado = 0
				from imagenesGPS t with(nolock)
				inner join #img s on (s.idCliente = t.idCliente or s.idFiador = t.idFiador or s.idGrupoAdesco = t.idGrupo) and s.casa = t.casa and s.interior = t.interior and t.estado != 1
				inner join gestores g with(nolock) on g.idGestor = s.idGestor
				where t.estado in(0,2) and t.url is null

				update t
				set
					idImagenS = s.idImagen,
					GPS = 1
				from @img t
				inner join imagenesGPS s with(nolock) on s.fecha = t.fecha and s.idGestor = @idGestor
			end

		--Actualizando D4 de Prospectos
			if((select count(1) from @ra where idProspecto is not null) > 0)begin
				update p set
					p.d1 = r.d1,
					p.d2 = r.d2,
					p.d3 = r.d3,
					p.d4 = r.d4,
					actualizado = 1
				from prospectos p with(nolock)
				inner join @ra r on r.idProspecto = p.idProspecto

				update i 
				set 
					idProspectoS = p.idProspecto
				from @img i
				inner join @ra r on r.idRegistroActividad = i.idRegistroActividad
				inner join prospectos p on p.idProspecto = r.idProspecto

				set @prospectos = 1
			end

		--Insertando prospectos
			declare @TotalE int = (select count(1) from @e), @indexE int = 1
			if @TotalE > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Prospectos')

				set @prospectos = iif((select count(1) from @e where codigo !='GRP')>0,1,0)
				set @grupos = iif((select count(1) from @e where codigo='GRP')>0,1,0)

				if(object_id('tempdb..#e') is not null)drop table #e
				select ROW_NUMBER() over(order by idEncuestaR) as PX,* into #e from @e
			--Insertando prospectos
				while @indexE <= @TotalE begin
					declare @idProspecto int=null,@idEncuestaR int=null, @fechaE datetime=null,@idRegistroActividad2 int=null,@idEncuesta int = null,@etapa1 int = 1,@etapa2 int = 1,@idFormulario int = 1,@idR int=null
					declare @puntosP float=null, @idCreditoE int=null, @codigoE varchar(max)=null,@idGrupoAdesco int=null,@d1E varchar(max)=null,@d2E varchar(max)=null,@tipoP int=null,@solicitudNueva int = 0,@d3E varchar(max)=null,@d4E varchar(max)=null,@eventos varchar(max) = null
					declare @rechazado int = null
					select
						@idGestor = e.idGestor,
						@fechaE = e.fecha,
						@idProspecto = e.idProspecto,
						@idRegistroActividad2 = ra.ID,
						@idR = e.idRegistroActividad,
						@d1E = ra.d1,
						@d2E = ra.d2,
						@d3E = ra.d3,
						@d4E = ra.d4,
						@eventos = ra.eventos,
						@puntosP = puntosP,
						@idCreditoE = e.idCredito,
						@codigoE = codigo,
						@tipoP = ra.tipoP,
						@idEncuesta = e.idEncuesta,
						@idEncuestaR = e.idEncuestaR,
						@rechazado = e.rechazado
					from #e e
					inner join @ra ra on ra.idRegistroActividad = e.idRegistroActividad
					where e.PX = @indexE

					if(@idProspecto is null)begin
						select
							@idProspecto = idProspecto
						from prospectos with(nolock) where idGestor = @idGestor and fecha = @fechaE
					end

					if @idProspecto is null begin
						insert prospectos
						(fecha,idGestor,puntosPrecalificacion,actualizado,enProceso,idCredito,rechazado,d1)
						select
							s.fecha,
							s.idGestor,
							s.puntosP,
							actualizado = 1,
							enProceso = 1,
							s.idCredito,--solo es aplicable para renovables,
							s.rechazado, --Enlazado con la tabla motivoActividades
							@d1E
						from #e s
						where s.PX = @indexE and fecha is not null

						set @solicitudNueva = 1
						set @idProspecto = SCOPE_IDENTITY()
					end

					--Modificando URL a imagenes
					update r
					set
						observacion = concat('agencia',@idAgencia,'/gestor',@idGestor,'/prospecto',@idProspecto,'/img_',i.idPregunta,substring(observacion,PatIndex('%.%',observacion),len(observacion)),'#prev')
					from @rsp r
					inner join @img i on i.idPregunta = r.idPregunta and i.idPreguntaR = r.idPreguntaR
					where r.idEncuestaR = @idEncuestaR

					set @etapa1 = (select etapa from prospectos where idProspecto = @idProspecto)
					declare @respuestas1 nvarchar(max) = coalesce((select respuestas from prospectos where idProspecto = @idProspecto),'[]')
					declare @respuestas2 nvarchar(max) = coalesce((
						select
							f.idFormulario,
							fechaCreacion,
							f.totalCampos,
							respuestas=(
								select
									idPregunta,
									idRespuesta,
									idRespuestaT = dbo.notEmpty(idRespuestaT),
									observacion = dbo.notEmpty(observacion),
									api,
									idRM = dbo.notEmpty(idRM),
									IDT = dbo.notEmpty(IDT),
									d1 = dbo.notEmpty(d1),
									g = g,
									p = p,
									lp = lp,
									gp = gp,
									[readOnly],
									incorrect
								from @rsp
								where idEncuestaR = e.idEncuestaR and idFormulario = f.idFormulario
							for json path)
						from @f f
						inner join @e e on e.idEncuestaR = f.idEncuestaR
						where e.idEncuestaR = @idEncuestaR
					for json path),'[]')
					declare @jsf table(# int,idFormulario int)
					delete from @jsf
					insert @jsf select #=row_number() over(order by (select 1))-1,*from openjson(@respuestas2)with(idFormulario int)

					declare @totaljSF int = (select count(1) from @jsf), @indexJSF int = 0

					while @indexJSF < @totaljSF begin
						declare @idFormularioTMP int = 0,@frTMP nvarchar(max)=null
						select @idFormularioTMP = idFormulario from @jsf where # = @indexJSF
						declare @sqlFR nvarchar(max) = concat('set @rw =(select *from openjson(@d,',@sp,'$[',@indexJSF,']',@sp,')with(idFormulario int,fechaCreacion datetime,totalCampos int,respuestas nvarchar(max) as json) for json path, without_array_wrapper)')
						exec sp_executesql @sqlFR,N'@rw nvarchar(max) out,@d nvarchar(max)',@frTMP out,@respuestas2
						if(coalesce(@frTMP,'' )!= '')exec dbo.agregarFormularioR @idFormularioTMP,@frTMP,@respuestas1 out
						set @idFormulario = @idFormularioTMP
						set @indexJSF +=1
					end

					update t
					set
						fecha = coalesce(fecha,current_timestamp),
						actualizado = 1,
						enProceso = iif(t.enProceso = 2, t.enProceso,1),
						puntosPrecalificacion = t.puntosPrecalificacion + @puntosP,
						d1 = @d1E,
						d2 = @d2E,
						d3 = @d3E,
						d4 = @d4E,
						eventos = @eventos,
						renovado = @tipoP,
						respuestas = json_query(@respuestas1),
						idEncuesta = @idEncuesta
					from prospectos t with(nolock)
					where idProspecto = @idProspecto

					--Actualizando etapas de prospectos
					set @etapa2 = iif(@rechazado is not null,6,iif(@etapa1 is not null and @etapa1 > 1,@etapa1,dbo.fEtapa(@idProspecto)))
					if(@etapaAnteriorProspecto = 1)begin
						if(select count(1) from openjson((select respuestas from prospectos where idProspecto = @idProspecto))with(observado int)where observado = 1) = 0
						begin
							select top 1 @etapa2 = etapa from etapasProspecto where idProspecto = @idProspecto and etapa != 1 order by fecha desc
						end
					end
					update prospectos set etapa =iif(etapa is not null and etapa > 2,etapa,@etapa2) where idProspecto = @idProspecto
					declare @totalEtapas int = iif(@etapa2< @etapa1,(select count(1) from etapasProspecto with(nolock) where idProspecto = @idProspecto),0)

					if(@codigoE != 'GRP' and (@etapa2 > @etapa1 or @totalEtapas = 0))begin
						if(@etapa2 != 1 and (select count(1) from etapasProspecto with(nolock) where idProspecto = @idProspecto) = 0)begin
							insert etapasProspecto
							(idProspecto,fecha,idFormulario,idGestor,totalCampos,etapa)
							select
								idProspecto = @idProspecto,
								fecha = @fechaE,
								idFormulario = @idFormulario,
								idGestor = @idGestor,
								totalCampos =(select count(1) from @rsp),
								etapa = 1
						end

						insert etapasProspecto
						(idProspecto,fecha,idFormulario,idGestor,totalCampos,etapa)
						select
							t.*
						from (select
							idProspecto = @idProspecto,
							fecha = @fechaE,
							idFormulario = @idFormulario,
							idGestor = @idGestor,
							totalCampos =(select count(1) from @rsp),
							etapa = @etapa2) as t
						left join etapasProspecto s with(nolock) on s.fecha = t.fecha and s.etapa = @etapa2
						where s.idEtapa is null
					end

					/*insert imagenesProspecto
					(idProspecto,idFormulario,idPregunta,fecha)
					select
						idProspecto = @idProspecto,
						r.idFormulario,
						s.idPregunta,
						s.fecha
					from imagenesProspecto t
					right join @img s on s.fecha =  t.fecha and t.idProspecto = @idProspecto
					inner join @rsp r on r.idPregunta = s.idPregunta
					where t.idImagen is null and s.idRegistroActividad = @idR and r.idEncuestaR = @idEncuestaR*/

					--Actualizando estado a créditos grupales renovables
					if(@idCreditoE is not null)begin
						select
							@idGrupoAdesco = idGrupo
						from creditos with(nolock)
						where idCredito = @idCreditoE

						update ga
						set
							idEstado = 1,--Siempre que haya una renovación se debe de cambiar el estado a "En proceso"
							actualizado = 1
						from gruposAdesco ga with(nolock)
						where idGrupoAdesco = @idGrupoAdesco

						--actualizar idGrupo a prospecto cuando son renovables
						if(@codigoE = 'PRV')update prospectos set idGrupoAdesco = @idGrupoAdesco where idProspecto = @idProspecto

					end

					update t
					set
						idProspectoS = @idProspecto
					from @img t
					where t.idRegistroActividad = @idR

					update t
					set
						idProspectoS = @idProspecto,
						idEncuestaRS = @idEncuestaR
					from @e t
					inner join #e s on s.idEncuestaR = t.idEncuestaR
					where s.px = @indexE

					update ra
					set
						idProspectoS = @idProspecto,
						idEncuestaRS = @idEncuestaR
					from @ra ra
					where ra.idRegistroActividad = @idRegistroActividad2

					update ra
					set
						idProspecto = @idProspecto,
						solicitudNueva = @solicitudNueva
					from registroActividades ra with(nolock)
					where idRegistroActividad = @idRegistroActividad2

					declare @warning varchar(max), @errorNumber varchar(max)
					exec actualizarEncabezados @idProspecto, @errorNumber out, @warning out

					if @sendMailDB = 1 and (@etapa1 = 1 or @etapa1 is null) and @etapa2 = 2 begin
						declare @mail varchar(max) = (select @idGestor as idGestor, @idProspecto as idProspecto, 1 as etapa for json path)
						exec sendMail @mail
					end

					set @indexE +=1
				end

			--Actualizando formularios completados a prospectos
                update p
                set
                    formularios = dbo.completedForms(p.idProspecto)
                from prospectos p
                inner join @e e on e.idProspectoS = p.idProspecto
                where e.codigo != 'GRP'

			--Actualizando encabezados de gruposAdesco
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Actualizando encabezados')

				if(object_id('tempdb..#ga') is not null)drop table #ga
				select
					e.idEncuestaRS,
					lag(s.idEncuestaR) over(order by s.idEncuestaR)as _prev,
					ee.idET,
					e.idGestor,
					s.observacion
				into #ga from @rsp s
				inner join @e e on e.idEncuestaR = s.idEncuestaR
				inner join encabezadoEncuesta ee with(nolock) on ee.idPregunta = s.idPregunta
				where e.codigo = 'GRP' --and ga.idGrupoAdesco is null


				declare @_ga table(nombre varchar(max),domicilio varchar(max),idEncuestaR int,estado int,idGestor int)

				insert @_ga
				select
					t1 as nombre,
					t2 as domicilio,
					idEncuestaRS,
					1 as estado,
					idGestor
				from(
					select
						idEncuestaRS,
						idGestor,
						concat('t',idEt)as codigo,
						descripcion = (select distinct ' ' + observacion from #ga b where b.idET = a.idET and b.idEncuestaRS = a.idEncuestaRS for xml path(''))
					from #ga a
					group by idEncuestaRS,idEt,idGestor
				)as dt
				pivot(max(descripcion) for codigo in(t1,t2))piv

				insert gruposAdesco
				(nombre,domicilioReunion,idProspecto,idEstado,idGestor,fecha,actualizado)
				select
					s.nombre,
					s.domicilio,
					e.idProspectoS,
					s.estado,
					s.idGestor,
					e.fecha,
					1
				from gruposAdesco t with(nolock)
				right join @e e on e.idProspectoS = t.idProspecto
				inner join @_ga s on s.idEncuestaR = e.idEncuestaR
				where t.idGrupoAdesco is null

				insert into gruposAsignados
				(idGestor,idGrupoAdesco,asignado)
				select
					c.idGestor,
					c.idGrupoAdesco,
					1
				from gruposAsignados t with(nolock)
				right join gruposAdesco c with(nolock) on c.idGrupoAdesco = t.idGrupoAdesco
				inner join @e e on e.idProspectoS = c.idProspecto
				inner join @_ga s on s.idEncuestaR = e.idEncuestaR
				where t.idGrupoAsignado is null

				update p
				set
					idGrupoAdesco = cr.idGrupo
				from prospectos p with(nolock)
				inner join @e e on e.idProspectoS = p.idProspecto
				inner join creditos cr with(nolock) on cr.idCredito =  e.idCredito
				where e.idCredito is not null
			end

		--Actualizando observaciones
			if(select count(1) from @obs) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Actualizando observaciones ')
				set @prospectos = 1

				if(object_id('tempdb..#ds') is not null)drop table #ds
				declare @_obs table(# int identity(1,1), idProspecto int, idRegistroActividad int)
				declare @_ds table(ID int,idProspecto int)
				insert @_obs select idProspecto, idRegistroActividad from @obs group by idProspecto,idRegistroActividad

				select
					*
				into #ds from(
					select
						row_number() over(partition by et.idProspecto order by et.fecha desc) AS ID,
						et.idProspecto,
						et.idEtapa,
						et.etapa,
						s.idRegistroActividad
					from etapasProspecto et with(nolock)
					inner join @_obs s on s.idProspecto = et.idProspecto
					where et.etapa != 1
				)as dt
				where id= 1

				insert etapasProspecto
				(idProspecto,fecha,idGestor,totalCampos,etapa)
				select
					t.idProspecto,
					ra.fechaGestion,
					ra.idGestor,
					totalCampos = (select count(1) from @obs where idProspecto = t.idProspecto),
					etapa = iif(@etapaAnteriorProspecto = 1,t.etapa,dbo.fEtapa(t.idProspecto))
				from #ds t
				inner join @ra ra on ra.idRegistroActividad = t.idRegistroActividad
				inner join prospectos p with(nolock) on p.idProspecto = ra.idProspecto
				where coalesce(p.etapa,0) < 2

				update t
				set
					d1 = coalesce(dbo.notEmpty(ra.d1),t.d1),
					d2 = coalesce(dbo.notEmpty(ra.d2),t.d2),
					d3 = coalesce(dbo.notEmpty(ra.d3),t.d3),
					d4 = coalesce(dbo.notEmpty(ra.d4),t.d4),
					actualizado = 1,
					etapa = iif(@etapaAnteriorProspecto = 1, ds.etapa,dbo.fEtapa(s.idProspecto))
				from prospectos t with(nolock)
				inner join @obs s on s.idProspecto = t.idProspecto
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad
				inner join #ds ds on ds.idRegistroActividad = ra.idRegistroActividad

				--Quitando observacion2 de preguntasRespondidas
				declare @dtOBS table(# int,idImagen int,idProspecto int,idFormulario int, idPregunta int,observacion varchar(max),idRespuesta int,idRespuestaT varchar(max),idRM varchar(max),fecha datetime)
				insert @dtOBS
				select
					# = row_number() over(order by (select 1)),
					i.idImagen,
					o.idProspecto,
					p.idFormulario,
					o.idPregunta,
					nombre = coalesce(i.nombre,o.observacion),
					o.idRespuesta,
					o.idRespuestaT,
					o.idRM,
					i.fecha
				from @obs o
				inner join preguntas p with(nolock) on p.idPregunta = o.idPregunta
				left join @img i on i.idPreguntaRS = o.idPreguntaRS
				declare @totalDTOBS int = (select count(1) from @dtOBS), @indexDTOBS int = 1

				while @indexDTOBS <= @totalDTOBS begin
					declare @idProspectoOB int = null,@idFormularioOB int=null,@idPreguntaOB int=null,@nombre varchar(max)=null,@idImgen int = null,@idRespuesta int = null,@idRespuestaT varchar(max) = null,@idRM int = null,@formatoP varchar(max) = null
					select
						@idProspectoOB = idProspecto,
						@idFormularioOB = idFormulario,
						@idPreguntaOB = idPregunta,
						@nombre = observacion,
						@idImgen = idImagen,
						@idRespuesta = idRespuesta,
						@idRespuestaT = idRespuestaT,
						@idRM = idRM
					from @dtOBS where # = @indexDTOBS

					if(dbo.notEmpty(@nombre) is not null)begin
						if(@idImgen is not null)set @nombre = concat('agencia',@idAgencia,'/gestor',@idGestor,'/prospecto',@idProspectoOB,'/img_',@idPreguntaOB,substring(@nombre,PatIndex('%.%',@nombre),len(@nombre)),'#prev')
						exec actualizarRespuesta @idProspectoOB,@idFormularioOB,@idPreguntaOB,'observacion',@nombre
					end
					else if(@idRespuesta is not null) exec actualizarRespuesta @idProspectoOB,@idFormularioOB,@idPreguntaOB,'idRespuesta',@idRespuesta

					if(@idRespuestaT is not null and @idRespuestaT != '') exec actualizarRespuesta @idProspectoOB,@idFormularioOB,@idPreguntaOB,'idRespuestaT',@idRespuestaT
					set @indexDTOBS +=1
				end

				--Quitando observacion a todas las preguntas de los formularios observados
				declare @dtfOBS table(# int, idProspecto int,idFormulario int)
				insert @dtfOBS
				select
					# = row_number() over(order by (select 1)),
					idProspecto,
					idFormulario
				from @dtOBS
				group by idProspecto,idFormulario

				declare @totalDTFOBS int = (select count(1) from @dtfOBS), @indexDTFOBS int = 1
				while @indexDTFOBS <= @totalDTFOBS begin
					select
						@idFormulario = s.idFormulario,
						@idProspecto = s.idProspecto
					from @dtfOBS s where # = @indexDTFOBS

					--select @idFormulario
					declare @respuestas varchar(max)
					exec quitarObservacionPreguntas @idProspecto, @idFormulario,@respuestas output

					update prospectos set respuestas = @respuestas where idProspecto = @idProspecto

					set @indexDTFOBS +=1
				end

				insert imagenesProspecto
				(idProspecto,idFormulario,idPregunta,fecha)
				select
					s.idProspecto,
					s.idFormulario,
					s.idPregunta,
					s.fecha
				from imagenesProspecto t with(nolock)
				right join @dtOBS s on s.idProspecto =  t.idProspecto and s.idFormulario = t.idFormulario and s.idPregunta = t.idPregunta
				where t.idImagen is null and s.observacion is not null

				update i
				set
					idImagenS = s.idImagen,
					idProspectoS = s.idProspecto
				from @img i
				inner join @dtOBS o on o.idImagen = i.idImagen
				inner join imagenesProspecto s with(nolock) on s.idProspecto = o.idProspecto and s.idFormulario = o.idFormulario and s.idPregunta = o.idPregunta

				--Actualizando encabezados relacionados con las observacionesn
				declare @totalOBS int = (select count(1) from @_obs), @indexOBS int = 1
				while @indexOBS <= @totalOBS begin
					declare @_idProspecto int = (select idProspecto from @_obs where # = @indexOBS)
					exec actualizarEncabezados @_idProspecto
					set @indexOBS += 1
				end
			end

		--Actualizando respuestasAPI
			if(select count(1) from @api) > 0 begin
				if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Actualizando respuestas API ')
				set @prospectos = 1

				declare @_api table(# int identity(1,1), idProspecto int, idRegistroActividad int)
				insert @_api select idProspecto, idRegistroActividad from @api group by idProspecto,idRegistroActividad

				update t
				set
					d1 = coalesce(dbo.notEmpty(ra.d1),t.d1),
					d2 = coalesce(dbo.notEmpty(ra.d2),t.d2),
					d3 = coalesce(dbo.notEmpty(ra.d3),t.d3),
					d4 = coalesce(dbo.notEmpty(ra.d4),t.d4),
					actualizado = 1
				from prospectos t with(nolock)
				inner join @api s on s.idProspecto = t.idProspecto
				inner join @ra ra on ra.idRegistroActividad = s.idRegistroActividad

				--Quitando observacion2 de preguntasRespondidas
					declare @dtApi table(# int,idImagen int,idProspecto int,idFormulario int, idPregunta int,observacion varchar(max),fecha datetime,api varchar(max))

					insert @dtApi
					select
						# = row_number() over(order by (select 1)),
						i.idImagen,
						o.idProspecto,
						p.idFormulario,
						o.idPregunta,
						nombre = coalesce(iif(i.nombre = '',null,i.nombre),o.observacion),
						i.fecha,
						o.api
					from @api o
					inner join preguntas p with(nolock) on p.idPregunta = o.idPregunta
					left join @img i on i.idPreguntaRS = o.idPreguntaRS

					declare @totalDTAPI int = (select count(1) from @dtApi), @indexDTAPI int = 1

					while @indexDTAPI <= @totalDTAPI begin
						declare @idProspectoApi int = null,@idFormularioApi int=null,@idPreguntaApi int=null,@apiNombre varchar(max)=null,@idImgenApi int = null,@apiResp VARCHAR(max) = null
						select
							@idProspectoApi = idProspecto,
							@idFormularioApi = idFormulario,
							@idPreguntaApi = idPregunta,
							@apiNombre = observacion,
							@idImgenApi = idImagen,
							@apiResp = api
						from @dtApi where # = @indexDTAPI

						if(dbo.notEmpty(@apiNombre) is not null)begin
							if(@idImgenApi is not null)set @apiNombre = concat('agencia',@idAgencia,'/gestor',@idGestor,'/prospecto',@idProspectoApi,'/img_',@idPreguntaApi,substring(@apiNombre,PatIndex('%.%',@apiNombre),len(@apiNombre)),'#prev')
							exec actualizarRespuesta @idProspectoApi,@idFormularioApi,@idPreguntaApi,'observacion',@apiNombre
						end
						else if(@idRespuesta is not null) exec actualizarRespuesta @idProspectoApi,@idFormularioApi,@idPreguntaApi,'idRespuesta',@idRespuesta

						if(@idRespuestaT is not null and @idRespuestaT != '') exec actualizarRespuesta @idProspectoApi,@idFormularioApi,@idPreguntaApi,'idRespuestaT',@idRespuestaT

						if(@apiResp is null or @apiResp = '')exec actualizarRespuesta @idProspectoApi,@idFormularioApi,@idPreguntaApi,'api',null
						set @indexDTAPI +=1
					end

				insert imagenesProspecto
				(idProspecto,idFormulario,idPregunta,fecha)
				select
					s.idProspecto,
					s.idFormulario,
					s.idPregunta,
					s.fecha
				from imagenesProspecto t with(nolock)
				right join @dtApi s on s.idProspecto =  t.idProspecto and s.idFormulario = t.idFormulario and s.idPregunta = t.idPregunta
				where t.idImagen is null and s.observacion is not null

				update i
				set
					idImagenS = s.idImagen,
					idProspectoS = s.idProspecto
				from @img i
				inner join @dtApi o on o.idImagen = i.idImagen
				inner join imagenesProspecto s with(nolock) on s.idProspecto = o.idProspecto and s.idFormulario = o.idFormulario and s.idPregunta = o.idPregunta
			end

		--Insertando acuerdosParticipante
			if(select count(1) from @acp) > 1 begin
				if(@debug = 1)print concat(format(current_timestamp,'yyyy-MM-dd HH:mm:ss'),' Acuerdos participante ')

				insert acuerdosParticipante
				(idRegistroActividad,idCredito,asistencia,renovacion,idCF,cuota,ahorro)
				select
					ra.ID,
					s.idCredito,
					s.asistencia,
					s.renovacion,
					s.idCF,
					s.cuota,
					s.ahorro
				from acuerdosParticipante t with(nolock)
				right outer join @ra ra on ra.ID = t.idRegistroActividad
				inner join @acp s on s.idRegistroActividad = ra.idRegistroActividad
				where t.idAcuerdo is null and ra.ID is not null
			end

		--Construyendo respuesta satisfactoria
			if(@debug = 1)print concat(format(getdate(),'yyyy-MM-dd HH:mm:ss'),' Respuesta ')

			if(@parcial=1 and ((select count(1) from @e) >0 or (select count(1) from @ra where d4 is not null)>0))begin
				set @action = concat('',
					iif(@prospectos = 1 and @grupos=0,'-1',''),
					iif(@prospectos = 0 and @grupos=1,'-2',''),
					iif(@prospectos = 1 and @grupos=1,'-3',''),
					iif(@prospectos = 0 and @grupos=0,'-4','')
				)
				declare @dtParcial table(data nvarchar(max))
				declare @idUsuario int = (select idUsuario from usuarios with(nolock) where idGestor = @idGestor)
				begin try insert @dtParcial exec inicioSesion @idUsuario,@action end try
				begin catch select @errorNumber= ERROR_NUMBER(), @warning = ERROR_MESSAGE()	end catch
				select @strParcial = data from @dtParcial
				insert logs(message, idGestor, fecha, data)
				select 'inicioSesion parcial',@idGestor,getdate(), @strParcial
			end

			declare @js varchar(max) = (select idGestor,sessionid from @us for json path, without_array_wrapper)
			begin try exec envioGestiones @js end try
			begin catch select @errorNumber= ERROR_NUMBER(), @warning = ERROR_MESSAGE()	end catch

			select (select
				error = 0,
				wError = @errorNumber,
				wMessage = @warning,
				idAgencia = @idAgencia,
				sessionid = (select top 1 sessionid from @us),
				registros = (select idRegistroActividad as idRegistro,ID as idRegistroS, idProspectoS, idEncuestaRS from @ra for json path),
				message = 'Información recibida correctamente.',
				rsp = json_query(iif(@strParcial != '' and @strParcial is not null,@strParcial,'{}')),
				images = (select idImagen,idImagenS,idProspectoS,GPS from @img for json path)
			for json path, without_array_wrapper)as data

	set nocount off
end
