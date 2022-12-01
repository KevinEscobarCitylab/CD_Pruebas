	create function [dbo].[fMetaPorcentual](@total float,@meta float,@inverso int)returns decimal(20,2)
	as begin

		if(@meta = 0 or @total = 0)return 0
		else if(@inverso = 1)return (1 - (@total - @meta)/@total)*100
		else return (@total * 100)/@meta
		return null
	end
