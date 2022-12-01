CREATE PROCEDURE [dbo].[EnvioPictor](@idProspecto int,@error int out,@message varchar(max) out) as 
begin
	if(object_id('tempdb..#pathsP') is not null)drop table #pathsP

	select pe.codigoCore as codigo,CONCAT('"',cast(pr.respuesta as varchar(500)),'"') as p
	into #pathsP from solicitudR(@idProspecto) pr
	inner join prospectos p on p.idProspecto = @idProspecto
	inner join preguntas pe on pe.idTablaCore = iif(p.idEncuesta = 1,1,2) and pe.idPregunta = pr.idPregunta

	update prospectos set pictor = (select (select 
		p.idProspecto,
		319 as idUsuario,
		cast(GETDATE() as date) as fecha,
		iif(p.idEncuesta = 1,328,327) as idTipodocumento,
		isNull(JSON_QUERY((select concat('["',p.nDoc,'","',p.lineaC,'"]'))),'[]')as palabrasClave,
		ISNULL((select codigo,JSON_QUERY(CONCAT('[',path1,']')) as paths
			from(select codigo, dbo.fStuff(rtrim((select concat(',',p) from #pathsP s where s.codigo = t.codigo for XML path('')))) as path1 from #pathsP t group by codigo) as dt for JSON PATH
		),'[]') as imagenes
	from prospectos p
	where p.idProspecto = @idProspecto for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES) as data) 
	where idProspecto = @idProspecto

	declare @json varchar(max) = (select action = 'envioImgSolidarioP',idProspecto = @idProspecto for json path, without_array_wrapper)
	declare @wUrl varchar(max) = dbo.fParameters('wUrl')+'consultaTercerosDB/'+dbo.b64(@json)
	declare @rsp varchar(max) = dbo.wsp(@wUrl,null)

	select @error = error,@message = message from openjson((@rsp))with(error int,message varchar(max))
end
