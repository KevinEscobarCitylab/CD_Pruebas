	CREATE function [dbo].[getIdUsuarioByToken](@sid varchar(max))returns int
	as begin
		declare @idUsuario int = (select top 1 u.idUsuario from usuarios u
				left join sesionesUsuario su on u.idUsuario = su.idUsuario			
				where su.token = @sid)

		if @idUsuario is null select @idUsuario = idUsuario from usuariosSistema where sessionid = @sid
		
		return @idUsuario
	end
