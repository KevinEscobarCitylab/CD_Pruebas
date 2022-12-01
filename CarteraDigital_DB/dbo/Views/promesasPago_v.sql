
CREATE   view [dbo].[promesasPago_v] as
(
	select
		dt3.idPromesa,
		dt3.fechaPromesa,
		dt3.montoPrometido,
		dt3.diasPromesa,
		dt3.montoReal,
		dt3.fechaPagoValid,
		dt3.fechaPagoExtend,
		dt3.montoPagado,
		dt3.idCredito,
		dt3.idGestor,
		dt3.fechaGestion,
		dt3.idRegistroActividad 
	from(
		select
			row_number() over(partition by dt2.idPromesa order by dt2.idPromesa desc) as id,
			dt2.*,
			hup.monto as montoPagado
		from(
			select 
				dt.idPromesa,
				dt.fechaPromesa,
				dt.montoPrometido,
				dt.diasPromesa,
				dt.montoReal,
				dt.fechaPagoValid,
				coalesce(min(hup.fechaPago),null) as fechaPagoExtend,
				dt.idCredito,
				dt.idGestor,
				dt.fechaGestion,
				dt.idRegistroActividad 
			from(
				select 
					pp.idPromesa,
					pp.fechaPromesa,
					pp.montoPrometido,
					(select datediff(day,getdate(),pp.fechaPromesa)) as diasPromesa,
					coalesce(sum(hup.monto),0) as montoReal,
					coalesce(max(hup.fechaPago),null) as fechaPagoValid,
					pp.idCredito,
					pp.idGestor,
					pp.fechaGestion,
					r.idRegistroActividad
				from promesasPago pp
				inner join registroActividades r on r.idRegistroActividad = pp.idRegistroActividad
				inner join creditos cr on cr.idCredito = r.idCredito
				left join historialUltimosPagos hup on hup.idCredito = r.idCredito and hup.fechaPago between pp.fechaGestion and pp.fechaPromesa
				group by pp.idPromesa,pp.fechaPromesa,pp.montoPrometido,pp.idCredito,pp.idGestor,pp.fechaGestion,r.idRegistroActividad
			) as dt
			left join historialUltimosPagos hup on hup.idCredito = dt.idCredito and hup.fechaPago between dt.fechaPromesa and getdate()
			group by dt.idPromesa,dt.fechaPromesa,dt.montoPrometido,dt.diasPromesa,dt.montoReal,dt.fechaPagoValid,dt.idCredito,dt.idGestor,dt.fechaGestion,dt.idRegistroActividad 
		) as dt2
		left join historialUltimosPagos hup on hup.idCredito = dt2.idCredito and hup.fechaPago = dt2.fechaPagoExtend
	) as dt3 
	where dt3.id = 1
)
