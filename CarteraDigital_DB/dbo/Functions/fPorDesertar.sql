create function fPorDesertar(@idCredito int,@idCriterio int,@porDesertar int,@fechaPorDesertar date)returns int
as begin
	if(@idCriterio is null and @porDesertar=1)return -1
	else if(@idCriterio is not null and @porDesertar=0)return -2
	else if(@idCriterio is not null and @porDesertar=1 and @fechaPorDesertar is null) return -3
	else if(@idCredito is not null and @porDesertar=1)return DATEDIFF(day,@fechaPorDesertar,GETDATE())
	return null
end
