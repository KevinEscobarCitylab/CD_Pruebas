create function fActividad(@codigo varchar(10))returns int
as begin
	return (select idActividad from actividades where codigo = @codigo)
end
