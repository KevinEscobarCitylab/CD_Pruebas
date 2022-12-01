CREATE PROCEDURE [dbo].[APIResponseManager](@req nvarchar(max), @rsp nvarchar(max) out)as
begin
	insert logs (message, stackTrace, contenido, fecha,data)
	values ('APIrespomeseManager',@rsp,'js',GETDATE(),@req)

	declare @idGestor int,@token varchar(50),@error int
	declare @_rsp nvarchar(max) = dbo.wsp('ConsultaTerceros',@req)

	select
		@idGestor = idGestor,
		@token = token,
		@error = error
	from openjson(@_rsp)with(idGestor int, token varchar(50),error int)
	
	if(@error > 0)set @rsp = @_rsp 
	else select top 1 @rsp = data from APIResponse with(nolock) where idGestor = @idGestor and token = @token

	delete from APIResponse where idGestor = @idGestor and token = @token
end
