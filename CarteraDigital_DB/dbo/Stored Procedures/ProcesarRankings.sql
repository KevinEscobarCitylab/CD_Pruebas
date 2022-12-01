	create procedure ProcesarRankings as
	begin
		if(object_id('tempdb..#rankings') is not null)drop table #rankings
		select row_number() over(order by idRanking) as ID, * into #rankings from rankings where d1 is not null and estado = 1

		declare @cRankings int, @_index int = 1, @query nvarchar(max), @idRanking int, @niveles varchar(max), @ranking int
		select @cRankings = count(1) from #rankings

		delete from rankingsGestor
		while @_index <= @cRankings
		begin
			select @idRanking = idRanking, @query = dbo.decodeb64(d1) from #rankings where ID = @_index
	
			insert rankingsGestor
			(idRanking,idAgencia,idGestor,rankingAgencia,ranking)
			exec sp_executesql @query,N'@idRanking int', @idRanking
	
			set @_index += 1
		end

		if(object_id('tempdb..#TMPCantGestoresA') is not null)drop table #TMPCantGestoresA

		select count(1) as cantidad,idGrupo, idAgencia into #TMPCantGestoresA from gestores where estado = 1 group by idGrupo,idAgencia

		if(object_id('tempdb..#TMPCantGestores') is not null)drop table #TMPCantGestores
		select sum(cantidad) cantidad,IdGrupo into #TMPCantGestores from #TMPCantGestoresA group by IdGrupo

		if(object_id('tempdb..#totalCreditosGestor') is not null)drop table #totalCreditosGestor
		select g.idGestor,cr.idAgencia,count(1) totalCreditos 
		into #totalCreditosGestor
		from gestores g 
		inner join creditosAsignados ca on ca.idGestor = g.idGestor and asignado = 1
		inner join creditos cr on cr.idCredito = ca.idCredito 
		group by cr.idAgencia,g.idGestor

		--Actualizo los detalles de los niveles por color 

		--Para globales top->
			UPDATE rg SET
				rg.tituloRanking = s.descripcion,
				rg.iconoRanking = s.icono,
				rg.colorEmpresa = s.colorNivel
			from rankingsGestor rg 
			inner join gestores g on g.idGestor = rg.idGestor	
			inner join #TMPCantGestores dscg on dscg.IdGrupo = g.idGrupo
			inner join rankings r on r.idRanking = rg.idRanking
			cross apply openjson(r.niveles)with(
				descripcion varchar(max),
				valorI decimal(5,2),
				valorF decimal(5,2),
				tipo int,
				[top] int,
				icono int,
				colorNivel varchar(max)) s 
			where 
				s.tipo = 1 and
				(s.[top]=1 and rg.ranking between valorI and valorF) OR --Si el tipo es valor fijo y el valor es igual al valor del ranking entonces es valido.
				(s.[top] != 1 and (dscg.cantidad - rg.ranking) between valorI and valorF)

		--Actualizo para globales %:
			UPDATE rg SET
				rg.tituloRanking = s.descripcion,
				rg.iconoRanking = s.icono,
				rg.colorEmpresa = s.colorNivel
			from rankingsGestor rg 
			inner join gestores g on g.idGestor = rg.idGestor
			inner join #TMPCantGestores dscg on dscg.IdGrupo = g.idGrupo
			inner join rankings r on r.idRanking = rg.idRanking
			cross apply openjson(r.niveles)with(
				descripcion varchar(max),
				valorI decimal(5,2),
				valorF decimal(5,2),
				tipo int,
				[top] int,
				icono int,
				colorNivel varchar(max)) s 
			where rg.colorEmpresa is null and
					(s.tipo = 2 and ranking * 100.00 / dscg.cantidad between valorI and valorF)

		-- Actualizo ind. agencia para tops fijos ->
			UPDATE rg SET
				rg.ColorAgencia=s.colorNivel
			from rankingsGestor rg
			inner join gestores g on g.idGestor = rg.idGestor
			inner join #TMPCantGestoresA dscg on dscg.IdGrupo = g.idGrupo and dscg.IdAgencia = rg.idAgencia
			inner join rankings r on r.idRanking = rg.idRanking
			cross apply openjson(r.niveles) with(
				descripcion varchar(max),
				valorI decimal(5,2),
				valorF decimal(5,2),
				tipo int,
				[top] int,
				icono int,
				colorNivel varchar(max)
			) s 
			where
				s.tipo = 1 and
				(s.[top]=1 and rg.rankingAgencia between valorI and valorF) OR
				(s.[top] != 1 and (dscg.Cantidad - rg.rankingAgencia) between valorI and valorF)  -- Si el tipo es 1 y el top es mayor que 1 entonces el valor debe ser mayor que el ranking menor o igual.

		--Actualizo ind. agencia para porcentajes:
			UPDATE rg SET
				rg.colorAgencia=s.colorNivel
			from rankingsGestor rg
			inner join gestores g on g.idGestor = rg.idGestor and estado = 1
			inner join #TMPCantGestoresA dscg on dscg.IdGrupo = g.idGrupo and dscg.IdAgencia = rg.idAgencia
			inner join rankings r on r.idRanking = rg.idRanking
			cross apply openjson(r.niveles) with(
				descripcion varchar(max),
				valorI decimal(5,2),
				valorF decimal(5,2),
				tipo int,
				[top] int,
				icono int,
				colorNivel varchar(max)) s 
			where 
				rg.ColorAgencia is null  and (s.tipo = 2 and rankingAgencia * 100.00 / dscg.Cantidad between valorI and valorF) -- Si el tipo es porcentaje entonces del ranking saco el porcentaje y lo comparo entre los valores PI y PF de mis niveles y excluyo cuando el ranking sea 1 por el nivel Lider.

		update g1
		set clasificacion = 
			(select
					rankings = (select 
					rg.idRanking,
					r.titulo,
					r.descripcion as Descripcion,
					rg.rankingAgencia as posAgencia,
					rg.ranking as posEmpresa,
					rg.idAgencia,
					rg.tituloRanking as tituloRanking,
					rg.iconoRanking,
					rg.colorEmpresa,
					rg.colorAgencia,
					totalAgencia = dscga.Cantidad,
					totalEmpresa = dscg.cantidad
				from rankingsGestor rg
				inner join gestores g on g.idGestor = rg.idGestor		
				inner join rankings r on r.idRanking = rg.idRanking
				inner join #TMPCantGestoresA dscga on dscga.IdGrupo = g.idGrupo and dscga.IdAgencia = rg.idAgencia
				inner join #TMPCantGestores dscg on dscg.IdGrupo = g.idGrupo
				where rg.idGestor = g1.idGestor  for json path),
				agencias = (
					select a.idAgencia, rtrim(ltrim(a.agencia)) agencia, concat(dbo.stdName(a.agencia),' (',tcg.totalCreditos,')' ) as nombreCatalogo
					from agencias a
					inner join rankingsGestor rg on rg.idAgencia = a.idAgencia 
					inner join #totalCreditosGestor tcg on tcg.idGestor = rg.idGestor and tcg.idAgencia = rg.idAgencia
					where rg.idGestor = g1.idGestor group by a.idAgencia, a.agencia, tcg.totalCreditos order by tcg.totalCreditos desc for json path
				)for json path,without_array_wrapper
			)	
		from gestores g1 
		inner join agencias a on a.idAgencia = g1.idAgencia
		where g1.estado = 1

		DROP TABLE #TMPCantGestoresA
		DROP TABLE #TMPCantGestores
		drop table #totalCreditosGestor
		drop table #rankings
	end
