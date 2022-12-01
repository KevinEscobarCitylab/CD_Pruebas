CREATE view [dbo].[registroActividades_v] as
(
	select
		ra.idRegistroActividad,
		ra.fecha,
		ra.horaGPS,
		ra.idGrupo,
		ra.participantes,
		ra.idCredito,
		ra.idCliente,
		ra.idCampania,
		ra.idClienteP,
		ra.idProspecto,
		ra.idEncuestaR,
		ra.idActividad registroActividad,
		act1.actividad actividadRegistro,
		rc.idActividad reaccionActividad,
		act2.actividad actividadReaccion,
		rc.reaccion,
		da.contactado,
		da.detalle,
		ra.observacion,
		ra.latitud,
		ra.longitud
	from registroActividades ra
	left join actividades act1 on act1.idActividad = ra.idActividad
	left join reacciones rc on rc.idReaccion = ra.idReaccion
	left join actividades act2 on act2.idActividad = rc.idActividad
	left join detalleActividades da on da.idDetalle = ra.idDetalle
	left join motivoActividades mo on mo.idMotivo = ra.idMotivo
	left join gruposAdesco gra on gra.idGrupoAdesco = ra.idGrupo
	where cast(ra.fecha as date) between cast(dateadd(day,-90,getdate()) as date) and cast(getdate() as date)
)
