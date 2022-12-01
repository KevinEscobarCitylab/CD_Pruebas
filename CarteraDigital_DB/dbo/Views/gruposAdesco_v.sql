	create view [dbo].[gruposAdesco_v] as
	(
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
			s.idGestor,
			ga.idEstado,
			ga.representante,
			ga.actualizado,
			ga.latitud,
			ga.longitud,
			cast(ga.domicilioReunion as varchar(max))as domicilioReunion,
			ga.imgReferencia,
			ga.pendienteReferencia,
			cast(ga.infoE as varchar(max)) infoE,
			cast(ga.emergentes as varchar(max)) emergentes,
			cast(ga.table_ext as varchar(max)) table_ext,
			ga.gestionado
		from(
			select
				ga.idGrupoAdesco,
				ca.idGestor
			from creditosAsignados ca
			inner join creditos cr on cr.idCredito =  ca.idCredito
			inner join gruposAdesco ga on ga.idGrupoAdesco = cr.idGrupo
			inner join estadosCredito ec on ec.idEstado =  cr.idEstado
			where ca.asignado = 1 and ec.codigo != 'CAN' group by ga.idGrupoAdesco, ca.idGestor
		)s
		inner join gruposAdesco ga on ga.idGrupoAdesco = s.idGrupoAdesco
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
			cast(ga.emergentes as varchar(max)) emergentes,
			cast(ga.table_ext as varchar(max)) table_ext,
			ga.gestionado
		from gruposAdesco ga where ga.idGrupoAdescoT is null and ga.idEstado in(1,2)
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
			cast(ga.emergentes as varchar(max)) emergentes,
			cast(ga.table_ext as varchar(max)) table_ext,
			ga.gestionado
		from gruposAdesco ga
		inner join (select idGrupoAdesco,idGestor,sum(iif(etapa=1,1,0)) as t from prospectos group by idGrupoAdesco,idGestor) p on p.idGrupoAdesco = ga.idGrupoAdesco and t>0
		where ga.idEstado in(1,2)
	)
