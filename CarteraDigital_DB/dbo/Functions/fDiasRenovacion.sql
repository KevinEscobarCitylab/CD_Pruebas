create function fDiasRenovacion(@fechaOtorgamiento date,@fechaVencimiento date)returns int
as begin
	declare @f1 float = datediff(day,@fechaOtorgamiento,getDate())
	declare @f2 float = datediff(day,@fechaOtorgamiento,@fechaVencimiento)
	return coalesce((@f1/@f2) * 100,0)
end
