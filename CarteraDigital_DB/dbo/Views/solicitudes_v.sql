
CREATE view [dbo].[solicitudes_v] as
(
	select 
	dt.*,
	coalesce(p.valor,0) as prioridad
	from(
		select
		s.idSolicitud,
		s.idGestor,
		s.idCliente,
		s.idSolicitudT as codigo,
		lc.lineaCredito,
		lc.destino,
		c.idClienteT as codigoCliente,
		c.nombre as cliente,
		c.direccion,
		c.telefono,
		c.tipoCliente,
		s.montoSolicitado,
		c.latitud,
		c.longitud,
		c.latitudNegocio,
		c.longitudNegocio,
		DATEDIFF(day,s.fecha,GETDATE())as diasSolicitud,
		s.idPrioridad,
		s.diasPrioridad,
		s.prioridadAgencia,
		s.totalGestiones,
		s.estado
		from solicitudes s
		inner join clientes c on c.idCliente = s.idCliente
		inner join lineasCredito lc on lc.idLineaCredito = s.idLineaCredito
		where s.estado = 1 
	) as dt
	left join prioridades p on p.idPrioridad = dt.idPrioridad
)
