    create procedure [dbo].[procesarNotificaciones](@text varchar(max))as
	begin
		declare @action varchar(max), @notificacion varchar(max), @idUsuarioR varchar(max), @idGrupo int, @error int = 400
		declare @message varchar(max)
		declare @index int = (select count(1) from notificaciones)
		select 
			@action = action,
			@notificacion = notificacion,
			@idGrupo = idGrupo,
			@idUsuarioR = idUsuarioR
		from openjson(@text)with(
			token varchar(max),
			action varchar(max)	'$.action2',
			idUsuarioR varchar(max),
			idGrupo varchar(max),
			notificacion nvarchar(max) as json
		)
		--estado 1 as no leido
		--estado 0 as leido
		if @action = 'obtener' begin
			declare @notificaciones nvarchar(max)
			
			select 
				@error = 0,
				@message = 'Notificaciones obtenidas correctamente'

			if @idGrupo is null begin
				select @idGrupo = idGrupo from usuarios where idUsuario = @idUsuarioR
				select @notificaciones = (select * from (
										select * from notificaciones where idUsuarioR = @idUsuarioR /*and estado = 1*/ union
										select * from notificaciones where idGrupo = @idGrupo --and estado = 1
									)s for json path)
			end
			else begin
				select @notificaciones = (select * from (									
										select * from notificaciones where idGrupo = @idGrupo --and estado = 1
									)s for json path)
			end
							 
		end
		if @action = 'crear' begin
			insert notificaciones
			(idNotificacion,idUsuarioR,message,url,estado,fecha,idGrupo)
			select  
				concat(coalesce(idUsuarioN,idGrupo),@index + 1),
				idUsuarioN,
				message,
				url,
				1,
				current_timestamp,
				idGrupo
			from openjson(@notificacion)with(
				idUsuarioN int,
				message varchar(max),
				url varchar(max),
				idGrupo int
			)
			select 
				@error = 0, 
				@message = 'Notificación creada correctamente'
		end
		if @action = 'leer' begin
			update t
			set 
				t.estado = 0
			from notificaciones t
			inner join openjson(@notificacion)with(
				idNotificacion int
			)s on s.idNotificacion = t.idNotificacion
			select @error = 0, @message =  'Notificación leída correctamente'
		end
		if @action = 'eliminar' begin
			delete t 
			from notificaciones t
			inner join openjson(@notificacion) with(
				idNotificacion int
			) s on s.idNotificacion = t.idNotificacion
			select @error = 0, @message =  'Notificación eliminada correctamente'
		end

		select (select 
			error = @error,
			message = @message,
			notificaciones = JSON_QUERY(@notificaciones)
		for json path, without_array_wrapper) as data
	end
