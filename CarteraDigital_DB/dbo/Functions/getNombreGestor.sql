CREATE FUNCTION [dbo].[getNombreGestor](@idGestor int)
returns varchar(150)
as begin
	return (
		select g.nombre
		from gestores g
		where g.idGestor =  @idGestor)
end
