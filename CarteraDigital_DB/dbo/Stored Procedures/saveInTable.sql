CREATE PROCEDURE [dbo].[saveInTable](@req nvarchar(max), @rsp nvarchar(max))as
begin
	insert logs (message, stackTrace, contenido, fecha,data)
	values ('saveInTable',@req,'js',GETDATE(),@rsp)
	if(object_id('tempdb..#ds')is not null)drop table #ds	

	select idGestor = json_value(@req,'$.idGestor'), token = json_value(@req,'$.token'), data = @rsp into #ds

	insert APIResponse
	(idGestor,token,data)
	select 
		s.idGestor,s.token,s.data
	from APIResponse t with(nolock)
	right join #ds s on s.idGestor = t.idGestor and s.token = t.token
	where t.idGestor is null and s.idGestor is not null and s.token is not null

	if(SCOPE_IDENTITY() is null)begin
		update t 
		set 
			data = s.data 
		from APIResponse t with(nolock) 
		inner join #ds s on s.idGestor = t.idGestor and s.token = t.token 
		where s.idGestor is not null and s.token is not null
	end
		
	select (select error = 0,message = 'OK', idGestor, token from #ds for json path, without_array_wrapper)as data
end
