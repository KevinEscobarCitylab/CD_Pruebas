--Proceso para obtener la distancia de las gestiones realizadas, el cual debe ejecutarse para obtener la distancia de las gestiones de los ultimos 30 dias
	declare @RegistrosAct table(
		id int identity(1,1) primary key clustered,
		idRA int,
		idGestor int,
		latitud decimal(20,7),
		longitud decimal(20,7),
		horaGPS date
	)

	declare @r int = 6378
	declare @const decimal(10,5) = (pi()/180)

	insert into @RegistrosAct (idRA,idGestor,latitud,longitud,horaGPS)
	select 
		idRegistroActividad,idGestor, TRY_PARSE(latitud AS decimal(20,07)), TRY_PARSE(longitud AS decimal(20,07)),horaGPS
	from registroActividades 
	where idGestor is not null and CAST(fecha as date) between cast(dateadd(DAY,-30,GETDATE()) as date) and cast(GETDATE() as date)
	order by idGestor,horaGPS

	update ra
	set
		ra.distancia = d1.distanciaReco,
		ra.registroComparado = d1.idActAnt
	from(
		select
			a.id,
			a.idRA,
			a.idGestor,
			b.idRA idActAnt,
			iif(b.id is null or a.idGestor != b.idGestor or b.latitud is null or DATEDIFF(day,b.horaGPS,a.horaGPS) != 0,0, cast(round( (2*@r*asin(sqrt(power(sin((@const*(b.latitud-a.latitud))/2),2) + power(cos(@const*a.latitud) * cos(@const*b.latitud) * sin((@const*(b.longitud-a.longitud))/2),2)))) ,2) as float (2))) distanciaReco
		from @RegistrosAct a 
		left join @RegistrosAct b on a.id = (b.id + 1)
	) d1
	inner join registroActividades ra on ra.idRegistroActividad = d1.idRA
go