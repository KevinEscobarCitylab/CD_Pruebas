
CREATE view [dbo].[cumplimientoRuta_v] as
(
	select 
		ds.*,
		mg.meta,
		cast(dateadd(day,-1,getdate()) as date) as fecha
	from(
		select 
			idGestor,
			sum(total)as totalRuta,
			sum(cumplido)as cumplido
		from(
			select 
				idGestor,
				sum(cr)as creditos,
				sum(pr) as prospectos,
				sum(adm)as administrativas,
				min(valid)as cumplido,
				1 as total
			from(
				select 
					r.idRuta,
					r.idGestor,
					iif(ra.idCredito is not null,1,0) cr,
					iif(ra.idProspecto is not null,1,0) pr,
					iif(ra.idActividad = 1,1,0) adm,
					iif(ra.idCredito is not null or ra.idProspecto is not null or ra.idActividad is not null,1,0)as valid
				from rutas r
				left join registroActividades ra on (
					ra.idCredito = r.idCredito 
					or ra.idProspecto=r.idProspecto 
					or (ra.idActividad=1 and ra.idActividad = r.idActividad)
				) 
				and DATEDIFF(day,ra.fecha,GETDATE()) = 1
				where DATEDIFF(day,r.fecha,GETDATE()) = 1 
			)as ds
			group by idRuta,idGestor
		)dt
		group by idGestor
	)as ds
	inner join gestores g on g.idGestor = ds.idGestor
	inner join metasGestorIndicador mg on mg.idGestor = g.idGestor
)
