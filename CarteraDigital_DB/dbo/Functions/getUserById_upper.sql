CREATE FUNCTION [dbo].[getUserById_upper](@idGestor int)
returns varchar(150)
as begin
	return (select upper(usuario) from usuarios where idGestor = @idGestor)
end
