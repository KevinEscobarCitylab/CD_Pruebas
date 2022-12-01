CREATE FUNCTION [dbo].[fEtapa](@idProspecto int) returns int
begin
declare @countFWeb bit = coalesce(dbo.fParameters('countFWeb'),0)
	return(
		select etapa = iif((
			select count(1) from (
				select 
					f.idFormulario,
					completado = iif(s.idFormulario is not null,1,0),
					no_aplica = coalesce(iif(f.d1 is not null,(
						select 
							sum(iif(d.[value] is null or r.[value] != d.[value],1,0))
						from openjson(f.d1,'$.references')with(d1 varchar(50),[value] varchar(50)) r
						left join openjson(p.d1) d on d.[key] = r.d1
					),0),0)
				from formularios f
				left join(select idFormulario from openjson((select respuestas from prospectos with(nolock) where idProspecto = @idProspecto))with(idFormulario int) group by idFormulario)s on s.idFormulario = f.idFormulario
				inner join prospectos p with(nolock) on p.idProspecto = @idProspecto and p.idEncuesta = f.idEncuesta
				where f.estado = 1 and coalesce(f.web,0) = 0 or (@countFWeb =1 and coalesce(f.web,0) = 1)
			)ds where completado = 0 and no_aplica = 0 
		)>0,1,2)
	)
end
