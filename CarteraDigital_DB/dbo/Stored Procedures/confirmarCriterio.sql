create   procedure [dbo].[confirmarCriterio] @codigo varchar(5), @condicion text as 
begin
	declare @query varchar(max)

	if(@codigo = 'PRD')begin
			set @query = 'select count(1)as total from creditos creditos inner join clientes clientes on creditos.idCliente=clientes.idCliente '
			set @query = CONCAT(@query,'left join solicitudes solicitudes on solicitudes.idCliente=clientes.idCliente and solicitudes.estado=1 where ')
			set @query = CONCAT(@query,@condicion)
			execute(@query)
		end
		else if(@codigo = 'SEG')begin
			set @query = CONCAT('select count(1)as total from creditos inner join clientes on clientes.idCliente = creditos.idCliente inner join creditosAsignados ca on ca.idCredito=creditos.idCredito inner join gestores on gestores.idGestor = ca.idGestor where ',@condicion)
			execute(@query)
		end
		else if(@codigo = 'RNV')begin
			set @query = CONCAT('select count(1)as total from creditos creditos inner join clientes clientes on clientes.idCliente = creditos.idCliente where ',@condicion)
			execute(@query)
		end
		else if(@codigo = 'SLC') begin
			set @query = CONCAT('select count(1)as total from solicitudes solicitudes inner join clientes clientes on clientes.idCliente=solicitudes.idSolicitud where ',@condicion)
			execute(@query);		
		end
		else if(@codigo = 'ASG') begin
			set @query = CONCAT('select count(1)as total from gruposGestor_v gruposGestorCredito where ',@condicion)
			execute(@query);		
		end
		else if(@codigo = 'SGR') begin
		declare @table varchar(max) = (select iif(CHARINDEX('usuariosSistema',@condicion)>0,'usuariosSistema','usuarios') )
			set @query = CONCAT('select count(1)as total from ',@table,' where ',@condicion)
			execute(@query);		
		end
		else select -1 as total;
end
