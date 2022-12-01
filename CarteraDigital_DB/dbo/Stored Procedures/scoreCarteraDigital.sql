CREATE PROCEDURE [dbo].[scoreCarteraDigital] as
	begin
		declare @fechaInicio date = dateadd(MONTH,cast(dbo.fParameters('fechaInfoScore1') as int),getdate())
		declare @fechaFin date = getdate()

		--Conteo por Agencias

			--Porcentaje de mora
			update ag
			set
				ag.porceMora = iif(dt.idAgencia is not null, (dt.mora * 100) / CONVERT(decimal(10,2), dt.total),0) ,
				ag.diasMora = iif(dt.idAgencia is not null, iif(dt.diasMora = 0 or dt.mora = 0,CONVERT(decimal(10,2),0) ,(dt.diasMora * 100) / CONVERT(decimal(10,2), dt.mora)),0)
			from agencias ag
			left join (
				select
					idAgencia,sum(total) as total,sum(mora) as mora, sum(diasCapitalMora) as diasMora
				from (
					select
						a.idAgencia,c.idCredito,1 as total,iif(c.diasCapitalMora > 0,1,0) as mora,c.diasCapitalMora
					from agencias a
					inner join gestores g on g.idAgencia = a.idAgencia
					inner join creditosAsignados ca on ca.idGestor = g.idGestor and ca.asignado = 1
					inner join creditos c on c.idCredito = ca.idCredito
					group by a.idAgencia,c.idCredito,c.diasCapitalMora
				) as dt
				group by idAgencia
			) dt on ag.idAgencia = dt.idAgencia

			--Promedio de gestiones de cobro en los ultimos 6 meses
			update gs
			set
				gs.promedioGestion = iif(dt3.idAgencia is not null,cast(round(convert(decimal, dt3.numGestiones) / dt3.numCreditosAtrasados,4) as float (3)),0)
			from agencias gs
			left join (
				select
					dt2.idAgencia,
					count(1) numCreditosAtrasados,
					sum(dt2.numGestiones) numGestiones
				from(
					select
						dt.idAgencia,
						dt.idCredito,
						count(1) numGestiones
					from (
						select
							hcr.idCredito,
							g.idAgencia,
							max(hcr.mora) as mora
						from historialCreditosAsignados hca
						inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
						inner join gestores g on g.idGestor = hca.idGestor
						where (fechaIn between @fechaInicio  and @fechaFin or
								fechaOut between @fechaInicio  and @fechaFin or
								@fechaInicio  between fechaIn and fechaOut or
								@fechaFin between fechaIn and fechaOut or
								(fechaIn<=@fechaInicio  and fechaIn <= @fechaFin and fechaOut is null)) and
								hcr.fecha between @fechaInicio  and @fechaFin
						group by hcr.idCredito,g.idAgencia
					) dt
					left join registroActividades ra on ra.idCredito = dt.idCredito
					left join reacciones re on re.idReaccion = ra.idReaccion
					left join detalleActividades da on da.idDetalle = ra.idDetalle
					where dt.mora = 1 and (ra.idActividad = dbo.fActividad('COB') or re.idActividad = dbo.fActividad('COB')) and ra.fecha between @fechaInicio  and @fechaFin
					group by dt.idAgencia,dt.idCredito
				) dt2
				group by dt2.idAgencia
			) dt3 on gs.idAgencia = dt3.idAgencia

		--Conteo por Asesores

			set @fechaInicio = dateadd(MONTH,cast(dbo.fParameters('fechaInfoScore2') as int),getdate())

			--Porcentaje de acurdos cumplidos en el ultimo año.
			update gs
			set
				gs.acuerdosCumplidos = dbo.fCumplimiento(numCliente,acuerdosPagados)
			from(
				select
					idGestor,
					sum(iif(montoReal >= montoPrometido,1,0)) acuerdosPagados,
					count(1) numCliente
				from promesasPago_v
				where fechaGestion between @fechaInicio  and @fechaFin
				group by idGestor
			) dt
			inner join gestores gs on gs.idGestor = dt.idGestor

			--Promedio de gestiones recibidas a clientes que han entrado en mora en el ultimo año.
			update gs
			set
				gs.promedioGestionesClientesMora = iif(dt3.idGestor is not null,cast(round(convert(decimal, dt3.numGestiones) / dt3.numCreditosAtrasados,4) as float (3)),0)
			from gestores gs
			left join (
				select
					dt2.idGestor,
					count(1) numCreditosAtrasados,
					sum(dt2.numGestiones) numGestiones
				from(
					select
						dt.idGestor,
						dt.idCredito,
						count(1) numGestiones
					from (
						select
							hcr.idCredito,
							hca.idGestor,
							max(hcr.mora) as mora
						from historialCreditosAsignados hca
						inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
						inner join gestores g on g.idGestor = hca.idGestor
						where (fechaIn between @fechaInicio  and @fechaFin or
								fechaOut between @fechaInicio  and @fechaFin or
								@fechaInicio  between fechaIn and fechaOut or
								@fechaFin between fechaIn and fechaOut or
								(fechaIn<=@fechaInicio  and fechaIn <= @fechaFin and fechaOut is null)) and
								hcr.fecha between @fechaInicio  and @fechaFin
						group by hcr.idCredito,hca.idGestor
					) dt
					left join registroActividades ra on ra.idCredito = dt.idCredito and ra.idGestor = dt.idGestor
					left join reacciones re on re.idReaccion = ra.idReaccion
					left join detalleActividades da on da.idDetalle = ra.idDetalle
					where dt.mora = 1 and (ra.idActividad = dbo.fActividad('COB') or re.idActividad = dbo.fActividad('COB')) and ra.fecha between @fechaInicio  and @fechaFin
					group by dt.idGestor,dt.idCredito
				) dt2
				group by dt2.idGestor
			) dt3 on gs.idGestor = dt3.idGestor

		--Conteo por Clientes

			set @fechaInicio = dateadd(MONTH,cast(dbo.fParameters('fechaInfoScore3') as int),getdate())

			--Conteo de gestiones de cobro recibidas historicamente.
			select
				cr.idCredito,
				cr.idCliente,
				cr.idEstado,
				count(1) as numeroGestiones
			into #conteoGestiones from creditos cr
			left join registroActividades r on cr.idCredito = r.idCredito
			left join reacciones c on r.idReaccion = c.idReaccion
			where r.idActividad = dbo.fActividad('COB') or c.idActividad = dbo.fActividad('COB')
			group by cr.idCredito,cr.idCliente,cr.idEstado

			update cl
			set
				cl.numGestionesCob = iif(gs.idCliente is not null,gs.numeroGestiones,0)
			from clientes cl
			left join (
				select
					dt3.idCliente,
					sum(dt3.numeroGestiones) numeroGestiones
				from (
					select
						dt.idCliente,
						dt.numeroGestiones
					from #conteoGestiones dt
					where dt.idEstado in (1,3)
					union all
					select
						dt2.idCliente,
						dt2.numeroGestiones
					from(
						select
							ROW_NUMBER() over(partition by dt.idCliente order by dt.idCredito desc) id,
							dt.idCliente,
							dt.idCredito,
							dt.numeroGestiones
						from #conteoGestiones dt
						where dt.idEstado = 2
					) dt2
					where dt2.id = 1
				) dt3 group by dt3.idCliente
			) gs on cl.idCliente = gs.idCliente

			--Promedio de gestiones recibidas en los ultimos 3 años.
			update cl
			set
				cl.avgGestionesCob = iif(dt3.idcliente is not null,cast(round(convert(decimal, dt3.numGestiones) / dt3.numCreditos,2) as float (2)),0)
			from clientes cl
			left join (
				select
					dt2.idcliente,
					count(1) numCreditos,
					sum(numGestiones) numGestiones
				from(
					select
						dt.idcliente,
						dt.idCredito,
						count(1) numGestiones
					from (
						select
							hcr.idCredito,
							cr.idcliente
						from historialCreditosAsignados hca
						inner join creditos cr on hca.idcredito = cr.idcredito
						inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
						where (fechaIn between @fechaInicio  and @fechaFin or
								fechaOut between @fechaInicio  and @fechaFin or
								@fechaInicio  between fechaIn and fechaOut or
								@fechaFin between fechaIn and fechaOut or
								(fechaIn<=@fechaInicio  and fechaIn <= @fechaFin and fechaOut is null)) and
								hcr.fecha between @fechaInicio  and @fechaFin
						group by hcr.idCredito,cr.idCliente
					) dt
					left join registroActividades ra on ra.idCredito = dt.idCredito
					left join reacciones re on re.idReaccion = ra.idReaccion
					left join detalleActividades da on da.idDetalle = ra.idDetalle
					where (ra.idActividad = dbo.fActividad('COB') or re.idActividad = dbo.fActividad('COB')) and ra.fecha between @fechaInicio  and @fechaFin
					group by dt.idcliente,dt.idCredito
				) dt2 group by dt2.idCliente
			)
			dt3 on cl.idCliente = dt3.idCliente

			--Promedio de gestiones previo a salir mora
			update cl
			set
				cl.gestionesPrevSalirMora = iif(ds.idcliente is not null,cast(round(convert(decimal, cl.numGestionesCob) / ds.vecesMora,2) as float (2)),0)
			from clientes cl
			left join (
				select
					dt.idCliente,
					count(1) vecesMora
				from (
				select
					ROW_NUMBER() over(partition by hcr.idCredito,hcr.mora order by hcr.idCredito)id,
					hcr.idCredito,
					cr.idcliente ,
					hcr.mora
				from historialCreditosAsignados hca
				inner join creditos cr on hca.idcredito = cr.idcredito
				inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
				where (fechaIn between @fechaInicio  and @fechaFin or
						fechaOut between @fechaInicio  and @fechaFin or
						@fechaInicio  between fechaIn and fechaOut or
						@fechaFin between fechaIn and fechaOut or
						(fechaIn<=@fechaInicio  and fechaIn <= @fechaFin and fechaOut is null)) and
						hcr.fecha between @fechaInicio  and @fechaFin
				) dt where dt.id = 1 and dt.mora = 1
				group by dt.idCliente
			) ds on cl.idCliente = ds.idCliente

			--Porcentaje de acuerdos cumplidos en los ultimos 3 años.
			update cl
			set
				cl.acuerdosCumplidos = dbo.fCumplimiento(numAcuerdos,acuerdosPagados)
			from(
				select
					cr.idCliente,
					sum(iif(vp.montoReal >= vp.montoPrometido,1,0)) acuerdosPagados,
					count(1) numAcuerdos
				from promesasPago_v vp
				inner join creditos cr on vp.idCredito = CR.idCredito
				where fechaGestion between @fechaInicio  and @fechaFin
				group by cr.idCliente
			) dt
			inner join clientes cl on cl.idCliente = dt.idCliente
	end
