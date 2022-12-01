create function [dbo].[fPorcentual](@valor1 float, @valor2 float)returns decimal(10,2)
as begin
	declare @total float =iif(@valor1 = 0 or @valor2 = 0, 0, (@valor2 / @valor1)*100)
	return iif(@total > 100,100,@total)
end