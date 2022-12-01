	create   function [dbo].[fCumplimiento](@a decimal(20,2), @b decimal(20,2))returns decimal(20,2)
	as begin
		if(@a > 0)
		begin
			return cast(round(convert(decimal, (@b*100)) / @a,2) as float (3))
		end
		else
		begin
			return 0.0
		end
		return 0.0
	end
