CREATE FUNCTION [dbo].[getUserById](@idGestor int)
returns varchar(150)
as begin
	return (select usuario from usuarios where idGestor = @idGestor)
end
