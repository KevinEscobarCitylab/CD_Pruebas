	CREATE function [dbo].[getAsignarProspectos](@idGestor varchar(10))returns int
	as begin	

		declare @prospectosGestor int
		select 
			@prospectosGestor = count(1) 	
		from gestores g
		inner join usuarios u on u.idGestor = g.idGestor
		inner join prospectos p on p.idUsuarioR = u.idUsuario
		where g.idGestor = @idGestor

		return iif(@prospectosGestor < dbo.fParameters('cantidadProspectos'),1,0)
	end
