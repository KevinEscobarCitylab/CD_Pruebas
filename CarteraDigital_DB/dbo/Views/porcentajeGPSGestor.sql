create   view porcentajeGPSGestor as
(
	select
		t.idGestor as idGestor,
		(geolocalizados + noGeolocalizados) as totalCartera,
		geolocalizados * 100 / (geolocalizados + noGeolocalizados) as valor,
		mg.meta,
		mg.idindicador
	from gestores t
	inner join (
		select 
			idGestor,
			count(1) as geolocalizados 
		from cartera_v 
		where (latitud is not null and longitud is not null) or (latitudNegocio is not null and longitudNegocio is not null)
		group by idGestor
	) as s on s.idGestor = t.idGestor
	inner join (
		select 
			idGestor,
			count(1) as noGeolocalizados 
			from cartera_v 
		where (latitud is null and longitud is null) and (latitudNegocio is null and longitudNegocio is null)
		group by idGestor
	) as s2 on s2.idGestor = t.idGestor
	inner join metasGestorIndicador mg on mg.idGestor = t.idGestor 
	inner join indicadores i on mg.idIndicador = i.idIndicador and i.codigo = 'GPS'
	where t.estado = 1
)