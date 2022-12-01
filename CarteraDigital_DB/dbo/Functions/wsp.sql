create FUNCTION [dbo].[wsp](@url varchar(max), @sid nvarchar(max))returns nvarchar(MAX)AS
BEGIN
	DECLARE @obj	INT;
	DECLARE @hr		INT;
	DECLARE @msg	VARCHAR(max);	
	DECLARE @json	NVARCHAR(4000);	--Cannot use MAX with CLR stored procedures

	if(@url is not null and @url != '')begin
		if((select case when @url like '%http%' then 1	else 0 end)=0)begin
			declare @wUrl varchar(max) = dbo.fParameters('wUrl')
			if(@wUrl is not null and @wUrl != '')set @url = @wUrl + @url
		end
	end

	exec @hr = sp_OACreate 'WinHttp.WinHttpRequest.5.1', @obj out 
	if (@hr <> 0) begin set @Msg = 'No se puede crear el objeto de conexión' goto error end

	exec @hr = sp_OAMethod @obj, 'Open', NULL, 'POST', @Url, false  
	if (@hr <> 0) begin set @msg = 'Imposible abrir conexión' goto error end

	exec @hr = sp_OAMethod @obj, 'SetRequestHeader', NULL, 'Content-Type', 'multipart/form-data; charset=utf-8'
	if (@hr <> 0) begin set @msg = 'No pudo crear encabezado' goto error end
	
	exec @hr = sp_OAMethod @obj, send, NULL, @sid--parameters
	if (@hr <> 0) begin set @msg = 'No se pudo enviar información al servidor' goto error end

	exec @hr = sp_OAGetProperty @Obj, 'ResponseText', @json output
	if (@hr <> 0) exec sp_OAGetErrorInfo @Obj
		
	exec @hr = sp_OADestroy @obj

	return @json

	error:exec @hr = sp_OADestroy @obj

	return @msg
END

