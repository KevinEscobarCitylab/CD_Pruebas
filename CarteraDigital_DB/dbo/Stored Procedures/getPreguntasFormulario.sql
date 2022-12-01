CREATE PROCEDURE [dbo].[getPreguntasFormulario](@idEnc int, @idFormulario int, @sessionid varchar(max)= null, @d varchar(max) output)as
begin
	declare @idUsuario int = (dbo.getIdUsuarioByToken(@sessionid))

	if (@idUsuario is not null or @sessionid is null) begin
		declare @source varchar(max)
		exec getSourcePreguntas @idEnc,@idFormulario,null,0, @source output

		declare @sourceI varchar(max)
		exec getSourcePreguntas @idEnc,@idFormulario,null,1, @sourceI output

		set @d = (
		select (
		select
			preguntas = json_query(@source),
			preguntasI = json_query(@sourceI)
			for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data)
	end	
	else begin 
		set @d =(select (select 403 as error,'Acceso Denegado' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data)
	end
end
