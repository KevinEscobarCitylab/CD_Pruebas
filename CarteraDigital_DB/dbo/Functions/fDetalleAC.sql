CREATE function [dbo].[fDetalleAC](@codigoAC varchar(10),@codigoD varchar(10))returns int
as begin
	return (select idDetalle from detalleActividades where idActividad = dbo.fActividad(@codigoAC) and codigo = @codigoD and estado = 1)
end
