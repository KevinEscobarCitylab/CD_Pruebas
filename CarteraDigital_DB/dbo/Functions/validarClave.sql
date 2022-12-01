CREATE function validarClave(@usuario varchar(max),@clave varchar(max), @total int) returns int
begin
	declare @count  int = (select count(1) as t from (
			select top (@total) hc.clave 
			from historialClaves hc
			inner join usuarios u on u.idUsuario = hc.idUsuario
			where u.usuario = @usuario order by idHistorial desc	
		) as dt where clave = @clave)
	if(@count=0)return 1
	return 0
end