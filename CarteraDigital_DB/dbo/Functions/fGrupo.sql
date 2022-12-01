create function fGrupo(@codigo varchar(10))returns int
as begin
	return (select idGrupo from grupos where codigo = @codigo )
end
