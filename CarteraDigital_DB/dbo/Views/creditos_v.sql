

CREATE view [dbo].[creditos_v] as
(
	select
		cr.idCredito,
		cr.idCliente,
		iif(cr.diasCapitalMora<>0 and cr.idEstado<>dbo.fEstadoCredito('SAN'),1,0) as mora,
		iif(cr.seguimiento<>0,1,0) as seguimiento,
		iif(cr.desertado<>0,1,0) as desertado,
		iif(cr.renovacion<>0,1,0) as renovacion,
		iif(cr.idEstado=dbo.fEstadoCredito('SAN'),1,0) as saneado,
		iif(cr.diasCapitalMora=0 and cr.renovacion=0 and cr.desertado=0 and cr.seguimiento=0 and cr.idEstado<>dbo.fEstadoCredito('SAN'),1,0) as aldia,
		iif((cl.latitud is not null and cl.longitud is not null) or (cl.latitudNegocio is not null and cl.longitudNegocio is not null) ,iif( (LEN(cl.latitud) > 0 and LEN(cl.longitud) > 0) or (LEN(cl.latitudNegocio) > 0 and LEN(cl.longitudNegocio) > 0) ,1,0),0) gps
	from creditosAsignados ca
	inner join creditos cr on cr.idCredito = ca.idCredito
	inner join clientes cl on cl.idCliente = cr.idCliente
	left join gruposAdesco_v ga on ga.idGrupoAdesco = cr.idGrupo
	left join actividadesEconomicas ae on ae.idActividadE=cl.idActividadE
	where cr.idEstado != dbo.fEstadoCredito('CAN') and ca.asignado != 0
)
