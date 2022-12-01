	CREATE function [dbo].[getPermisoN](@idGrupo varchar(10),@idGestor varchar(10))returns int
	as begin

		declare @estado varchar(max) = (	select count(1) from gruposEtapaGestion geg
		inner join etapasGestionProspecto egp on egp.idEtapaG = geg.idEtapaG
		where idGrupo = @idGrupo and egp.etapa ='Nuevo' and geg.estado = 1)

		return iif(@estado > 0 and @idGestor is not null,1,0)
	end
