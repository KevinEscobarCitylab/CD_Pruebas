CREATE FUNCTION [dbo].[RSPCompleted](@rsp nvarchar(max))returns nvarchar(max) as
begin
	return(
		select 
			idP = p.idPregunta,
			--fr.nombre as formulario,
			--p.pregunta,
			r = iif(p.idTipo = 1, iif(dbo.notEmpty(p.fx) is null and dbo.notEmpty(s.value) is not null, s.value,iif(p.fx is null,rtrim(s.value),format(cast(s.value as date),p.fx))), null),
			idR = iif(p.idTipo = 2 and f.tipo != 'datasource', s.value, null),
			idRT = iif(f.tipo = 'datasource', s.value, null),
			[readOnly] = iif(p.soloLecturaAC=1,1,0)
		from openjson(@rsp)s
		inner join preguntas p on p.codigoAC collate SQL_Latin1_General_CP1_CI_AS = s.[key] collate SQL_Latin1_General_CP1_CI_AS
		--inner join formularios fr on fr.idFormulario = p.idFormulario
		inner join formatos f on f.idFormato = p.idFormato
		where p.estado = 1 for json path
	)
end
