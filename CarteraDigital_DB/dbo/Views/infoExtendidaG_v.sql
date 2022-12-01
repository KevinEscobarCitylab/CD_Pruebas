CREATE VIEW [dbo].[infoExtendidaG_v] as(
	select 
		ga.nombre,
		ga.totalMora,
		ga.totalDesembolso,
		ga.totalVenceHoy,
		ga.totalRenovacion,
		ga.totalPrioridad,
		ga.domicilioReunion,
		ga.representante,
		ga.totalVencimiento,
		ga.montoOtorgado,
		ga.saldoPendiente,
		ga.pagoParaEstarAlDia,
		ga.nCuotaActual,
		gae.*
	from gruposAdesco ga
	left join gruposAdescoExt gae on gae.idGrupoAdesco = ga.idGrupoAdesco
	where ga.idEstado in(1,2)
)
