CREATE procedure [dbo].[gruposMenu] @idGrupo int, @idMenu int, @estado int as
begin 
	declare @parent int
	if @estado = -1  and @idGrupo = 1 begin
		delete from grupos_menu where idMenu = @idMenu
		delete from menu where idMenu = @idMenu
		select 0 as error,'Eliminado correctamente' as message
	end
	else if (select top 1 idMenu from grupos_menu where idGrupo  = @idGrupo and idMenu = @idMenu)=@idMenu begin
		set @parent = (select top 1 parent from menu where idMenu = @idMenu)
		--comprobando si el menú principal está actívo
		if @parent is not null and @estado = 1 update grupos_menu set estado = @estado where idGrupo = @idGrupo and idMenu = @parent
		--Comprobando desendientes si se deshabilita el contenedor
		else if ((select count(1) from menu where parent = @idMenu)>0)begin
			update gm
			set
				gm.estado = @estado
			from grupos_menu gm
			inner join menu m on m.idMenu = gm.idMenu
			where m.parent = @idMenu and gm.idGrupo = @idGrupo
		end
		--actualizando item solicitado
		update grupos_menu set estado = @estado where idGrupo = @idGrupo and idMenu = @idMenu
		select 0 as error, 'Actualizado correctamente' as message 
	end
	else begin
		set @parent = (select top 1 parent from menu where idMenu = @idMenu)
		if @parent is not null and @estado = 1 begin 
			if (select top 1 idMenu from grupos_menu where idMenu = @parent and idGrupo = @idGrupo) is null begin
				insert into grupos_menu(idGrupo, idMenu,estado) values(@idGrupo,@parent,1)
			end
		end
		else if (select top 1 estado from grupos_menu where idMenu = @parent and idGrupo = @idGrupo ) = 0 begin
			update grupos_menu set estado = 1 where idGrupo = @idGrupo and idMenu = @parent
		end
		insert into grupos_menu(idGrupo,idMenu,estado) values(@idGrupo, @idMenu, @estado)
		select 0 as error, 'Registrado correctamente' as message
	end
end
