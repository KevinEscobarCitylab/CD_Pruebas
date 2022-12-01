create procedure [dbo].[procesarCampaña](@cierre bit = 0) as
begin
	set nocount on
		if(@cierre = 0)begin
			update parametros set CP = 1 where idParametro = 1
			select 0 as error, message = 'Campaña recibida correctamente' for json path, without_array_wrapper 
			return
		end

		if(coalesce((select CP from parametros where idParametro = 1),0)=0) begin
			select 0 as error, message = 'No hay campañas pendientes' for json path, without_array_wrapper 
			return
		end

		declare @pendiente int = 0
		declare @DBC varchar(max) = concat(coalesce(dbo.fParameters('DBCampania'),''),'.dbo.')
		declare @hoja1 varchar(max) = @DBC + 'hoja1', @hoja2 varchar(max) = @DBC + 'hoja2',@sp varchar (3) = ''''

		if(object_id(@DBC+'hoja1')is not null)begin
			declare @sqlHoja1 nvarchar(max) = concat('select top 1 @pendiente=pendiente from ',@DBC,'hoja1')
			exec sp_executesql @sqlHoja1,N'@pendiente int out',@pendiente out
		end

		declare @CI varchar(max) = dbo.fParameters('cultureInfo')
		declare @sharedFolder varchar(max) = (select coalesce(dbo.notEmpty(fileServerPath),sharedFolder) from openjson((select bc From parametros),'$.ACE')with(sharedFolder varchar(max),fileServerPath varchar(max)))
		
		declare @sql nvarchar(max)= concat(
			'if(object_id(@hoja1) is not null)drop table ',@DBC,'hoja1;',
			'select *into ',@DBC,'hoja1 from openrowset(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0;Database=',@sharedFolder,'tmp.xlsx;HDR=YES'',''select top 1 * from [Hoja1$]'');',
			'alter table ',@DBC,'hoja1 add pendiente int; update ',@DBC,'hoja1 set pendiente=0'
		)
		exec sp_executesql @sql,N'@hoja1 varchar(max)',@hoja1

		declare @titulo varchar(max),@proposito varchar(max),@fechaInicio date, @fechaLimite date,@vencida bit = 0
		set @sql =concat('select @titulo = [Título],@proposito=[Propósito],@fechaInicio=[Fecha Inicio],@fechaLimite=[Fecha Límite] from ',@DBC,'hoja1') 
		exec sp_executesql @sql,N'@titulo varchar(max) out,@proposito varchar(max) out,@fechaInicio datetime out, @fechaLimite datetime out',@titulo out, @proposito out, @fechaInicio out, @fechaLimite out

		if(@fechaLimite< CONVERT(date,current_timestamp)) begin select 'Campaña vencida' return end
					
		set @sql = concat(
			'if(object_id(@hoja2) is not null)drop table ',@DBC,'hoja2 ',
			'select *into ',@DBC,'hoja2 from openrowset(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0;Database=',@sharedFolder,'tmp.xlsx;HDR=YES'',''select * from [Hoja2$] where [#] is not null'');'
		)
		exec sp_executesql @sql,N'@hoja2 varchar(max)',@hoja2

		update campanias set estado=0 where cast(CURRENT_TIMESTAMP as date) not between fechaInicio and fechaFin

		declare @idCampania int = (
			select top 1 idCampania from campanias 
			where (titulo = @titulo and cast(proposito as varchar(max)) = @proposito and fechaInicio = @fechaInicio and fechaFin = @fechaLimite and estado = 1) --or (titulo = @titulo and estado=0)
		)
		if(@idCampania is null)begin
			insert into campanias (titulo,proposito,fechaInicio,fechaFin,estado,fecha) values(@titulo,@proposito,@fechaInicio,@fechaLimite,1,current_timestamp)
			set @idCampania = SCOPE_IDENTITY()
		end
		else update campanias set estado = 1,fecha = current_timestamp where idCampania = @idCampania

		if(col_length(@hoja2, 'idCampania') is null)begin set @sql = concat('alter table ',@hoja2,' add idCampania int') exec sp_executesql @sql end
		if(col_length(@hoja2, 'idCredito') is null)begin set @sql = concat('alter table ',@hoja2,' add idCredito int') exec sp_executesql @sql end
		if(col_length(@hoja2, 'idCliente') is null)begin set @sql = concat('alter table ',@hoja2,' add idCliente int') exec sp_executesql @sql end
		if(col_length(@hoja2, 'idGestor') is null)begin set @sql = concat('alter table ',@hoja2,' add idGestor int') exec sp_executesql @sql end
		if(col_length(@hoja2, 'CodCliente') is null)begin set @sql = concat('alter table ',@hoja2,' add CodCliente varchar(50)') exec sp_executesql @sql end
		if(col_length(@hoja2, 'CodCredito') is null)begin set @sql = concat('alter table ',@hoja2,' add CodCredito varchar(50)') exec sp_executesql @sql end
		if(col_length(@hoja2, 'CodGestor') is null)begin set @sql = concat('alter table ',@hoja2,' add CodGestor varchar(50)') exec sp_executesql @sql end
		if(col_length(@hoja2, 'Teléfono') is null)begin set @sql = concat('alter table ',@hoja2,' add Teléfono varchar(150)') exec sp_executesql @sql end
		if(col_length(@hoja2, 'Nombre') is null)begin set @sql = concat('alter table ',@hoja2,' add Nombre varchar(50)') exec sp_executesql @sql end
		if(col_length(@hoja2, 'Apellidos') is null)begin set @sql = concat('alter table ',@hoja2,' add Apellidos varchar(50)') exec sp_executesql @sql end
		if(col_length(@hoja2, '#') is null)begin set @sql = concat('alter table ',@hoja2,' add [#] int') exec sp_executesql @sql end
		declare @sqlAdd nvarchar(max) = concat('update ',@hoja2,' set idCampania =',@idCampania)
		exec sp_executesql @sqlAdd

		declare @totalE int, @totalCP int, @totalCC int

		declare @sqlCP nvarchar(max) = concat(
			'select ',
				'dt.codigo,dt.nombre,dt.direccion,dt.telefono ',
			'into ',@DBC,'#CP from( ',
			'select ',
				'ROW_NUMBER() OVER(partition by [Identificación] order by [Identificación]) AS ID,',
				'[Identificación] as codigo,',
				'replace(concat(Nombre collate SQL_Latin1_General_CP1_CI_AS,'' '',Apellidos collate SQL_Latin1_General_CP1_CI_AS),''  '','' '') as nombre,',
				'[Teléfono] as telefono,',
				'[Dirección] as direccion ',
				'from ',@DBC,'hoja2 ',
				'where CodCredito is null and CodCliente is null and [Identificación] is not null and Nombre is not null ',
			')as dt ',
			'where ID = 1 ',
			'set @totalE = (select count(1) from hoja2) ',

			'insert clientesPotenciales ',
			'(codigo,nombre,direccion,telefono) ',
			'select ',
				's.codigo,s.nombre,s.direccion,s.telefono ',
			'from clientesPotenciales t ',
			'right outer join ',@DBC,'#CP s on s.codigo collate SQL_Latin1_General_CP1_CI_AS = t.codigo collate SQL_Latin1_General_CP1_CI_AS ',
			'where t.idClienteP is null ',

			'update t ',
			'set ',
				't.nombre = s.nombre,t.direccion=s.direccion,t.telefono=s.telefono ',
			'from clientesPotenciales t ',
			'inner join ',@DBC,'#cp s on s.codigo collate SQL_Latin1_General_CP1_CI_AS = t.codigo collate SQL_Latin1_General_CP1_CI_AS ',

			'set @totalCP = (select count(1) from clientesPotenciales t inner join #cp s on s.codigo collate SQL_Latin1_General_CP1_CI_AS = t.codigo collate SQL_Latin1_General_CP1_CI_AS )'
		)
		exec sp_executesql @sqlCP,N'@totalE int out, @totalCP int out',@totalE out, @totalCP out
		--print @sqlCP

		declare @sqlCC nvarchar(max)=concat(
			'insert clientesCampania',
			'(idCampania,ID,idCredito,idCliente,idClienteP,idGestor) ',
			'select ',
				's.idCampania,s.[#],cr.idCredito,cl.idCliente,cp.idClienteP,g.idGestor ',
			'from ',@DBC,'hoja2 s ',
			'inner join gestores g on codigo collate SQL_Latin1_General_CP1_CI_AS = s.CodGestor collate SQL_Latin1_General_CP1_CI_AS ',
			'left join creditos cr on cr.referencia collate SQL_Latin1_General_CP1_CI_AS = s.CodCredito collate SQL_Latin1_General_CP1_CI_AS ',
			'left join clientes cl on cl.codigo collate SQL_Latin1_General_CP1_CI_AS = s.CodCliente collate SQL_Latin1_General_CP1_CI_AS ',
			'left join clientesPotenciales cp on cp.codigo collate SQL_Latin1_General_CP1_CI_AS = s.Identificación collate SQL_Latin1_General_CP1_CI_AS ',
			'left join clientesCampania cc1 on cc1.idCredito = cr.idCredito and cc1.idCampania = s.idCampania and cc1.idGestor = g.idGestor ',
			'left join clientesCampania cc2 on cc2.idCliente = cl.idCliente and cc2.idCampania = s.idCampania and cc2.idGestor = g.idGestor ',
			'left join clientesCampania cc3 on cc3.idClienteP = cp.idClienteP and cc3.idCampania = s.idCampania and cc3.idGestor = g.idGestor ',
			'where coalesce(cc1.idCampania,cc2.idCampania,cc3.idCampania) is null and coalesce(cr.idCredito,cl.idCliente,cp.idClienteP)is not null and g.idGestor is not null ',

			'update t ',
			'set ',
				'idCredito=cr.idCredito,',
				'idCliente=cl.idCliente,',
				'idClienteP=cp.idClienteP,',
				'idGestor = g.idGestor, ',
				'ID=s.#, ',
				'estado=1 ',
			'from clientesCampania t ',
			'inner join ',@DBC,'hoja2 s on s.idCampania = t.idCampania and s.[#] = t.ID ',
			'inner join gestores g on g.codigo collate SQL_Latin1_General_CP1_CI_AS = cast(s.CodGestor as varchar(max)) collate SQL_Latin1_General_CP1_CI_AS ',
			'left join clientes cl on cl.codigo collate SQL_Latin1_General_CP1_CI_AS = cast(s.CodCliente as varchar(max)) collate SQL_Latin1_General_CP1_CI_AS ',
			'left join creditos cr on cr.referencia collate SQL_Latin1_General_CP1_CI_AS = cast(s.CodCredito as varchar(max)) collate SQL_Latin1_General_CP1_CI_AS ',
			'left join clientesPotenciales cp on cp.codigo collate SQL_Latin1_General_CP1_CI_AS = cast(s.[Identificación] as varchar(max)) collate SQL_Latin1_General_CP1_CI_AS '
		)
		exec sp_executesql @sqlCC
		--print @sqlCC

		set @totalCC = (select count(1) from clientesCampania where idCampania = @idCampania and estado = 1)

		declare @px int
		set @sql = concat('set @px = (select top 1 ordinal_position from ',replace(@dbc,'.dbo',''),'information_schema.columns where column_name = ''P_IN'' and TABLE_NAME = ''hoja2'')')
		exec sp_executesql @sql,N'@px int out',@px out
				
		declare @campos nvarchar(max)
		set @sql = concat('set @campos = (dbo.fStuff(( ',
			'select distinct concat('',['',column_name,'']'') ',
			'from ',replace(@DBC,'.dbo',''),'information_schema.columns ', 
			'where table_name = ''hoja2'' and ordinal_position > @px and ',
				'column_name not in(''idCampania'',''idCredito'',''idCliente'',''codCredito'',''codCliente'',''Nombre'',''Apellidos'',''Teléfono'',''Identificación'',''idGestor'',''CodGestor'',''#'',''P_IN'') ',
			'for xml path('''')',')))'
		)
		exec sp_executesql @sql,N'@campos varchar(max) out, @px int',@campos out,@px
				
		declare @_unpiv nvarchar(max) = concat(
			'select ',
				'ID = [#],',
				'u.idCampania,',
				'cc.idClienteCampania, ',
				'u.campo,',
				'u.valor ',
			'from ',@DBC,'hoja2 unpivot(valor for campo in(',@campos,'))u ',
			'inner join clientesCampania cc on cc.ID = u.# and cc.idCampania = u.idCampania'
		)
		--print @_unpiv

		declare @unpiv table(ID int, idCampania int,idClienteCP int, campo varchar(max),valor varchar(max))
		insert  @unpiv exec sp_executesql @_unpiv
							
		declare @dt table(# int identity(1,1), idClienteCP int)
		insert @dt select idClienteCampania from clientesCampania where idCampania = @idCampania and estado = 1
		declare @index int = 1, @total int = (select count(1) from @dt)

		while @index <= @total begin
			declare @idClienteCP int = null

			select
				@idClienteCP = idClienteCP
			from @dt where # = @index

			declare @rsp nvarchar(max) = (select concat(campo,'!',valor,';') from @unpiv where idClienteCP = @idClienteCP for xml path('')) 

			update clientesCampania set data = @rsp where idClienteCampania = @idClienteCP 
		 
			set @index += 1
		end

		declare @cultureInfo varchar(max) = dbo.fParameters('cultureInfo')
		declare @ddVig int = (select dbo.fParameters('visRepVig'))
		declare @ddVen int = (select dbo.fParameters('visRepVen'))
		delete campaniaAlDia
		insert campaniaAlDia(idClienteCampania,idCampania ,idCredito ,idCliente ,idClienteP ,referencia,codigoCliente ,cliente ,direccion ,telefono ,fechaInicio ,fechaFin ,diasCampania ,latitud ,longitud,latitudNegocio ,longitudNegocio ,visita ,actividadVisita ,fechaVisita ,diasVisita ,visitaPopup ,DUG ,UD ,result,popup,indexP ,idGestor)
		select
			cc.idClienteCampania,
			cp.idCampania,
			cr.idCredito,
			idCliente = coalesce(cl.idCliente,cl2.idCliente),
			clp.idClienteP,
			cr.referencia,
			codigoCliente = coalesce(cl.codigo, cast(cl.idCliente as varchar(25)), cl2.codigo,cast(cl2.idCliente as varchar(25))),
			cliente = coalesce(clp.nombre,cl.nombre,cl2.nombre),
			direccion = coalesce(clp.direccion,cl.direccion,cl2.direccion),
			telefono = coalesce(clp.telefono,cl.telefono,cl2.telefono),
			fechaInicio = FORMAT(cp.fechaInicio,'dd-MM-yyyy',@cultureInfo),
			fechaFin = FORMAT(cp.fechaFin,'dd-MM-yyyy',@cultureInfo),
			diasCampania = datediff(day,cp.fechaInicio,GETDATE()),
			latitud = coalesce(cl.latitud,cl2.latitud),
			longitud = coalesce(cl.longitud,cl2.longitud),
			latitudNegocio = coalesce(cl.latitudNegocio,cl2.latitudNegocio),
			longitudNegocio = coalesce(cl.longitudNegocio,cl2.longitudNegocio),
			iif(vr.idVisita is not null,1,0) as visita,
			a.actividad as actividadVisita,
			format(vr.fechaVisita,'dd MMM yyyy',@cultureInfo) as fechaVisita,
			vr.diasVisita,
			iif(vr.diasVisita between -@ddVen and @ddVig,1,0) as visitaPopup,
			cc.DUG,
			cc.UG,
			concat('alias!valor;','Título!',
				titulo,';Propósito!',
				proposito,';Días campaña!',
				diasCampania,';Dias finalización!',
				datediff(day,GETDATE(),cp.fechaFin),';Fecha inicio!',
				fechaInicio,';Fecha finalización!',
				fechaFin,';',
				data
			)as result,
			(select *from(
				select 'Campaña' as Actividad,
				(select * from(
					select 'Proposito' as 'name',cast(cp.proposito as varchar(max)) as 'value'
					union select 'Fecha Inicio' as 'name',format(cp.fechaInicio,'dd-MMM-yyyy',@cultureInfo) as 'value'
					union select 'Fecha Fin' as 'name',format(cp.fechaFin,'dd-MMM-yyyy',@cultureInfo) as 'value'
				) as dt for json path) as params
			)as ds for json path, WITHOUT_ARRAY_WRAPPER) as popup,
			0 as indexP,
			cc.idGestor
		from clientesCampania cc
		inner join campanias cp on cp.idCampania = cc.idCampania
		left join creditos cr on cr.idCredito = cc.idCredito
		left join clientes cl on cl.idCliente = cc.idCliente
		left join clientes cl2 on cl2.idCliente = cr.idCliente
		left join clientesPotenciales clp on clp.idClienteP = cc.idClienteP
		left join VisitasReprogramadas vr on (vr.idCredito = cr.idCredito or vr.idClienteP = clp.idClienteP) and vr.idCampania = cp.idCampania and vr.fechaVisita >=  DATEADD(day,-@ddVen,cast(GETDATE() as date)) and realizada = 0            
		left join actividades a on a.idActividad = vr.idActividad
		where cc.estado = 1 and cp.estado = 1

		update i
		set 
			campanias = current_timestamp
		from inicioSesionJS i where ID = 3

		set @sql = concat(
			'if(object_id(@hoja1) is not null)drop table ',@DBC,'hoja1 ',
			'if(object_id(@hoja2) is not null)drop table ',@DBC,'hoja2'
		)
		exec sp_executesql @sql,N'@hoja1 nvarchar(max),@hoja2 nvarchar(max)',@hoja1,@hoja2

		exec precargaParcial

		update parametros set CP = 0 where idParametro = 1

		declare @_rsp nvarchar(max) = (
			select 
				'Campaña procesada correctamente'as Respuesta,
				@titulo as [Título],
				@proposito as [Propósito],
				format(@fechaInicio,'dddd dd MMMM yyyy',@CI)as [Fecha inicio],
				format(@fechaLimite,'dddd dd MMMM yyyy',@CI)as [Fecha límite],
				@totalE as [Total clientes Excel],
				@totalCP as [Total clientes potenciales],
				(@totalCC - @totalCP) as [Total clientes existentes],
				@totalCC as [Total procesados],
				format(current_timestamp,'dddd dd MMMM yyyy hh:mm tt',@CI)as [Fecha proceso]
			for json path, without_array_wrapper
		)

		update campanias set rsp = @_rsp where idCampania = @idCampania

		select error = 0, message = 'Campaña procesada correctamente' for json path, without_array_wrapper
	set nocount off
end
