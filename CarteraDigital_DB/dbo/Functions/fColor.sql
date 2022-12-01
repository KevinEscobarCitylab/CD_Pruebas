	create   function [dbo].[fColor](@valor1 varchar(max),@valor2 varchar(max),@valor3 varchar(max))returns varchar(max) as
	begin
		declare @color varchar(max)
		set @color = concat('#',convert(varchar(8),convert(varbinary(1), cast(round(((100 - 255 -1) * (cast((concat('0.',cast((abs(cast(@valor1 as binary(6)) %100000) + 1) as varchar(max))))as float)) + 255), 0) as int)),2),convert(varchar(8),convert(varbinary(1), cast(round(((1 - 255 -1) * (cast((concat('0.',cast((abs(cast(@valor2 as binary(6)) %100000) + 1) as varchar(max))))as float)) + 255), 0) as int)),2),convert(varchar(8),convert(varbinary(1), cast(round(((1 - 255 -1) * (cast((concat('0.',cast((abs(cast(@valor3 as binary(6)) %100000) + 1) as varchar(max))))as float)) + 255), 0) as int)),2))
		return @color
	end
