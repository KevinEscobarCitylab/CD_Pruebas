create function [dbo].[fDatetime](@txt datetime,@CI varchar(max) = null)returns varchar(max)
as begin
	declare @cultureInfo varchar(max) = coalesce(@ci,dbo.fParameters('cultureInfo'))
	declare @fecha varchar(max) = format(@txt,'MMM dd yyyy hh:mm:ss tt',@cultureInfo)
	set @fecha = concat(Upper(substring(@fecha,1,1)),substring(@fecha,2,len(@fecha)))
	return concat('<div style="min-width:100px"><a style="display:none">',format(@txt,'yyyyMMddHHmmss'),'</a>',@fecha,'</div>')
end
