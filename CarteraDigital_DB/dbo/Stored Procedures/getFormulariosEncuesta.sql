CREATE PROCEDURE [dbo].[getFormulariosEncuesta](@idEncuesta int,@idProspecto int,@usuario int, @d varchar(max) output)as
begin
	if(object_id('tempdb..#db_form') is not null)drop table #db_form

	select * into #db_form from (
	select 
	    iif(ge._index is null,1000,ge._index) _index,
		iif(ge.idGrupoE is null,1000,ge.idGrupoE) idGrupoE,
	    iif(ge.nombre is null,'Otros',ge.nombre) as grupoFormulario,
		f.idEncuesta,
	    ROW_NUMBER() OVER(ORDER BY ge._index ASC) AS ID
	from formularios f 
	left join grupoEncuesta ge on ge.idGrupoE = f.idGrupoE
	inner join encuestas e on e.idEncuesta = f.idEncuesta
	where f.idEncuesta = @idEncuesta and f.estado = 1)dt order by dt._index

	if(object_id('tempdb..#db_respuestas') is not null)drop table #db_respuestas
	select * into #db_respuestas from (
	select
	    p.idFormulario,
	    p.idPregunta,
	    p.pregunta,			
		s.idRespuesta,
		s.idRespuestaT,
		s.idRM,
		s.respuesta	as observacion,
		s.observacion2,
		s.g,
		s.p,
		s.d1,
		s.idRS,
		s.IDT,
		s.[readOnly],
		dbo.getFormatR(p.idTipo,f.tipo,p.multiple) formatoR
	from preguntas p
	inner join formatos f on f.idFormato = p.idFormato
	inner join solicitudR2(@idProspecto) s on s.idPregunta = p.idPregunta
	inner join formularios fr on fr.idFormulario = p.idFormulario
	where p.estado = 1 and fr.idEncuesta = @idEncuesta and fr.estado = 1) as dt

	if(object_id('tempdb..#db_prospecto') is not null)drop table #db_prospecto
	select * into #db_prospecto from (
	select
		isnull(p.d1,'{}') as d1,p.eventos,isnull(p.d3,'[]') as d3,p.d4
	from prospectos p
	inner join encuestas e on p.idEncuesta = e.idEncuesta
	where p.idEncuesta = @idEncuesta and p.idProspecto = @idProspecto) as dt

	declare @idFM int = (select top 1 idFormulario from formularios where idEncuesta = @idEncuesta and estado = 1 order by _index )

	    set @d = (
		select (select
			fmains = isNull((select -1 as idGrupoE,-1 _index,json_query('[]') as form,
			f.idFormulario,
			f.idEncuesta,
			f.nombre as grupoFormulario,
			cast(isnull(s.observado,0) as bit) as isObserved,
			isnull(s.totalCampos,0) as cont
		from formularios f
		inner join getformulariosR(@idProspecto) s on s.idFormulario = f.idFormulario
		where f.idFormulario = @idFM for json path),'[]'),
		groups = (select 
				s._index,
				s.idGrupoE,
				s.grupoFormulario,
				form = isNull((
					select 
						f.idFormulario,
						nombre,
						json_query(d1) as d1,
						conf,
						_index,
						cast(isnull(fr.observado,0) as bit) as isObserved,
						isnull(fr.totalCampos,0) as cont
					from formularios f 
					left join getformulariosR(@idProspecto) fr on fr.idFormulario=f.idFormulario
					where f.idFormulario <> @idFM and (idGrupoE = s.idGrupoE or (s.idGrupoE = 1000 and idGrupoE is null and idEncuesta = s.idEncuesta)) and estado = 1
					order by _index for json path)
				,'[]')
			from #db_form s							
			group by s._index,s.idGrupoE,s.grupoFormulario,s.idEncuesta for json path),
		respuestas = isnull((select * from #db_respuestas for JSON PATH),'[]'),
		prospecto = (select * from #db_prospecto for JSON PATH)
		for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
	)
end
