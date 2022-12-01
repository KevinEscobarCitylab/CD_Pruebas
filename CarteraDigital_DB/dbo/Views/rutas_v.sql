

CREATE view [dbo].[rutas_v] as
(
	select 
		r.* 
	from rutas r
	where r.fecha = cast(GETDATE()as date) and estado = 1
)
