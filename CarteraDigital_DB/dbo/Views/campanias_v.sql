
CREATE view [dbo].[campanias_v] as
(
	select
		cc.idClienteCampania,
		cp.idCampania,
		cp.titulo,
		cp.proposito,
		cc.idGestor,
		cr.idCredito,
		cl.idCliente,
		clp.idClienteP,
		cl.latitud,
		cl.longitud,
		cl.latitudNegocio,
		cl.longitudNegocio,
		cr.referencia,
		iif(cl.idCliente is null,clp.nombre,cl.nombre)as cliente,
		iif(cl.idCliente is null,clp.direccion,cl.direccion)as direccion,
		iif(cl.idCliente is null,clp.telefono,cl.telefono)as telefono,
		cp.fechaInicio,
		cp.fechaFin,
		datediff(day,cp.fechaInicio,GETDATE())as diasCampania,
		datediff(day,GETDATE(),cp.fechaFin)as diasFinalizacion,
		cc.DUG,
		cc.UG
	from clientesCampania cc
	inner join campanias cp on cp.idCampania = cc.idCampania
	left join creditos cr on cr.idCredito = iif(cc.idCredito is not null,cc.idCredito,(select top 1 idCredito from creditos where idCliente = cc.idCliente order by idCredito desc))
	left join clientes cl on cl.idCliente = iif(cc.idCliente is not null, cc.idCliente,(select top 1 idCliente from creditos where idCredito = cc.idCredito order by idCredito desc))
	left join clientesPotenciales clp on clp.idClienteP = cc.idClienteP
	where GETDATE() between cp.fechaInicio and cp.fechaFin and cc.estado = 1
)
