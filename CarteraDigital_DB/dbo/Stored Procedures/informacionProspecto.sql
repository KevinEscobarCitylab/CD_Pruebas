create procedure [dbo].[informacionProspecto] (@idEncuesta int, @idProspecto int) as
begin
	if(object_id('tempdb..#dp') is not null)drop table #dp

	select 
		concat(p._pivot,'_',p.idPregunta) as pregunta,
		cast(coalesce(r.respuesta,pr.respuesta,'--') as varchar(max)) as respuesta
	into #dp from solicitudR(@idProspecto) pr
	inner join preguntas p on p.idPregunta = pr.idPregunta
	left join respuestas r on r.idRespuesta = pr.idRespuesta

	declare @agencia varchar(max),@gestor varchar(max)
	select top 1 @agencia=a.agencia, @gestor=g.nombre from prospectos p inner join gestores g on g.idGestor = p.idGestor inner join agencias a on a.idAgencia = g.idAgencia where p.idProspecto = @idProspecto
	insert into #dp(pregunta,respuesta)values
	('Gestor',@gestor),
	('Agencia',@agencia)

	declare @pivot varchar(max) = dbo.fStuff((select concat(',','[',pregunta,']') from #dp for xml path('')))
	declare @sql nvarchar(max) = (select concat('select *from(select pregunta,respuesta from #dp)dt pivot(max(respuesta) for pregunta in(',@pivot,'))piv'))

	exec sp_executesql @sql
end
