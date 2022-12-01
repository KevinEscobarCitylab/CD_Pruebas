
CREATE view [dbo].[gruposGestor_v] as
(
	select
	ca.idCreditoAsignado, 
	dt.*,
	ca.idCredito,
	cr.diasCapitalMora,
	ca.asignado,
	ca.sistema,
	ec.codigo
	from(
		select 
		gg.*,
		g.idGrupo,
		gr.codigo as codigoG
		from gruposGestor gg
		inner join gestores g on g.idGestor = gg.idGestor
		inner join grupos gr on gr.idGrupo = g.idGrupo
	)as dt
	inner join creditosAsignados ca on ca.idGestor = dt.idAsesor
	inner join creditos cr on cr.idCredito = ca.idCredito
	inner join estadosCredito ec on cr.idEstado = ec.idEstado
	where dt.estado != 0 and ca.asignado !=0
)
