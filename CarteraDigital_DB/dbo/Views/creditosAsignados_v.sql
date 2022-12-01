	create view [dbo].[creditosAsignados_v] as
	(
		select
			cr.idCredito,
			cr.idCreditoT,
			cr.referencia,
			cl.codigo codCliente,
			cr.pagoParaEstarAlDia,
			cr.valorCuota,
			cr.diasCapitalMora,
			cr.seguimiento,
			cr.renovacion,
			cr.desertado,
			cr.desembolso,
			cr.prioridad,
			cr.cobroPreventivo,
			iif(cr.idEstado = dbo.fEstadoCredito('S'),1,0) saneado,
			cr.tarjeta,
			cr.idGrupo,
			cr.idProspecto,
			cr.idEstado,
			cr.saldoCapitalVigente,
			cl.idCliente,
			cl.idClienteT,
			cl.nombre cliente,
			cl.longitud,
			cl.latitud,
			cl.longitudNegocio,
			cl.latitudNegocio,
			cl.nDoc,
			cr.idAgencia agenciaCredito,
			gs.idGestor,
			gs.nombre asesor,
			gs.idAgencia,
			ag.agencia,
			ag.idZona,
			zon.zona,
			gs.idGrupo idGrupoGestor,
			ca.asignado,
			gs.saldoCartera
		from creditosAsignados ca
		inner join creditos cr on cr.idCredito =  ca.idCredito
		inner join gestores gs on gs.idGestor = ca.idGestor and gs.estado = 1 
		inner join agencias ag on ag.idAgencia = gs.idAgencia and ag.estado = 1
		inner join zonas zon on zon.idZona = ag.idZona and zon.estado = 1
		inner join clientes cl on cl.idCliente = cr.idCliente
		where ca.asignado = 1 and cr.idEstado != 2 and gs.idGrupo in (dbo.fGrupo('ASC'),dbo.fGrupo('GCB'))
	)
