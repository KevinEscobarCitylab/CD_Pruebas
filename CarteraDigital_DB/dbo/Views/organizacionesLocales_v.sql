

CREATE view [dbo].[organizacionesLocales_v] as
(
	select distinct
	ol.idOrganizacion,
	cast(ol.nombre as varchar(max))as nombre,
	ol.totalMora,
	ol.totalRenovacion,
	ol.totalVenceHoy,
	ol.totalPrioridad,
	ol.totalDesembolso,
	ca.idGestor
	from organizacionesLocales ol
	inner join gruposAdesco ga on ga.idOrganizacion = ol.idOrganizacion
	inner join creditos cr on cr.idGrupo = ga.idGrupoAdesco
	inner join creditosAsignados ca on ca.idCredito = cr.idCredito
	where ca.asignado = 1
)


