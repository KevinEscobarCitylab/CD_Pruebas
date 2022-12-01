    create function [dbo].[fPositionJson](@cadena varchar(max), @pregunta int)returns varchar(max)
	as begin
		DECLARE @gdatos table( 
			Id          int identity(1,1) primary key clustered,
			posicion	int,
			respuestas	varchar(max)
		); 

		insert into @gdatos (posicion,respuestas)
		select [key],[value] from openjson(@cadena)

		return (select JSON_VALUE(respuestas,'$.observacion') from @gdatos where JSON_VALUE(respuestas,'$.idPregunta') = @pregunta)
	end
