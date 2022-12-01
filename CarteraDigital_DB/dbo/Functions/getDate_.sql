CREATE FUNCTION [dbo].[getDate_](@format varchar(20))
returns varchar(150)
as begin
	return FORMAT (getdate(), @format)
end
