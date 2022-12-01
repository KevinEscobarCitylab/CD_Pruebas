CREATE FUNCTION [dbo].[fToUpper](@string varchar(max))
returns varchar(max)
as begin
	return (select upper(@string))
end
