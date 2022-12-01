	CREATE procedure [dbo].[api_prospectos](@data nvarchar(max),@rsp nvarchar(max) out)as
	begin
		--declare @data nvarchar(max) = '{"_action":"prospectos","fecha":"2020-09-28"}'
		--declare @rsp nvarchar(max)
		if(@data is not null and @data != '')begin
			declare @date date = (select top 1 fecha from openjson(@data)with(fecha date))

			declare @ps table(# int,idProspecto int)
			insert @ps
			select #=row_number() over(order by (select 1))-1, idProspecto
			from (
					select 
					idProspecto,
					MAX(fechaApr) as fechaApr
				from (
					select 
						p.idProspecto,
						fechaApr = ep.fecha
					from prospectos p
					inner join etapasProspecto ep on ep.idProspecto = p.idProspecto and ep.etapa in (5) 
					where p.etapa in(5)) as dt 
				group by idProspecto 	
			) as p
			where cast(fechaApr as date) = @date

			declare @totalP int=(select count(1) from @ps),@index2 int = 0
			while @index2 < @totalP begin
				declare	@idProspecto int = (select idProspecto from @ps where # = @index2)
				declare @dataR varchar(max)= (select respuestas from prospectos where idProspecto = @idProspecto)
				declare @dt table(# int,idFormulario int)
				insert @dt select #=row_number() over(order by (select 1))-1,* from openjson(@dataR)with(idFormulario int)
				declare @total int=(select count(1) from @dt),@index int = 0, @sp varchar(3) = ''''

				declare @respuestas table(idProspecto int,idPregunta int, respuesta nvarchar(max), idRespuesta int, codCatalogo nvarchar(max))
				while @index < @total begin
					declare @rw varchar(max)
					declare @sql nvarchar(max) = concat('set @rw =(select *from openjson(@d,',@sp,'$[',@index,'].respuestas',@sp,')with(idPregunta int,observacion varchar(max), idRespuesta int,idRespuestaT varchar(max)) for json path)')

					exec sp_executesql @sql,N'@d nvarchar(max),@rw nvarchar(max) out',@dataR,@rw out	
					insert @respuestas select @idProspecto,* from openjson(@rw)with(idPregunta int,observacion varchar(max), idRespuesta int,idRespuestaT varchar(max))
					set @index +=1
				end
				set @index2 +=1
			end

			set @rsp = (select data = coalesce((select 
				p.idProspecto,
				g.codigo,
				p.etapa,
				fechaCreacion = p.fecha,
				p.latitud,
				p.longitud,
				p.latitudNegocio,
				p.longitudNegocio,
				codGrupo = ga.idGrupoAdescoT,
				codCredito = c.referencia,
				monto =coalesce(p.monto,-1),
				nombreC = coalesce(p.nombreC,'--'),
				p.idEncuesta,
				Respuestas = (select 
					pr.idPregunta,
					pe.pregunta,
					coalesce(r.respuesta,pr.respuesta) as respuesta,
					pr.codCatalogo 
				from @respuestas pr
				inner join preguntas pe on pe.idPregunta = pr.idPregunta
				left join respuestas r on r.idRespuesta = pr.idRespuesta
				where pr.idProspecto = p.idProspecto for json path)
			from @ps as ps
			inner join prospectos p on p.idProspecto = ps.idProspecto
			left join gestores g on g.idGestor = p.idGestor
			left join gruposAdesco ga on ga.idGrupoAdesco = p.idGrupoAdesco
			left join creditos c on c.idCredito = p.idCredito
			for json path),'[]'))
		end
	end
