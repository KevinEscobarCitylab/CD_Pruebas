﻿CREATE VIEW [dbo].[infoExtendidaC_v] as(
	select 
		cr.pagoParaEstarAlDia,
		cr.pagoParaTramo30,
		cr.pagoParaTramo60,
		cr.pagoParaTramo90,
		cr.valorCuota,
		cr.diasCapitalMora,
		cr.deudaTotal,
		cr.ultimoPago,
		cr.fechaOtorgamiento,
		cr.fechaDesembolso,
		cr.diasDesembolso,
		cr.fechaVencimiento,
		cr.fechaCancelacion,
		cr.diasRestantesPlazo,
		cr.fechaProximaCuota,
		cr.saldoCapitalVencido,
		cr.saldoCapitalVigente,
		cr.montoOtorgado,
		cr.montoReserva,
		cr.montoCanceladoPorcentual,
		cr.montoProximaCuota,
		cr.capitalMora,
		cr.capitalTotalAdeudado,
		cr.ultimaFechaPago,
		cr.plazo,
		cr.frecuencia,
		cr.cantidadCuotas,
		cr.plazoTranscurridoPorcentual,
		cr.tasaInteresNominal,
		cr.calificacionCliente,
		cr.notaCliente,
		cr.atrasoMaximo,
		cr.cuotasPagadas,
		cr.cuotasNoPagadas,
		cr.ciclo,
		cr.clasificacion,
		cr.atrasoPromedio,
		cr.diasProximaCuota,
		cr.seguimiento,
		cr.desertado,
		cr.renovacion,
		lc.lineaCredito,
		cr.ampliacion,
		cr.diasDesertado,
		cl.nombre,
		cl.direccion,
		cl.nDoc,
		cle.*, cre.* 
	from creditos cr
	inner join clientes cl on cl.idCliente = cr.idCliente
	left join lineasCredito lc on lc.idLineaCredito = cr.idLineaCredito
	left join clientesExt cle on cle.idCliente = cl.idCliente
	left join creditosExt cre on cre.idCredito = cr.idCredito
	where cr.idEstado = 1
)
