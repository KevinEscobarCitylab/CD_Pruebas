
CREATE view [dbo].[indicadoresGestor_v] as
(
	select 
		dt.*,
		c.color,
		c.descripcion
	from(
		select 
		g.idGestor,
		ig.idIndicador,
		i.nombre as indicador,
		ig.valor,
		ig.valorT,
		ig.meta,
		dbo.fMetaPorcentual(ig.valor,ig.meta,i.inverso)as porcentual,
		cast((cast(ig.valor as float)-cast(ig.meta as float))as decimal(10,2))as diferencia,
		dbo.fIndicador(g.idGestor,ig.idIndicador,dbo.fMetaPorcentual(ig.valor,ig.meta,i.inverso))as idColor,
		i.valorA,
		i.valorM
		from gestores g
		inner join indicadoresGestor ig on ig.idGestor = g.idGestor
		inner join indicadores i on i.idIndicador = ig.idIndicador and g.idGrupo = i.idGrupo
	)as dt
	inner join coloresIndicador c on c.idColor = dt.idColor
	where dt.valor is not null
)
