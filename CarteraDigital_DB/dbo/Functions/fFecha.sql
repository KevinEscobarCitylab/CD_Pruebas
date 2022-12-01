CREATE function [dbo].[fFecha](@txt date)returns varchar(max) as
begin
    return concat('<div style="min-width:100px"><a style="display:none"><pre>',format(@txt,'yyyyMMdd'),'</pre></a>',format(@txt,'dd MMM yyyy','es-ES'),'</div>')
end
