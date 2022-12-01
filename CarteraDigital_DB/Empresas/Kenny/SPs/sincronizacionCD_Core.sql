CREATE   procedure [dbo].[sincronizacionCD_Core](@idProspecto int) as
begin
	if(object_id('tempdb..#ds') is not null)drop table #ds

	select 
		pregunta,
		case idFormato 
			when 4 then format(try_parse(respuesta as date using 'es-SV'),'yyyy-MM-dd')
			else respuesta
		end as respuesta,
		idTablaCore,
		codigoCore
	into #ds from(
		select 
			p.idPregunta,
			cast(p.pregunta as varchar(max)) as pregunta,
			f._index as formulario,
			p.idTablaCore,
			p.codigoCore,
			rtrim(cast(coalesce((iif(p.idFormato=13,pr.idRespuestaT,pr.observacion)),coalesce(r.ID,r.respuesta))as varchar(max)))as respuesta,
			p.idFormato,
			p._index as indexP
		from preguntasRespondidas pr
		left join respuestas r on r.idRespuesta = pr.idRespuesta
		inner join preguntas p on p.idPregunta = pr.idPregunta
		inner join encuestasRespondidas er on er.idEncuestaR = pr.idEncuestaR
		inner join prospectos pp on pp.idProspecto = er.idProspecto
		inner join gestores  g on g.idGestor = pp.idGestor
		inner join formularios f on f.idFormulario = p.idFormulario
		where p.idEncuesta = 1 and p.estado = 1 and codigoCore is not null and p. idTablaCore = 1 and pp.idProspecto = @idProspecto
	) as ds
	order by formulario,indexP
	select *from #ds

	declare @conocidopor varchar(max) = (select concat(cpriape,' ',csegape,' ',cprinombre,' ',csegnombre) from(select respuesta,codigoCore from #ds where codigoCore in('cpriape','csegape','cprinombre','csegnombre'))as ds pivot(max(respuesta) for codigoCore in(cpriape,csegape,cprinombre,csegnombre))piv)

	insert into #ds(pregunta,respuesta,idTablaCore,codigoCore) values
	('Código de cliente',cast(@idProspecto as varchar(max)),1,'ccodcli'),
	('ID Prospecto CD',cast(@idProspecto as varchar(max)),1,'idProspecto'),
	('Conocido por',@conocidopor,1,'conocidopor'),
	('Nombre según NIT',@conocidopor,1,'cnomnit')

	select *from #ds

	--declare dt cursor for select idTabla,nombre from tablasCore
	--open dt
	--declare @idTabla int, @tabla varchar(max)
	--fetch next from dt into @idtabla,@tabla

	--while @@fetch_status = 0   
	--begin 
	--	declare @total int = (select count(1) from #ds where idTablaCore = @idTabla)
	--	if(@total > 0)begin
	--		declare @sql nvarchar(max) = (
	--			select concat(concat('if((select idProspecto from simnet.amc_cd.dbo.',@tabla,' where idProspecto=',@idProspecto,') is null)insert into simnet.amc_cd.dbo.',@tabla,'(',dbo.fStuff((select  concat(',',codigoCore) from #ds where idTablaCore = @idTabla for xml path(''))),') values '),concat('(',dbo.fStuff((select  concat(',''',respuesta,'''') from #ds  where idTablaCore = @idTabla for xml path(''))),')'))
	--		)
	--		exec sp_executesql @sql
	--	end
	--	fetch next from dt into @idtabla,@tabla
	--end 
	--close dt
	--deallocate dt	
	--select 0 as error, 'Hecho' as message
end
