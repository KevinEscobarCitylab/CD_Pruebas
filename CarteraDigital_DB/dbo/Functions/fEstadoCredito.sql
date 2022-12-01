CREATE function fEstadoCredito(@codigo varchar(10))returns int
as begin
	if(@codigo='VIG')return 1
	else if(@codigo='CAN')return 2
	else if(@codigo='SAN')return 3
	return (select idEstado from estadosCredito where codigo = @codigo )
end