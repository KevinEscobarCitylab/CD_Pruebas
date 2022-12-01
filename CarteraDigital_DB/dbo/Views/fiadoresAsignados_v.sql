	create view [dbo].[fiadoresAsignados_v] as
	(
		select 
			fa.idFiadorAsignado,
			f.idFiador,
			f.nombre,
			f.telefono,
			coalesce(f.direccion,'--')as direccion,
			fa.idCredito,
			c.idGestor,
			f.latitud,
			f.longitud,
			f.imgCasa,
			f.imgNegocio,
			f.pendienteCasa,
			f.pendienteNegocio,
			c.diasCapitalMora
		from fiadoresAsignados fa
		inner join fiadores f on f.idFiador = fa.idFiador
		inner join creditosAsignados_v c on c.idCredito = fa.idCredito
		where fa.estado = 1
	)
