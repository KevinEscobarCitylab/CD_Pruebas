--function
	create   function [dbo].[fEstadoGrupo](@codigo varchar(10))returns int
	as begin
		if(@codigo='PRC')return 1
		else if(@codigo='ACT')return 2
		else if(@codigo='INC')return 3
		return (select idEstado from estadosGruposAdesco where codigo = @codigo )
	end
