	create procedure [dbo].[buscarImagenesProspecto](@idProspecto int) as
	begin
		set nocount on
			declare @data nvarchar(max)  = (select respuestas from prospectos where idProspecto = @idProspecto)
			declare @dt table(# int identity(1,1),idFormulario int, respuestas nvarchar(max))
			declare @rsp table(nombre varchar(max), url varchar(max))
			insert @dt select *from openjson(@data)with(idFormulario int, respuestas nvarchar(max) as json)
			declare @index int = 1, @total int = (select COUNT(1) from @dt)

			while @index <= @total begin
				select
					@data = respuestas
				from @dt where # = @index

				insert @rsp
				select
					p.pregunta,
					s.observacion
				from openjson(@data)with(idPregunta int, observacion nvarchar(max)) s
				inner join preguntas p on p.idPregunta = s.idPregunta
				inner join formatos f on f.idFormato = p.idFormato
				where f.tipo in('img','file','b64f') and s.observacion is not null and s.observacion like '%/img_%'

				set @index +=1
			end

			select data = (select *from @rsp for json path)
		set nocount off
	end
