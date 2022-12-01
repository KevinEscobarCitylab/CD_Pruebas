	create   function [dbo].[fReport](@name varchar(max))returns varchar(max) as
	begin
		declare @valor bit = 0
		IF (select count(1) from openjson((select [rep] from parametros)) where [key]=@name) != 0  
		begin
			return(select [value] from openjson((select [rep] from parametros)) where [key]=@name)
		end
		return (@valor)
	end
