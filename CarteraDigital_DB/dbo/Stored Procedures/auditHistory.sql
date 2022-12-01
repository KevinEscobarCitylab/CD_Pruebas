CREATE procedure [dbo].[auditHistory](@descripcion varchar(max), @sessionId varchar(max),@origen varchar(max), @device varchar(max) )as
begin
	declare @idUsuario int = (select idUsuario from usuariosSistema where sessionid = @sessionId)
	if(@idUsuario is not null)insert into historialCambios(descripcion,idUsuario,fecha,origen,dispositivo)values(@descripcion,@idUsuario,getdate(),@origen,@device)
end