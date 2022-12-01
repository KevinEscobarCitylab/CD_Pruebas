create view [dbo].[gestionesRealizadas_v] as(
	select
		dt.idRegistroActividad,
		dt.documento,
		dt.codigoCredito,
		dt.codigoFiador,
		dt.tipoMoneda,
		dt.idProducto,
		dt.usuario,
		dt.tipoActividad,
		dt.actividad,
		dt.idResultado,
		dt.resultado,
		dt.montoPrometido,
		dt.fechaRegistro,
		dt.referencia,
		dt.comentario,
		dt.fechaRuteo,
		dt.fechaProgramada,
		dt.diasAtraso,
		dt.georeferencia,
		dt.cobro
	from(
		select
			Row_Number() over(partition by ra.idCredito,ra.idCliente,ra.idActividad,ra.idDetalle,ra.idReaccion,cast(ra.observacion as varchar(max)),ra.fecha order by ra.idRegistroActividad) id,
			ra.idRegistroActividad,
			cl.codigo as documento,
			cr.referencia as codigoCredito,
			codigoFiador = iif(ac1.idActividad = 12 or ac2.idActividad = 12,f.idFiadorT,null),
			cr.tipoMoneda,
			lc.idLineaT as idProducto,
			g.codigo as usuario,
			tipoActividad = iif(ac2.idActividad is not null,'Llamada','Visita'),
			actividad = coalesce(ac2.actividad,ac1.actividad),
			rc.idReaccion as idResultado,
			rc.reaccion as resultado,
			pp.montoPrometido,
			coalesce(ra.horaGPS,ra.fecha) as fechaRegistro,
			ra.telefono as referencia,
			ra.observacion as comentario,
			rt.fecha as fechaRuteo,
			ra.fechaVisitaReprogramada as fechaProgramada,
			cr.diasCapitalMora as diasAtraso,
			georeferencia = concat(ra.latitud,',',ra.longitud),
			cobro = iif(ac1.idActividad in(2,12,13) or ac2.idActividad in(2,12,13),1,0)
		from registroActividades ra
		inner join actividades ac1 on ac1.idActividad = ra.idActividad
		inner join gestores g on g.idGestor = ra.idGestor
		left join reacciones rc on rc.idReaccion = ra.idReaccion
		left join actividades ac2 on ac2.idActividad = rc.idActividad
		left join promesasPago pp on pp.idRegistroActividad = ra.idRegistroActividad
		inner join creditos cr on cr.idCredito = ra.idCredito
		inner join clientes cl on cl.idCliente = cr.idCliente
		left join fiadoresAsignados fa on fa.idCredito = cr.idCredito
		left join fiadores f on f.idFiador = fa.idFiador
		inner join lineasCredito lc on lc.idLineaCredito = cr.idLineaCredito
		left join rutas rt on rt.idCredito = ra.idCredito and rt.fecha = cast(ra.fecha as date)
		where ac1.idActividad in(2,6,7,8,12,13,19) or ac2.idActividad in(2,6,7,8,12,13,19)
	) dt
	where dt.id=1
)