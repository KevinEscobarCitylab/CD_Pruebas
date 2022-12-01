CREATE FUNCTION [dbo].[fToLower](@string varchar(max))
returns varchar(max)
as begin
	return (select lower(@string))
end
