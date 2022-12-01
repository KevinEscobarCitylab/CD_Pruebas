	create procedure [dbo].[establecerProspectoC](@idGrupo int = null) as
	begin
		set nocount on
			update creditos set d1 = null where d1 is not null and renovacion = 0 and idProspecto is not null

			declare @_index int=1, @idEncuesta int, @idProspecto int,@data nvarchar(max), @idCredito int
			declare @_dt table(# int identity(1,1),idProspecto int, idEncuesta int, idCredito int)
			insert @_dt select p.idProspecto,p.idEncuesta,cr.idCredito from creditos cr inner join prospectos p on p.idProspecto = cr.idProspecto where cr.d1 is null and cr.renovacion = 1 and (cr.idGrupo = @idGrupo or @idGrupo is null)
			declare @_total int = (select count(1) from @_dt)

			while @_index <= @_total begin
				select
					@idEncuesta = idEncuesta,
					@idProspecto = idProspecto,
					@idCredito = idCredito,
					@data = (select respuestas from prospectos where idProspecto = t.idProspecto)
				from @_dt t where # = @_index

				declare @dt table(# int,idFormulario int, fechaCreacion datetime, respuestas nvarchar(max))
				insert @dt select row_number() over(order by (select 1)),*from openjson(@data)with(idFormulario int, fechaCreacion datetime, respuestas nvarchar(max) as json)
				declare @index int = 1, @total int = (select count(1) from @dt),@fecha datetime = null,@idFormulario int = null
				declare @rsp table(idPreguntaR int identity(1,1), idPregunta int,idRespuesta int,idRespuestaT varchar(max),observacion varchar(max),idFormulario int)

				while @index <= @total begin
					select
						@idFormulario = idFormulario,
						@fecha = fechaCreacion,
						@data = respuestas
					from @dt where # = @index

					insert @rsp select dt.*,@idFormulario from openjson(@data)with(idPregunta int,idRespuesta int,idRespuestaT varchar(max),observacion varchar(max)) as dt
					inner join preguntas p on p.idPregunta = dt.idPregunta
					inner join formatos fo on fo.idFormato = p.idFormato
					where fo.tipo not in ('img','file','b64f','list','autocomplete')

					set @index +=1
				end

				print concat('#: ',@_index,', idProspecto: ',@idProspecto,', idCredito: ',@idCredito)

				declare @d1 nvarchar(max) =(
					select 
						idProspecto,
						idEncuesta,
						respuestas = (select *from @rsp for json path)
					from prospectos where idProspecto = @idProspecto
				for json path,without_array_wrapper)

				update creditos set d1 = @d1 where idCredito = @idCredito
				
				delete @dt
				delete @rsp
				
				set @_index += 1
			end
		set nocount off
	end
