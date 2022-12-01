create function fReaccionAC(@codigo varchar(10))returns int
as begin
	return (select idReaccion from reacciones where idActividad = dbo.fActividad(@codigo))
end
