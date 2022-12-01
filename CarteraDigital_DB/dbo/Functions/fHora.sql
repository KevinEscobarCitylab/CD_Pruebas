CREATE function [dbo].[fHora](@txt datetime)returns varchar(max) as
begin
    return concat('<div style="min-width:50px"><a style="display:none"><pre>',format(@txt,'yyyyMMddHHmm'),'</pre></a>',FORMAT(convert(time,@txt,108), N'hh\:mm'),'</div>')
end
