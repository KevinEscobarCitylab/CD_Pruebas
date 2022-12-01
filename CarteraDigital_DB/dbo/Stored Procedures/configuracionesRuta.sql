	CREATE procedure [dbo].[configuracionesRuta] as
	begin
		-- Agregando registros de ruta no cumplida ayer
		declare @acumularCR bit = coalesce(dbo.fParameters('acumularCreditosRuta'),'false')
		declare @acumularGR bit = coalesce(dbo.fParameters('acumularGruposRuta'),'false')

		delete from rutasAgendadas where fecha <= DATEADD(day, -7, cast(getdate() as date))

		-- Agregando creditos, prospectos a ruta agendada
		if(@acumularCR = 1) begin
		insert rutasAgendadas(fecha,idCredito,idActividad,idProspecto,idClienteCampania,idGestor)
			select
				ru.fecha,
				ru.idCredito,
				ru.idActividad,
				ru.idProspecto,
				ru.idClienteCampania,
				ru.idGestor
			from rutasAgendadas rag
			right outer join rutas ru on (ru.idCredito = rag.idCredito or rag.idProspecto = ru.idProspecto or rag.idClienteCampania = ru.idClienteCampania) and ru.fecha = rag.fecha
			where ru.fecha = DATEADD(day, -1, cast(getdate() as date)) and
			(ru.gestionado is null or ru.gestionado <> 1 )and rag.idRutaAgendada is null and ru.idActividad is null
		end

		-- Agregando grupos a ruta agendada
		if(@acumularGR = 1) begin
		insert rutasAgendadas(fecha,idGrupoAdesco,idGestor)
			select
				ru.fecha,
				ru.idGrupoAdesco,
				ru.idGestor
			from rutasAgendadas rag
			right outer join rutas ru on ru.idGrupoAdesco = rag.idGrupoAdesco and ru.fecha = rag.fecha
			where
			ru.fecha = DATEADD(day, -1, cast(getdate() as date)) and
			(ru.gestionado is null or ru.gestionado <> 1) and rag.idRutaAgendada is null and ru.idGrupoAdesco is not null
		end

		--insert rutasAgendadas por criterio
		--Criterios ruta
		declare @data nvarchar(max), @idCriterio int, @count int, @query nvarchar(max)

		set @idCriterio = (select top 1 idCriterio from criteriosRuta where idCriterio > 0 and estado = 1)
		set @count = 100
		--Reestableciendo criterios para asignación
		while(@idCriterio is not null and @count > 0)begin
			set @query = CONCAT(' set @data = (select idCredito,idGrupo from creditos where ',(select condicion from criteriosRuta where idCriterio = @idCriterio), ' for json path)')
			exec sp_executesql @query, N'@data nvarchar(max) out', @data out

			insert rutasAgendadas
			(fecha,idCredito,idGestor,estado)
			select
				getdate(),
				cr.idCredito,
				g.idGestor,
				1
			from rutasAgendadas t
			right outer join openjson(@data)
			with(
				idCredito int,
				idGrupo int
			) s on s.idCredito = t.idCredito and t.fecha = cast(getdate() as date)
			inner join creditos cr on cr.idCredito = s.idCredito
			inner join creditosAsignados ca on ca.idCredito = cr.idCredito
			inner join gestores g on g.idGestor = ca.idGestor
			where t.idRutaAgendada is null and ca.asignado = 1 --and s.idGrupo is null

			set @idCriterio = (select top 1 idCriterio from criteriosRuta where idCriterio > @idCriterio and estado = 1)
			set @count = @count -1
		end


		--Criterios ruta grupal
		--declare @data nvarchar(max)
		set @idCriterio = (select top 1 idCriterio from criteriosRutaGrupos where idCriterio > 0 and estado = 1)
		set @count = 100
		--Reestableciendo criterios para asignación
		while(@idCriterio is not null and @count > 0)begin
			set @query = CONCAT(' set @data = (select idGrupoAdesco from gruposAdesco where ',(select condicion from criteriosRutaGrupos where idCriterio = @idCriterio), ' for json path)')
			exec sp_executesql @query, N'@data nvarchar(max) out', @data out

			insert rutasAgendadas
			(fecha,idGrupoAdesco,idGestor,estado)
			select
				getdate(),
				ga.idGrupoAdesco,
				g.idGestor,
				1
			from rutasAgendadas t
			right outer join openjson(@data)
			with(
				idGrupoAdesco int
			) s on s.idGrupoAdesco = t.idGrupoAdesco and t.fecha = cast(getdate() as date)
			inner join gruposAdesco ga on ga.idGrupoAdesco = s.idGrupoAdesco
			inner join creditos cr on cr.idGrupo = ga.idGrupoAdesco
			inner join creditosAsignados ca on ca.idCredito = cr.idCredito
			inner join gestores g on g.idGestor = ca.idGestor
			where t.idRutaAgendada is null and ca.asignado = 1
			group by ga.idGrupoAdesco, g.idGestor

			set @idCriterio = (select top 1 idCriterio from criteriosRutaGrupos where idCriterio > @idCriterio and estado = 1)
			set @count = @count -1
		end
	end
