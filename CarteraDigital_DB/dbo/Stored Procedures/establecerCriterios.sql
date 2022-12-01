CREATE procedure [dbo].[establecerCriterios] as
begin
	declare @seg int = (select idActividad from actividades where codigo = 'SEG')
	declare @cob int = (select idActividad from actividades where codigo = 'COB')
	declare @llm int = (select idActividad from actividades where codigo = 'LLM')
	declare @pdd int = (select idActividad from actividades where codigo = 'PDD')
	declare @slc int = (select idActividad from actividades where codigo = 'SLC')
	declare @fpa int = (select idActividad from actividades where codigo = 'FPA')
	declare @prv int = (select idActividad from actividades where codigo = 'PRV')
	declare @CPN int = (select idActividad from actividades where codigo = 'CPN')
	declare @vig int = (select dbo.fEstadoCredito('VIG'))
	declare @can int = (select dbo.fEstadoCredito('CAN'))
	declare @segUp int = (select dbo.fDetalleAC('SEG','CCD'))
	declare @fpaUp int = (select dbo.fDetalleAC('FPA','CCD'))
	declare @llmUp int = (select dbo.fDetalleAC('LLM','CCD'))
	declare @pddUp int = (select dbo.fDetalleAC('PDD','CCD'))
	declare @cobUp int = (select dbo.fDetalleAC('COB','CCD'))
	declare @slcUp int = (select dbo.fDetalleAC('SLC','CCD'))
	declare @prvUp int = (select dbo.fDetalleAC('PRV','CCD'))
	declare @hour int = (SELECT DATEPART(HOUR, GETDATE()))
	declare @dd int = (select dbo.fParameters('visRepVen'))
	declare @dRechazoAuto int = (select dbo.fParameters('diasRechazoAuto'))

	--Buscando actividades de prospección de desertados
	update t
	set 
		t.totalGestionesDesertado = (select count(1) from registroActividades ra 
										inner join detalleActividades dt on dt.idDetalle = ra.idDetalle 
										inner join reacciones rc on rc.idReaccion = ra.idReaccion 
										where ra.idCredito = t.idCredito and (dt.idDetalle = @pddUp or (rc.idActividad=@pdd and rc.idDetalle = @llmUp)))
	from creditos t 
	inner join clientes c on c.idCLiente = t.idCliente
	where t.inactivo = 1

	--Regresando créditos con clientes desertados sin gestión
	update ca
	set
		asignado = 1
	from creditosAsignados ca
	inner join creditos cr on cr.idCredito = ca.idCredito
	where cr.inactivo = 1 and cr.totalGestionesDesertado = 0

	update cr
	set
		cr.idEstado = @vig
	from creditosAsignados ca
	inner join creditos cr on cr.idCredito = ca.idCredito
	where cr.inactivo = 1 and cr.totalGestionesDesertado = 0

	update cr
	set
		cr.idEstado = @can,
		cr.porDesertar = 0,
		cr.fechaPorDesertar = null,
		cr.diasPorDesertar = 0
	from creditos cr
	where cr.inactivo = 1 and cr.totalGestionesDesertado > 0 and cr.idEstado = @vig

	--Quitando creditos desertados con gestiones válidas
	update cr
	set
		desertado = 0
	from creditos cr
	where cr.totalGestionesDesertado > 0 and cr.inactivo = 1

	--Actualizando información de créditos vigentes
	update cr
	set 
		--cr.idCreditoT = cr.referencia,
		cr.promesas = (select iif(count(1)>0,1,0)from promesasPago_v where diasPromesa between -15 and 3 and montoReal < montoPrometido and idCredito = cr.idCredito and cr.diasCapitalMora>0),
		cr.diasPromesa = (select top 1  diasPromesa from promesasPago_v where diasPromesa between -15 and 3 and montoReal < montoPrometido and idCredito = cr.idCredito and cr.diasCapitalMora>0 order by fechaPromesa desc),
		cr.diasDesertado = iif(cr.desertado=1,DATEDIFF(day,cr.fechaCancelacion,GETDATE()),0),--Desertado
		--cr.desertado = iif(cl.idTipificacion = 1 and cr.totalGestionesDesertado = 0,1,0),--Desertado
		cr.diasPrioridadAgencia = 0,
		cr.diasRestantesPlazo = DATEDIFF(day,GETDATE(),cr.fechaVencimiento),
		cr.plazoTranscurridoPorcentual = iif(cr.cantidadCuotas is null or cr.cantidadCuotas=0,0,(cr.cuotasPagadas*100/cr.cantidadCuotas)),
		cr.montoCanceladoPorcentual = iif(cr.montoOtorgado is null or cr.montoOtorgado=0,0,(100-(cr.capitalTotalAdeudado * 100)/cr.montoOtorgado)),
		cr.diasDesembolso = DATEDIFF(day,cr.fechaDesembolso,GETDATE()),
		cr.diasTranscurridos = DATEDIFF(day,cr.fechaOtorgamiento,GETDATE()),
		cr.cuotaVenceHoy = iif(DATEDIFF(DAY,cr.fechaProximaCuota,cast(GETDATE() as date))=0,1,0),
		cr.diasProximaCuota = DATEDIFF(DAY,cast(GETDATE() as date),cr.fechaProximaCuota),
		cr.seguimiento = 0,
		cr.idCriterioSeguimiento = null,
		cr.etapaSeguimiento = iif(cr.rangoEtapaSeguimiento > 0,((cr.diasTranscurridos/cr.rangoEtapaSeguimiento)+1),0),
		cr.totalGestionesSeguimiento = (select count(1) from registroActividades where idDetalle = @segUp and idCredito = cr.idCredito and etapaSeguimiento = iif(cr.rangoEtapaSeguimiento>1,((cr.diasTranscurridos/cr.rangoEtapaSeguimiento)+1),0)),
		cr.totalGestionesDesertado = (select count(1) from registroActividades where idDetalle = @pddUp and idCredito = cr.idCredito),
		cr.diasUltimoSeguimiento = iif(cr.rangoEtapaSeguimiento is not null and cr.rangoEtapaSeguimiento != 0,(DATEDIFF(day,cr.fechaOtorgamiento,GETDATE()) - (cr.rangoEtapaSeguimiento * ((cr.diasTranscurridos/cr.rangoEtapaSeguimiento)))),(DATEDIFF(day,cr.fechaOtorgamiento,GETDATE()))),
		cr.gestionesRealizadas = (select count(1) from registroActividades where idCredito = cr.idCredito),
		cr.totalGestionesCobro = (select count(1) from registroActividades ra inner join detalleActividades dt on dt.idDetalle = ra.idDetalle inner join reacciones rc on rc.idReaccion = ra.idReaccion where DATEDIFF(MONTH,ra.fecha,GETDATE())= 0 and ra.idCredito = cr.idCredito and (dt.idDetalle = @cobUp or (rc.idActividad=@cob and rc.idDetalle = @llmUp))),
		cr.totalGestionesPorDesertar = (select count(1) from registroActividades ra inner join detalleActividades dt on dt.idDetalle = ra.idDetalle inner join reacciones rc on rc.idReaccion = ra.idReaccion where ra.idCredito = cr.idCredito and(dt.idDetalle = @fpa or (rc.idActividad=@fpa and rc.idDetalle = @llmUp))),
		cr.diasPorDesertar = iif(cr.fechaPorDesertar is null and cr.porDesertar = 1,0,DATEDIFF(day,cr.fechaPorDesertar,GETDATE())),
		cr.fechaPorDesertar = iif(cr.fechaPorDesertar is null,GETDATE(),cr.fechaPorDesertar),
		cr.gestionado = 0,
		cr.renovacion = 0,
		cr.enMora = iif(cr.diasCapitalMora > 0,1,0),
		cr.cobroPreventivo = 0,
		cr.totalGestionesRenovacion = (select count(1) from prospectos p where p.idCredito = cr.idCredito),
		cr.cierre = iif(DAY(GETDATE())=1,1,0),
		cr.fechaPrioridad = iif(cr.idPrioridad is not null,cr.fechaPrioridad,null),
		cr.idPrioridad = null,
		cr.prioridad = null,
		cr.diasUltimaGMora = (select top 1 DATEDIFF(day,ra.fecha,iif(@hour<16,GETDATE(),DATEADD(day,1,GETDATE()))) from registroActividades ra inner join reacciones r on r.idReaccion = ra.idReaccion where (ra.idActividad = @cob or r.idActividad = @cob) and ra.idCredito = cr.idCredito order by fecha desc) ,
		cr.diasUltimaGSeguimiento = (select top 1 DATEDIFF(day,ra.fecha,iif(@hour<16,GETDATE(),DATEADD(day,1,GETDATE()))) from registroActividades ra inner join reacciones r on r.idReaccion = ra.idReaccion where (ra.idActividad = @seg or r.idActividad = @seg) and ra.idCredito = cr.idCredito order by fecha desc),
		cr.diasUltimaGDesertado = (select top 1 DATEDIFF(day,ra.fecha,iif(@hour<16,GETDATE(),DATEADD(day,1,GETDATE()))) from registroActividades ra inner join reacciones r on r.idReaccion = ra.idReaccion where (ra.idActividad = @pdd or r.idActividad = @pdd) and ra.idCredito = cr.idCredito order by fecha desc),
		cr.diasUltimaGRenovacion = (select top 1 DATEDIFF(day,ra.fecha,iif(@hour<16,GETDATE(),DATEADD(day,1,GETDATE()))) from registroActividades ra inner join reacciones r on r.idReaccion = ra.idReaccion where (ra.idActividad = @prv or r.idActividad = @prv) and ra.idCredito = cr.idCredito order by fecha desc),
		cr.DUG = (select top 1 DATEDIFF(day,ra.fecha,iif(@hour<16,GETDATE(),DATEADD(day,1,GETDATE()))) from registroActividades ra inner join reacciones r on r.idReaccion = ra.idReaccion 
					where ra.idCredito = cr.idCredito and ((ra.idActividad = @prv or r.idActividad = @prv) or (ra.idActividad = @pdd or r.idActividad = @pdd) or (ra.idActividad = @seg or r.idActividad = @seg) or (ra.idActividad = @cob or r.idActividad = @cob)) order by fecha desc),
		cr.UG = (select top 1 a.actividad from registroActividades ra inner join reacciones r on r.idReaccion = ra.idReaccion inner join actividades a on a.idActividad = coalesce(r.idActividad,ra.idActividad)
					where ra.idCredito = cr.idCredito and ((ra.idActividad = @prv or r.idActividad = @prv) or (ra.idActividad = @pdd or r.idActividad = @pdd) or (ra.idActividad = @seg or r.idActividad = @seg) or (ra.idActividad = @cob or r.idActividad = @cob)) order by fecha desc)
	from creditos cr
	inner join clientes cl on cl.idCliente = cr.idCliente
	where cr.idEstado != @can

	update creditos set DUG = null,UG = null where DUG > (select [value] as CI from openjson((select conf from parametros)) where [key] = 'limiteDiaGestion')

	--quitar gestionados grupo
		update gruposadesco set gestionado = 0 where gestionado = 1

	--Actualizando DUG y UG de clientesCampania
	update cc
	set
		cc.DUG = (select top 1 DATEDIFF(day,ra.fecha,iif(@hour<16,GETDATE(),DATEADD(day,1,GETDATE()))) from registroActividades ra where (ra.idClienteP = cc.idClienteP or ra.idCredito = cc.idCredito) and ra.idCampania = cc.idCampania and (ra.idActividad = @CPN) order by fecha desc),
		cc.UG = (select top 1 a.actividad from registroActividades ra inner join actividades a on a.idActividad = ra.idActividad where (ra.idClienteP = cc.idClienteP or ra.idCredito = cc.idCredito) and ra.idCampania = cc.idCampania and (ra.idActividad = @CPN) order by fecha desc)
	from clientesCampania cc
	where cc.estado = 1

	update clientesCampania set DUG = null,UG = null,gestionado = 0 where DUG > (select [value] as CI from openjson((select conf from parametros)) where [key] = 'limiteDiaGestion')

	--relacionar cliente prospecto
	update p set 
		p.idCliente = cr.idCliente 
	from prospectos p
	inner join creditos cr on cr.idCredito = p.idCredito
	where p.idCliente is null

	update p set 
		idCliente = cl.idCliente 
	from prospectos p
	inner join clientes cl on cl.nDoc = p.nDoc
	where p.idCliente is null
	--END--relacionar cliente prospecto

	--update GPS cliente y prospecto
	update cl set
		cl.latitud = p.latitud,
		cl.longitud = p.longitud,
		cl.fechaGPSCasa = p.fechaGPSCasa
	from clientes cl inner join prospectos p on p.idCliente = cl.idCliente
	where (p.fechaGPSCasa > cl.fechaGPSCasa) or (p.fechaGPSCasa is not null and cl.fechaGPSCasa is null)

	update cl set
		cl.latitudNegocio = p.latitudNegocio, 
		cl.longitudNegocio = p.longitudNegocio,
		cl.fechaGPSNegocio = p.fechaGPSNegocio
	from clientes cl inner join prospectos p on p.idCliente = cl.idCliente
	where (p.fechaGPSNegocio > cl.fechaGPSNegocio) or (p.fechaGPSNegocio is not null and cl.fechaGPSNegocio is null)

	update p set
		p.latitud = cl.latitud,
		p.longitud = cl.longitud,
		p.fechaGPSCasa = cl.fechaGPSCasa
	from prospectos p inner join clientes cl on cl.idCliente = p.idCliente
	where (cl.fechaGPSCasa > p.fechaGPSCasa) or (cl.fechaGPSCasa is not null and p.fechaGPSCasa is null)

	update p set
		p.latitudNegocio = cl.latitudNegocio,
		p.longitudNegocio = cl.longitudNegocio,
		p.fechaGPSNegocio = cl.fechaGPSNegocio
	from prospectos p inner join clientes cl on cl.idCliente = p.idCliente
	where (cl.fechaGPSNegocio > p.fechaGPSNegocio) or (cl.fechaGPSNegocio is not null and p.fechaGPSNegocio is null)
	--END--update GPS cliente y prospecto

	declare @idCriterio int = (select top 1 idCriterio from criteriosRenovacion where idCriterio > 0 and estado = 1)
	declare @count int = 100
	while(@idCriterio is not null and @count > 0)begin
		declare @query varchar(max) = CONCAT('update creditos set creditos.renovacion=1 from creditos creditos inner join clientes clientes on clientes.idCliente = creditos.idCliente where totalGestionesRenovacion = 0 and ',(select condicion from criteriosRenovacion where idCriterio = @idCriterio))
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosRenovacion where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	set @idCriterio = (select top 1 idCriterio from criteriosSeguimiento where idCriterio > 0 and estado = 1)
	set @count = 100
	while(@idCriterio is not null and @count > 0)begin
		declare @rango int = coalesce((select rango from criteriosSeguimiento where idCriterio = @idCriterio),0)
		set @query = CONCAT('update creditos set creditos.seguimiento=1,idCriterioSeguimiento=',@idCriterio,', creditos.rangoEtapaSeguimiento = ',@rango,' from creditos inner join clientes on clientes.idCliente = creditos.idCliente inner join creditosAsignados ca on ca.idCredito=creditos.idCredito inner join gestores on gestores.idGestor = ca.idGestor where ',(select condicion from criteriosSeguimiento where idCriterio = @idCriterio))
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosSeguimiento where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	set @idCriterio = (select top 1 idCriterio from criteriosCobroPreventivo where idCriterio > 0 and estado = 1)
	set @count = 100
	while(@idCriterio is not null and @count > 0)begin
		set @query = CONCAT('update creditos set creditos.cobroPreventivo=1 from creditos inner join clientes on clientes.idCliente = creditos.idCliente inner join creditosAsignados ca on ca.idCredito=creditos.idCredito inner join gestores on gestores.idGestor = ca.idGestor where ',(select condicion from criteriosCobroPreventivo where idCriterio = @idCriterio))
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosCobroPreventivo where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	set @idCriterio = (select top 1 idCriterio from criteriosVencimiento where idCriterio > 0 and estado = 1)
	set @count = 100
	while(@idCriterio is not null and @count > 0)begin
		set @query = CONCAT('update creditos set creditos.vencimiento=1 from creditos inner join clientes on clientes.idCliente = creditos.idCliente inner join creditosAsignados ca on ca.idCredito=creditos.idCredito inner join gestores on gestores.idGestor = ca.idGestor where ',(select condicion from criteriosVencimiento where idCriterio = @idCriterio))
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosVencimiento where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	set @idCriterio = (select top 1 idCriterio from criteriosDesertado where idCriterio > 0 and estado = 1)
	set @count = 100
	while(@idCriterio is not null and @count > 0)begin
		set @query = CONCAT('update creditos set creditos.desertado=1 from creditos inner join clientes on clientes.idCliente = creditos.idCliente inner join creditosAsignados ca on ca.idCredito=creditos.idCredito inner join gestores on gestores.idGestor = ca.idGestor where ',(select condicion from criteriosDesertado where idCriterio = @idCriterio))
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosDesertado where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	update t
	set
		totalGestiones = (select count(1) from registroActividades ra inner join detalleActividades dt on dt.idDetalle = ra.idDetalle inner join reacciones rc on rc.idReaccion = ra.idReaccion where ra.idCliente = t.idCliente and (dt.idDetalle = @slcUp or (rc.idActividad=@slc and rc.idDetalle = @llmUp))),
		fechaPrioridad = iif(t.idPrioridad is not null,t.fechaPrioridad,null),
		prioridad = null,
		idPrioridad = null,
		diasSolicitud=DATEDIFF(day,fecha,GETDATE())
	from solicitudes t
	where t.estado = 1

	set @idCriterio = (select top 1 idCriterio from criteriosSolicitud where idCriterio > 0)
	set @count = 100
	while(@idCriterio is not null and @count > 0)begin
		set @query = CONCAT('update solicitudes set solicitudes.estado = 0 from solicitudes solicitudes inner join clientes clientes on clientes.idCliente=solicitudes.idSolicitud where ',(select condicion from criteriosSolicitud where idCriterio = @idCriterio))
		execute(@query)
		set @idCriterio = (select top 1 idCriterio from criteriosSolicitud where idCriterio > @idCriterio)
		set @count = @count -1
	end

	update creditos set prioridad = 0 where idEstado != dbo.fEstadoCredito('CAN')
	set @idCriterio = (select top 1 idCriterio from criteriosPrioridad where idCriterio > 0 and estado = 1)
	set @count = 100
	while(@idCriterio is not null and @count > 0)begin
		set @query = 'update creditos set creditos.idPrioridad='
		set @query = CONCAT(@query,'(select p.idPrioridad from criteriosPrioridad c inner join prioridades p on p.idPrioridad=c.idPrioridad ')
		set @query = CONCAT(@query,'where c.idCriterio=',@idCriterio,' and p.idPrioridad !=2)')
		set @query = CONCAT(@query,'from creditos creditos inner join clientes clientes on clientes.idCliente=creditos.idCliente ')
		set @query = CONCAT(@query,'left join solicitudes solicitudes on solicitudes.idCliente=clientes.idCliente and solicitudes.estado=1 ')
		set @query = CONCAT(@query,'left join campanias_v campanias on campanias.idCredito=creditos.idCredito ')
		set @query = CONCAT(@query,'where ',(select condicion from criteriosPrioridad where idCriterio = @idCriterio),' and creditos.idCredito is not null');
		execute(@query)
		set @query = 'update solicitudes set solicitudes.idPrioridad='
		set @query = CONCAT(@query,'(select p.idPrioridad from criteriosPrioridad c inner join prioridades p on p.idPrioridad=c.idPrioridad ')
		set @query = CONCAT(@query,'where c.idCriterio=',@idCriterio,' and p.idPrioridad=2)')
		set @query = CONCAT(@query,'from creditos creditos inner join clientes clientes on clientes.idCliente=creditos.idCliente ')
		set @query = CONCAT(@query,'left join solicitudes solicitudes on solicitudes.idCliente=clientes.idCliente and solicitudes.estado=1 ')
		set @query = CONCAT(@query,'left join campanias_v campanias on campanias.idCredito=creditos.idCredito ')
		set @query = CONCAT(@query,'where ',(select condicion from criteriosPrioridad where idCriterio = @idCriterio));
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosPrioridad where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	update cr
	set
		cr.fechaPrioridad = iif(cr.fechaPrioridad is null,GETDATE(),cr.fechaPrioridad),
		cr.diasPrioridad = iif(cr.fechaPrioridad is null,0,DATEDIFF(day,cr.fechaPrioridad,GETDATE())),
		prioridad = 1
	from creditos cr
	where cr.idPrioridad is not null

	update t
	set
		t.fechaPrioridad = iif(t.fechaPrioridad is null,GETDATE(),t.fechaPrioridad),
		t.diasPrioridad = iif(t.fechaPrioridad is null,0,DATEDIFF(day,t.fechaPrioridad,GETDATE())),
		prioridad = 1
	from solicitudes t
	where t.idPrioridad is not null

	--Reasignando cartera compartida
	set @idCriterio = (select top 1 idCriterio from criteriosAsignacion where idCriterio > 0 and estado = 1)
	set @count = 100

	--Reestableciendo criterios para asignación
	while(@idCriterio is not null and @count > 0)begin
	declare @estado int = (select iif(inverso=1,0,1) from criteriosAsignacion where idCriterio = @idCriterio and estado = 1)
		set @query = CONCAT('update gruposGestorCredito set gruposGestorCredito.asignado = ',@estado,' from creditosAsignados_v gruposGestorCredito where ',(select condicion from criteriosAsignacion where idCriterio = @idCriterio))
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosAsignacion where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	--Criterios seguridad
	set @idCriterio = (select top 1 idCriterio from criteriosSeguridad where idCriterio > 0 and estado = 1)
	set @count = 100
	--Reestableciendo criterios para asignación
	while(@idCriterio is not null and @count > 0)begin
		declare @seguridad_inv int = (select iif(inverso=1,0,1) from criteriosSeguridad where idCriterio = @idCriterio)
		set @query = CONCAT('update usuarios set verificador = ',@seguridad_inv,' from usuarios where ',(select condicion from criteriosSeguridad where idCriterio = @idCriterio))
		execute(@query)
	set @idCriterio = (select top 1 idCriterio from criteriosSeguridad where idCriterio > @idCriterio and estado = 1)
		set @count = @count -1
	end

	--Desabilitando clientes de campañas gestionados
	update cc
	set
		cc.estado = 0
	from registroActividades ra
	inner join campanias cp on cp.idCampania = ra.idCampania
	inner join clientesCampania cc on cc.idCampania = cp.idCampania and (cc.idCliente = ra.idCliente or cc.idCredito = ra.idCredito)
	where cc.estado = 1 and cp.fechaFin < GETDATE()

	--Dehabilitando clientesCampaña de campañas vencidas
	update t
	set
		estado = 0
	from campanias t
	where cast(current_timestamp as date) > fechaFin

	update t
	set
		estado = 0
	from clientesCampania t
	inner join campanias c on c.idCampania = t.idCampania
	where t.estado =1 and c.estado = 0

	update pp
	set
		pp.montoPagado = (coalesce((select sum(monto)from historialUltimosPagos where fechaPago between pp.fechaGestion and pp.fechaPromesa	and idCredito = pp.idCredito),0)),
		pp.diasPromesa = (select DATEDIFF(day,GETDATE(),pp.fechaPromesa))
	from promesasPago pp
	where pp.diasPromesa >=-30 or pp.diasPromesa is null

	---VisitasReprogramada
	update VisitasReprogramadas set realizada = 0 where realizada is null

	update vr set 
		vr.idActividad = re.idActividad 
	from VisitasReprogramadas vr
	inner join registroActividades ra on ra.idRegistroActividad = vr.idRegistroActividad
	inner join reacciones re on re.idReaccion = ra.idReaccion
	where vr.idActividad = @llm

	update t set t.diasVisita = DATEDIFF(day,GETDATE(),fechaVisita)
	from VisitasReprogramadas t
	where t.fechaVisita >=  DATEADD(day,-@dd,cast(GETDATE() as date)) and t.realizada = 0

	update t set t.realizada =(select count(1) from registroActividades ra 
			inner join detalleActividades dt on dt.idDetalle = ra.idDetalle and dt.contactado = 1
			inner join reacciones rc on rc.idReaccion = ra.idReaccion 
			where ra.idCredito = t.idCredito and ra.idActividad=t.idActividad
			and fechaVisitaReprogramada is null and ra.fecha between t.fechaGestion and cast(GETDATE() as date))
	from VisitasReprogramadas t
	where t.fechaVisita >=  DATEADD(day,-@dd,cast(GETDATE() as date)) and t.realizada = 0

	update VisitasReprogramadas set realizada = 1 where realizada>1
	--end VisitasReprogramadas
                
	--Dehabilitando anuncios vencidos
		update t
		set
			estado = 0
		from anuncios t
		where cast(current_timestamp as date) > fechaOut
        
	--Rechazar a aquellos porspectos con 30 dias sin gestion
		if(OBJECT_ID('tempdb..#prospect') is not null) drop table #prospect
		select 
		    p.idProspecto
		into #prospect from prospectos p
		left join (
		    select 
		        idProspecto
		    from etapasProspecto where cast(fecha as date) between dateadd(day,-coalesce(@dRechazoAuto,30),cast(getdate() as date)) and cast(getdate() as date)
		    group by idProspecto
		) as g on g.idProspecto = p.idProspecto
		where p.etapa not in (4,5,6) and g.idProspecto is null
            
		update pr
		set 
			etapa = 6 
		from prospectos pr 
		inner join #prospect dq on dq.idProspecto = pr.idProspecto

		insert into etapasProspecto (etapa,idProspecto,fecha,idGestor,sistema)
		select 6,idProspecto,getdate(),null,1 from #prospect

	--procesar campnias al dia
		declare @cultureInfo varchar(max) = (select [value] as CI from openjson((select conf from parametros)) where [key] = 'cultureInfo')
		declare @ddVig int = (select dbo.fParameters('visRepVig'))
		declare @ddVen int = (select dbo.fParameters('visRepVen'))

		update cc set
			cc.idCliente = (select top 1 idCliente from creditos where idCredito = cc.idCredito order by idCredito desc)
		from clientesCampania cc
		where cc.idCredito is not null and cc.idCliente is null

		update c set
			estado = 0
		from campanias c
		where CAST(GETDATE() as date) not between fechaInicio and fechaFin and estado = 1

		update cc
		set
			estado = 1
		from clientesCampania cc
		inner join campanias c on c.idCampania = cc.idCampania
		where c.estado = 1

		print concat('Deshabilitando clientes de campaña no interezados: ',format(current_timestamp,'HH:mm:ss'))
		update cc
		set
			estado = 0
		from clientesCampania cc
		inner join registroActividades ra on ra.idCredito = cc.idCredito and ra.idCampania = cc.idCampania
		inner join reacciones r on r.idReaccion = ra.idReaccion
		inner join detalleActividades d on d.idDetalle = ra.idDetalle
		where cc.idCampania is not null and cc.estado = 1 and d.codigo = 'CCD' and r.idRT = 10

		print concat('Procesando campañas al día: ',format(current_timestamp,'HH:mm:ss'))
		delete campaniaAlDia
		insert campaniaAlDia(idClienteCampania,idCampania ,idCredito ,idCliente ,idClienteP ,referencia,codigoCliente ,cliente ,direccion ,telefono ,fechaInicio ,fechaFin ,diasCampania ,latitud ,longitud,latitudNegocio ,longitudNegocio ,visita ,actividadVisita ,fechaVisita ,diasVisita ,visitaPopup ,DUG ,UD ,result,popup,indexP ,idGestor)
		select
			cc.idClienteCampania,
			cp.idCampania,
			cr.idCredito,
			idCliente = coalesce(cl.idCliente,cl2.idCliente),
			clp.idClienteP,
			cr.referencia,
			codigoCliente = coalesce(cl.codigo, cast(cl.idCliente as varchar(25)), cl2.codigo,cast(cl2.idCliente as varchar(25))),
			cliente = coalesce(clp.nombre,cl.nombre,cl2.nombre),
			direccion = coalesce(clp.direccion,cl.direccion,cl2.direccion),
			telefono = coalesce(clp.telefono,cl.telefono,cl2.telefono),
			fechaInicio = FORMAT(cp.fechaInicio,'dd-MM-yyyy',@cultureInfo),
			fechaFin = FORMAT(cp.fechaFin,'dd-MM-yyyy',@cultureInfo),
			diasCampania = datediff(day,cp.fechaInicio,GETDATE()),
			latitud = coalesce(cl.latitud,cl2.latitud),
			longitud = coalesce(cl.longitud,cl2.longitud),
			latitudNegocio = coalesce(cl.latitudNegocio,cl2.latitudNegocio),
			longitudNegocio = coalesce(cl.longitudNegocio,cl2.longitudNegocio),
			iif(vr.idVisita is not null,1,0) as visita,
			a.actividad as actividadVisita,
			format(vr.fechaVisita,'dd MMM yyyy',@cultureInfo) as fechaVisita,
			vr.diasVisita,
			iif(vr.diasVisita between -@ddVen and @ddVig,1,0) as visitaPopup,
			cc.DUG,
			cc.UG,
			concat('alias!valor;','Título!',
				titulo,';Propósito!',
				proposito,';Días campaña!',
				diasCampania,';Dias finalización!',
				datediff(day,GETDATE(),cp.fechaFin),';Fecha inicio!',
				fechaInicio,';Fecha finalización!',
				fechaFin,';',
				data
			)as result,
			(select *from(
				select 'Campaña' as Actividad,
				(select * from(
					select 'Proposito' as 'name',cast(cp.proposito as varchar(max)) as 'value'
					union select 'Fecha Inicio' as 'name',format(cp.fechaInicio,'dd-MMM-yyyy',@cultureInfo) as 'value'
					union select 'Fecha Fin' as 'name',format(cp.fechaFin,'dd-MMM-yyyy',@cultureInfo) as 'value'
				) as dt for json path) as params
			)as ds for json path, WITHOUT_ARRAY_WRAPPER) as popup,
			0 as indexP,
			cc.idGestor
		from clientesCampania cc
		inner join campanias cp on cp.idCampania = cc.idCampania
		left join creditos cr on cr.idCredito = cc.idCredito
		left join clientes cl on cl.idCliente = cc.idCliente
		left join clientes cl2 on cl2.idCliente = cr.idCliente
		left join clientesPotenciales clp on clp.idClienteP = cc.idClienteP
		left join VisitasReprogramadas vr on (vr.idCredito = cr.idCredito or vr.idClienteP = clp.idClienteP) and vr.idCampania = cp.idCampania and vr.fechaVisita >=  DATEADD(day,-@ddVen,cast(GETDATE() as date)) and realizada = 0
		left join actividades a on a.idActividad = vr.idActividad
		where cc.estado = 1 and cp.estado = 1 --and cc.idGestor = 893

	--agregar
		update t
		set
			t.clientesPrioridad = s.clientesPrioridad
		from gestores t
		inner join(
			select
				idGestor,
				sum(clientesPrioridad) clientesPrioridad
			from(
				select
					idGestor,
					iif(prioridad = 1,1,0) clientesPrioridad
				from cartera_v
				where desertado = 0 and saneado = 0
			)as dt
			group by idGestor
		)as s on s.idGestor = t.idGestor
		where t.estado = 1
	--agregar
		update ag
		set
			ag.saldoCartera = dt.saldo
		from agencias ag
		inner join (
			select
				idAgencia,
				sum(saldoCartera) saldo
			from gestores
			where estado = 1
			group by idAgencia
		) dt on ag.idAgencia = dt.idAgencia
		where ag.estado = 1
	--agregar
		update zn
		set
			zn.saldoCartera = dt.saldo
		from zonas zn
		inner join (
			select
				ag.idZona,
				sum(gs.saldoCartera) saldo
			from gestores gs
			inner join agencias ag on gs.idAgencia = ag.idAgencia and ag.estado = 1
			where gs.estado = 1
			group by ag.idZona
		) dt on zn.idZona = dt.idZona
		where zn.estado = 1

	exec guardarHistorial

	print concat('Actualizando encabezados de prospectos: ',format(current_timestamp,'HH:mm:ss'))
		exec establecerProspectoC

	print concat('Estableciendo precarga parcial: ',format(current_timestamp,'HH:mm:ss'))
		exec precargaParcial

	exec configuracionesRuta

	exec crearIndicadoresGestor
	exec actualizarInfoExtendida
	exec getInfoExtend_All

	delete from sesionesUsuario
	exec resetIdentity 'sesionesUsuario',0
end