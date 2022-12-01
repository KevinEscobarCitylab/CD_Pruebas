
	create     view [dbo].[gruposAsesor_v] as
	(
		select distinct
			ga.idGrupoAdesco,
			ga.idGrupoAdescoT as codigoGrupo,
			cast(ga.nombre as varchar(max))as nombre,
			ga.totalMora,
			ga.totalRenovacion,
			ga.totalVenceHoy,
			ga.totalPrioridad,
			ga.totalDesembolso,
			ga.totalVencimiento,
			ca.idGestor,
			ga.idEstado,
			ga.representante,
			ga.actualizado,
			ga.latitud,
			ga.longitud,
			cast(ga.domicilioReunion as varchar(max))as domicilioReunion,
			ga.imgReferencia,
			ga.pendienteReferencia,
			cast(ga.infoE as varchar(max)) infoE,
			cast(ga.emergentes as varchar(max)) emergentes
		from gruposAdesco ga
		inner join creditos cr on cr.idGrupo = ga.idGrupoAdesco
		inner join estadosCredito ec on ec.idEstado = cr.idEstado
		inner join creditosAsignados ca on ca.idCredito = cr.idCredito
		where ca.asignado = 1 and ec.codigo != 'CAN'
		union
		select 
			ga.idGrupoAdesco,
			ga.idGrupoAdescoT as codigoGrupo,
			cast(ga.nombre as varchar(max))as nombre,
			ga.totalMora,
			ga.totalRenovacion,
			ga.totalVenceHoy,
			ga.totalPrioridad,
			ga.totalDesembolso,
			ga.totalVencimiento,
			ga.idGestor,
			ga.idEstado,
			ga.representante,
			ga.actualizado,
			ga.latitud,
			ga.longitud,
			cast(ga.domicilioReunion as varchar(max))as domicilioReunion,
			ga.imgReferencia,
			ga.pendienteReferencia,
			cast(ga.infoE as varchar(max)) infoE,
			cast(ga.emergentes as varchar(max)) emergentes
		from gruposAdesco ga where ga.idGrupoAdescoT is null 
		union
		select 
			ga.idGrupoAdesco,
			ga.idGrupoAdescoT as codigoGrupo,
			cast(ga.nombre as varchar(max))as nombre,
			ga.totalMora,
			ga.totalRenovacion,
			ga.totalVenceHoy,
			ga.totalPrioridad,
			ga.totalDesembolso,
			ga.totalVencimiento,
			p.idGestor,
			ga.idEstado,
			ga.representante,
			ga.actualizado,
			ga.latitud,
			ga.longitud,
			cast(ga.domicilioReunion as varchar(max))as domicilioReunion,
			ga.imgReferencia,
			ga.pendienteReferencia,
			cast(ga.infoE as varchar(max)) infoE,
			cast(ga.emergentes as varchar(max)) emergentes
		from gruposAdesco ga
		inner join (select idGrupoAdesco,idGestor,sum(iif(etapa=1,1,0)) as t from prospectos group by idGrupoAdesco,idGestor) p on p.idGrupoAdesco = ga.idGrupoAdesco and t>0
	)
