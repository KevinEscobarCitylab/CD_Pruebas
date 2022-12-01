CREATE FUNCTION [dbo].[fTrue](@true int)
returns varchar(10)
as begin
	return(
		select iif(@true = 1, 'true', 'false')
	)
end
