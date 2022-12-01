CREATE procedure [dbo].[actualizarCartera] as
begin
--LineasCredito
--	insert into lineasCredito
--	(idLineaT,lineaCredito)
--	select
--		s.[Codigo],
--		s.[Nombre]
--	from lineasCredito t
--	right outer join [ODS].[CarteraActiva].[LineaCredito] s on s.[Codigo] = t.idLineaT
--	where t.idLineaCredito is null

----Zonas
--	insert into zonas 
--	(idZonaT,zona)
--	select
--		s.[Codigo],
--		s.[Nombre]
--	from zonas t
--	right outer join [ODS].[CarteraActiva].[Zonas] s on s.[Codigo] = t.idZonaT
--	where t.idZona is null

----Agencias
--	insert into agencias
--	(idAgenciaT,agencia,idZona)
--	select 
--		s.[CodigoAgencia],
--		s.[Nombre],
--		z.idZona
--	from agencias t
--	right outer join [ODS].[CarteraActiva].[Agencias] s on s.[CodigoAgencia] = t.idAgenciaT
--	left join zonas z on z.idZonaT = s.[CodigoZona]
--	where t.idAgencia is null 

----Gestores
--	insert into gestores 
--	(codigo,nombre,idAgencia,idGrupo,ruta,estado,sistema)
--	select
--		rtrim(s.[CodigoGestor]) as idG,
--		rtrim(s.[Nombre]) as G,
--		a2.idAgencia as a2,
--		iif(s.[Puesto]='GTE SR DE RECUPERACIONES' or 
--		s.[Puesto]='ABOGADO DICTAMINADOR' or
--		s.[Puesto]='COORD DE RECUPERACION'or
--		s.[Puesto]='EJECUTIVO DE RECUPERACION' or
--		s.[Puesto]='GTE DE RECUPERACION' or
--		s.[Puesto]='SUBDIRECTOR DE RECUPERACION',8,7),
--		0,
--		1,
--		1
--	from gestores t
--	right outer join [ODS].[CarteraActiva].[Gestores] s on s.[CodigoGestor] = t.codigo
--	inner join agencias a2 on a2.idAgenciaT = s.[CodigoSucursal]
--	where t.idGestor is null 
	
--	update gestores set estado=0 where estado=1 and sistema = 1

--	update t
--	set
--		t.estado = 1
--	from gestores t
--	inner join [ODS].[CarteraActiva].[Gestores]  s on s.[CodigoGestor] = t.codigo

----Clientes
--	insert into clientes
--	(idClienteT,codigo,nombre,direccion,nDoc)
--	select
--		s.[Codigo],
--		s.[Codigo],
--		s.[Nombre],
--		s.[DireccionCliente],
--		s.[CURP]
--	from clientes t 
--	right outer join [ODS].[CarteraActiva].[Clientes] s on s.[Codigo] = t.codigo
--	where t.idCliente is null

--	update t
--	set
--		t.direccion = s.[DireccionCliente]
--	from clientes t
--	inner join [ODS].[CarteraActiva].[Clientes] s on s.[Codigo] = t.codigo

----telefonosCliente
--	insert  telefonosCliente
--	(idCliente,telefono)
--	select
--		cl.idCliente,
--		s.[Descripcion]
--	from [ODS].[CarteraActiva].[Telefono] s
--	inner join clientes cl on cl.idClienteT = s.[CodigoDAComp]
--	left join telefonosCliente t on t.idCliente=cl.idCliente and t.telefono=s.[Descripcion]
--	where t.idTelefono is null

----cliente Cancelados
--	insert into clientes
--	(idClienteT,codigo,nombre,nDoc,direccion)
--	select
--		s.[Codigo],
--		s.[Codigo],
--		s.[Nombre],
--		s.[CURP],
--		s.[DireccionCliente]
--	from clientes t 
--	right outer join  [ODS].[CarteraActiva].[Clientes90DiasVencido] s on s.[Codigo] = t.idClienteT
--	where t.idCliente is null 

----GruposAdesco
--	insert into gruposAdesco
--	(idGrupoAdescoT,nombre,representante,idOrganizacion,idEstado)
--	select distinct
--		rtrim(s.[Codigo]),
--		rtrim(s.[Nombre]),
--		cl.nombre,
--		null,
--		e.idEstado
--	from gruposAdesco t
--	right outer join [ODS].[CarteraActiva].[Grupos] s on s.[Codigo] = t.idGrupoAdescoT
--	left join clientes cl on cl.idClienteT = s.[CodigoClientePresidente]
--	inner join estadosGruposAdesco e on e.codigo = 'ACT'
--	where t.idGrupoAdesco is null

----fiadores
--	insert into fiadores
--	(idFiadorT,nombre,telefono,direccion)
--	select
--		ft.[CodigoAval],
--		ft.[Nombre],
--		ft.[Telefono],
--		ft.[DireccionCliente]
--	from [ODS].[CarteraActiva].[Fiador] ft
--	left join fiadores f on f.idFiadorT = ft.[CodigoAval]
--	where f.idFiador is null

--	update t
--	set
--		t.direccion = s.[DireccionCliente],
--		t.telefono = s.[Telefono]
--	from fiadores t
--	inner join [ODS].[CarteraActiva].[Fiador]  s on s.[CodigoAval] = t.idFiadorT

----fiadores Asignados
--	insert into fiadoresAsignados
--	(idFiador,idCredito,idFiadorT,referencia)
--	select 
--		f.idFiador,
--		c.idCredito,
--		f.idFiadorT,
--		c.idCreditoT
--	from [ODS].[CarteraActiva].[Fiador]  ft
--	inner join fiadores f on f.idFiadorT = ft.[CodigoAval]
--	inner join creditos c on c.idCreditoT = ft.[codigoUnico]
--	left join fiadoresAsignados fa on fa.idCredito = c.idCredito and fa.idFiador = f.idFiador
--	where fa.idFiadorAsignado is null

----Creditos
--	update creditos set cuotaVenceHoy = 0, idEstado = 2 where idEstado in(1,3)
--	insert into creditos
--	(idCreditoT,referencia,pagoParaEstarAlDia,pagoParaTramo30,pagoParaTramo60,pagoParaTramo90,valorCuota,diasCapitalMora,deudaTotal,ultimoPago,fechaOtorgamiento,fechaDesembolso
--	,fechaVencimiento,fechaCancelacion,fechaProximaCuota,saldoCapitalVencido,saldoCapitalVigente,montoOtorgado,montoReserva,montoProximaCuota,ultimaFechaPago,plazo,frecuencia
--	,cantidadCuotas,idLineaCredito,tasaInteresNominal,atrasoMaximo,idGrupo,idAgencia,calificacionCliente,atrasoPromedio,cuotasPagadas,cuotasNoPagadas,ciclo,interes,seguro,recargo
--	,clasificacion,asesorColocador,asesorAnterior,fechaCambioAsesor,montoRecuperado,categoriaAnterior,idCliente,idEstado,desertado)
--	select distinct
--		s.[codigoUnico],
--		s.[codigoUnico],
--		coalesce(s.[MontoParaPonerAlCorrienteLaCuenta],0),
--		s.[PagosParaTramoMeta1],
--		s.[PagosParaTramoMeta2],
--		s.[PagosParaTramoMeta3],
--		coalesce(s.[MontoDeLaSiguienteCuota],0),
--		s.[DiasAtraso],
--		s.[MontoParaLiquidarCredito],
--		coalesce(s.[MontoUltimoPago],0),
--		s.[FechaEntrega],
--		s.[FechaDesembolso],
--		s.[FechaVencimiento],
--		s.[FechaLiquidacionPrestamo],
--		s.[FechaSiguienteCuota],
--		s.[SaldoVencidoAlDiaCapital],
--		s.[SaldoTotalAlDiaCapital],
--		s.[MontoEntregado],
--		coalesce(s.[MontoGarantiaLiquida],0),
--		s.[MontoDeLaSiguienteCuota],
--		s.[FechaUltimoPago],
--		s.[PlazoEnMeses],
--		s.[Frecuencia],
--		s.[NumeroCuotas],
--		lc.idLineaCredito,
--		s.[Tasa],
--		coalesce(s.[DiasAtrasoMaximoQueTuvoElCredito],0),
--		g.idGrupoAdesco,
--		a.idAgencia,
--		s.[Calificacion],
--		coalesce(s.[DiasAtrasoPromedio],0),
--		s.[CantidadDeCuotasPagadas],
--		s.[CantidadDeCuotasPenditesPorPagar],
--		s.[Ciclo],
--		s.[SaldoParaLiquidarIntereses],
--		s.[SaldoParaLiquidarComisiones],
--		s.[SaldoParaLiquidarRecargos],
--		s.[Clasificacion],
--		g1.nombre,
--		g2.nombre,
--		s.[FechaAsignacionAsesorActual],
--		coalesce(s.[MontoAcomuladoRecuperado],0),
--		s.[CategoriaAnterior],
--		cl.idCliente,
--		e.idEstado,
--		0
--	from creditos t
--	right outer join [ODS].[CarteraActiva].[Creditos] s on s.[codigoUnico] = t.referencia
--	inner join estadosCredito e on e.codigo = 'VIG'
--	inner join clientes cl on cl.codigo = s.[CodigoCliente]
--	left join lineasCredito lc on lc.idLineaT = s.[LineaCredito]
--	left join agencias a on a.idAgenciaT = s.[CodigoSucursal]
--	left join gruposAdesco g on g.idGrupoAdescoT = s.[CodigoGrupo]
--	left join gestores g1 on g1.idGestorT = s.[CodigoAsesorColocador]
--	left join gestores g2 on g2.idGestorT = s.[CodigoAsesorAnterior]
--	where t.idCredito is null

--	update t
--	set
--		t.diasCapitalMora = s.[DiasAtraso],
--		t.pagoParaEstarAlDia = s.[MontoParaPonerAlCorrienteLaCuenta],
--		t.ultimoPago = s.[MontoUltimoPago],
--		t.ultimaFechaPago = s.[FechaUltimoPago],
--		t.pagoParaTramo30 = s.[PagosParaTramoMeta1],
--		t.pagoParaTramo60 = s.[PagosParaTramoMeta2],
--		t.pagoParaTramo90 = s.[PagosParaTramoMeta3],
--		t.montoProximaCuota = s.[MontoDeLaSiguienteCuota],
--		t.deudaTotal = s.[MontoParaLiquidarCredito],
--		t.calificacionCliente = s.[Calificacion],
--		t.saldoCapitalVigente = s.[SaldoTotalAlDiaCapital],
--		t.saldoCapitalVencido = s.[SaldoVencidoAlDiaCapital],
--		t.fechaProximaCuota = s.[FechaSiguienteCuota],
--		t.atrasoMaximo = s.[DiasAtrasoMaximoQueTuvoElCredito],
--		t.atrasoPromedio = s.[DiasAtrasoPromedio],
--		t.cuotasPagadas = s.[CantidadDeCuotasPagadas],
--		t.cuotasNoPagadas = s.[CantidadDeCuotasPenditesPorPagar],
--		t.interes = s.[SaldoParaLiquidarIntereses],
--		t.seguro = s.[SaldoParaLiquidarComisiones],
--		t.recargo = s.[SaldoParaLiquidarRecargos],
--		t.clasificacion = s.[Clasificacion],
--		t.montoRecuperado = s.[MontoAcomuladoRecuperado],
--		t.idEstado = 1
--	from creditos t
--	inner join [ODS].[CarteraActiva].[Creditos] s on s.[codigoUnico] = t.referencia

--	update creditos set desembolso = 0 where desembolso = 1
--	update creditos set desembolso = 1 where diasDesembolso = 0

--	update creditos set cuotaVenceHoy = 0 where cuotaVenceHoy = 1
--	update creditos set cuotaVenceHoy = 1 where fechaProximaCuota = cast(GETDATE() as date)

----creditos Cancelados
	--update t
	--set
	--	t.fechaCancelacion = s.[FechaLiquidacionPrestamo],
	--	t.idGrupo = null,
	--	t.diasCapitalMora = 0
	--from creditos t
	--inner join [ODS].[CarteraActiva].[Creditos90DiasVencido] s on s.[codigoUnico] = t.referencia

----Creditos cancelados y clientes desertados
	--declare @dt table (NumeroCredito varchar(50), identificacion varchar(50))
	--insert @dt select [codigoUnico] as NumeroCredito,[CodigoCliente] as Identificacion from [ODS].[CarteraActiva].[Creditos90DiasVencido] 

	--update clientes set desertado = 0 where desertado = 1

	--update t
	--set
	--	desertado = 1
	--from clientes t
	--inner join(select Identificacion from @dt group by Identificacion) s on s.Identificacion = t.codigo

	--update creditos set desertado = 0 where desertado = 1
	--update t
	--set
	--	idEstado = 2,
	--	diasCapitalMora = 0
	--from creditos t
	--inner join @dt s on s.NumeroCredito = t.referencia

	--update t
	--set
	--	desertado = 0
	--from clientes t
	--inner join(select cl.idCliente from creditos cr inner join clientes cl on cl.idCliente = cr.idCliente where cl.desertado = 1 and cr.idEstado = 1 group by cl.idCliente)s on s.idCliente = t.idCliente

	--update t
	--set
	--	desertado = 1
	--from creditos t
	--inner join(
	--	select *from(
	--		select 
	--			ROW_NUMBER() OVER(partition by cl.idCliente order by fechaCancelacion desc) AS ID,
	--			fechaCancelacion,
	--			idCredito
	--		from creditos cr
	--		inner join clientes cl on cl.idCliente = cr.idCliente
	--		where cl.desertado = 1
	--	)as ds
	--	where ID = 1
	--)s on s.idCredito = t.idCredito

----CreditosAsignados
--	update creditosAsignados set asignado = 0 where asignado = 1

--	insert into creditosAsignados
--	(idCredito,idCreditoT,idGestorT,idGestor,asignado)
--	select
--		cr.idCredito,
--		s.[codigoUnico],
--		s.[CodigoDAComp],
--		g.idGestor,
--		1
--	from creditosAsignados t
--	right outer join [ODS].[CarteraActiva].[CreditosAsignados] s on s.[codigoUnico] = t.idCreditoT and s.[CodigoDAComp] = t.idGestorT
--	left join creditos cr on cr.referencia = s.[codigoUnico]
--	left join gestores g on g.codigo = s.[CodigoDAComp]
--	where t.idCreditoAsignado is null 

--	update t set t.idGestor = g.idGestor
--	from creditosAsignados t
--	inner join gestores g on g.codigo = t.idGestorT
--	where t.idGestor is null

--	update t  set  asignado= 1
--	from  creditosAsignados t
--	inner join [ODS].[CarteraActiva].[CreditosAsignados] s on s.[codigoUnico] = t.idCreditoT and s.[CodigoDAComp] = t.idGestorT
--	where t.asignado!=1

----historialUltimosPagos
--	truncate table historialUltimosPagos

--	insert into historialUltimosPagos 
--	(idCredito,referencia,fechaPago,monto,comprobante)
--	select 
--		c.idCredito,
--		s.[codigoUnico],
--		s.[FechaPago],
--		s.[Monto],
--		s.[NumeroTicket]
--	from [ODS].[CarteraActiva].[HistorialPagos] s
--	inner join creditos c on c.referencia = s.[codigoUnico]
	
----Usuarios
	declare @fechaCierre date = cast(DATEADD(Day,-1,GETDATE()) as date)
	
--	insert into usuarios
--	(idGestor,usuario,clave,idGrupo,fechaCierre,verificador,diasDesdeCambioClave,multiplesDispositivos,sessionid)
--	select
--		s.idGestor,
--		rtrim(s.codigo),
--		dbo.md5(lower(rtrim(s.codigo))),
--		s.idGrupo,
--		@fechaCierre,
--		0,
--		0,
--		1,
--		0
--	from usuarios t
--	right outer join gestores s on s.idGestor = t.idGestor
--	where t.idUsuario is null

	update usuarios 
	set 
		fechaCierre = @fechaCierre, 
		diasDesdeCambioClave = DATEDIFF(DAY,coalesce(fechaCambioClave,fechaCierre),GETDATE()),
		fechaCambioClave = coalesce(fechaCambioClave,fechaCierre)

	--Cumplimiento de rutas
	insert cumplimientoRuta
	(idGestor,meta,valor,fecha)
	select
		s.idGestor,
		s.meta,
		s.cumplido,
		s.fecha
	from cumplimientoRuta t
	right outer join cumplimientoRuta_v s on s.fecha = t.fecha
	where t.idGestor is null

	declare @fecha1 date = format(getdate(),'yyyy-MM-01')
	declare @fecha2 date= getdate()

	truncate table indicadoresGestor

	insert indicadoresGestor
	(idIndicador,idGestor,meta,valor)
	select 
		15,
		idGestor,
		sum(meta)as meta,
		sum(valor)as valor
	from cumplimientoRuta
	where fecha between @fecha1 and @fecha2
	group by idGestor

	--find Prospecto del cliente
	update c set
	c.idProspecto = t.idProspecto
	from creditos c
	inner join clientes cl on cl.idCliente = c.idCliente
	inner join (
		select nDoc,max(idProspecto) as idProspecto
		from prospectos
		group by nDoc
	) t on t.nDoc = cl.nDoc
	where c.idProspecto is null

	exec establecerCriterios
end