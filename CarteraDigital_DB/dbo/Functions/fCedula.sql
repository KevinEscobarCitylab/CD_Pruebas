CREATE FUNCTION [dbo].[fCedula](@cedula varchar(12), @extension varchar(5))
returns varchar(100)
as begin
	return (
		select concat(@cedula,@extension)
	)
end
