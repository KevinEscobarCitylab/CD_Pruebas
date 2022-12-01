CREATE function [dbo].[fNombre](@txt varchar(max))returns varchar(max)
as begin
	return concat('<div class="name">',@txt,'</div>')
end
