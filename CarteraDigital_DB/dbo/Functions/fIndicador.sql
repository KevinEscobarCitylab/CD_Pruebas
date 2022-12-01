create function fIndicador(@idGestor int,@idIndicador int,@valor int)returns int
as begin
	declare @valorA decimal(10,2)
	declare @valorM decimal(10,2)
	declare @min int
	select @min = iif(valorA<valorM,1,0),@valorA = valorA,@valorM = valorM from indicadores where idIndicador = @idIndicador

	if(@min = 1)begin
		if(@valor<= @valorA)return 1
		else if(@valor<=@valorM)return 2
		else return 3
	end
	else begin
		if(@valor >= @valorA)return 1
		else if(@valor >= @valorM)return 2
		else return 3
	end
	return 3
end
