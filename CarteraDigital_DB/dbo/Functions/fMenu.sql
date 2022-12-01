	create function [dbo].[fMenu](@sid varchar(max), @key varchar(max), @idInforme int)returns int 
	begin
		declare @idMenu int = (select top 1 m.idMenu from usuariosSistema u
		inner join grupos_menu gm on gm.idGrupo = u.idGrupo
		inner join menu m on m.idMenu = gm.idMenu
		where sessionid = @sid and cast(url as varchar(max)) = @key and gm.estado = 1 and u.estado = 1)

		if(@idMenu is null)set @idMenu = (
			select  top 1 m.idMenu 
			from sesionesUsuario su 
			inner join usuarios u on u.idUsuario = su.idUsuario
			inner join gestores g on g.idGestor = u.idGestor 
			inner join grupos_menu gm on gm.idGrupo = u.idGrupo 
			inner join menu m on m.idMenu = gm.idMenu where su.token = @sid and cast(url as varchar(max)) = @key and gm.estado = 1 and g.estado = 1	
		)

		if(@idMenu is null)set @idMenu = (select top 1 idInforme from informes where d3 = 0 and idInForme = @idInforme)
		return @idMenu
	end
