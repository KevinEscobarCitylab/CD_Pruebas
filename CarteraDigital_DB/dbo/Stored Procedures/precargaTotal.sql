	CREATE PROCEDURE [dbo].[precargaTotal] as
	begin
		exec precargaParcial

		declare @dt table(ID int identity(1,1), idUsuario int,total int, [data] nvarchar(max))

		insert @dt 
		(idUsuario,total)
		select 
			idUsuario,
			total = count(1)
		from usuarios u
		inner join gestores g on g.idGestor =  u.idGestor
		where g.estado = 1
		group by u.idUsuario

		declare @total int = (select max(ID) from @dt),@index int = 1

		while @index <= @total begin
			declare @idUsuario int,@totalLogin int
			select 
				@idUsuario = idUsuario
			from @dt where ID = @index
			print(concat('idUsuario:',@idUsuario))
			set nocount on
			declare @rsp nvarchar(max) = ''
			exec inicioSesion @idUsuario,null,null,@rsp out
			update usuarios set data = @rsp, totalLogin = 0 where idUsuario = @idUsuario
			set @index += 1
		end

		select 'Datos procesados correctamente' as inf
	
		set nocount off
	end
