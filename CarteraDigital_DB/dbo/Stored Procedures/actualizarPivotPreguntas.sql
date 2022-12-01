create procedure [dbo].[actualizarPivotPreguntas] as
begin
	if(object_id('tempdb..#ds') is not null)drop table #ds
	select 
		p.idPregunta,
		cast(p.pregunta as varchar(max)) as pregunta,
		null as _pivot
	into #ds from preguntas p
	where p.estado = 1

	if(col_length('preguntas', '_pivot') is null)alter table preguntas add _pivot varchar(50)
	update t
	set 
		t._pivot = replace(IIF(LEN(s.pregunta)<36,s.pregunta,concat(substring(s.pregunta,0,35),'...')),' ','_')
	from preguntas t
	inner join #ds s on s.idPregunta = t.idPregunta
	where t._pivot is null
end


