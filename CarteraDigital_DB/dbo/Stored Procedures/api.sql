	create procedure [dbo].[api](@data nvarchar(max))as
	begin
		--declare @data nvarchar(max) = '{"_action":"prospectos"}'
		declare @rsp nvarchar(max)
		declare @p table(
			_action varchar(150)
		)
		insert @p select *from openjson(@data)with(_action varchar(max))
		declare @WS varchar(150) = (select top 1 _action from @p)

		if(@WS = 'prospectos')			exec api_prospectos @data,@rsp out
		else if(@WS = 'cobro')			exec api_cobro @data,@rsp out

		
		if(@rsp is null or @rsp = '')begin
			insert logs(stackTrace,contenido,fecha,data) values ('API',@WS,GETDATE(),@data)
		end
		select (select 
			error = iif(@rsp is null or @rsp = '',1,0), 
			message = iif(@rsp is null or @rsp = '','No encontrado','Existe'),
			rsp = json_query(iif(@rsp='' or @rsp is null,'[]',@rsp)),
			WS = @WS
		for json path, without_array_wrapper) as data
	end
