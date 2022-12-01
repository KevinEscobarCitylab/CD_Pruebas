CREATE procedure [dbo].[actualizarCartera] as
begin
	declare @day date = (select DATEADD(DAY,-1,GETDATE()))
	declare @sql varchar(max)

	declare @path varchar(512) = concat('\\BSUIO-FS00\Tarjeta\Reportes\ComercioAsesorDigital_',format(@day,'yyMMdd'),'.txt')

	DECLARE @result INT
	EXEC master.dbo.xp_fileexist @path, @result OUTPUT

	if(cast(@result as bit) = 1)begin
        --delete comerciosT
        --set @sql = 'BULK INSERT comerciosT FROM '''+@path+''' with (firstrow = 1,fieldterminator = ''\t'',rowterminator = ''\n'',tablock)'
        --exec (@sql)

        truncate table T_incidencias
        insert T_incidencias
        (BugID,idCliente,empresa,fecha,diasTranscurridos,descripcion,StatusID,StatusDescripcion,userName,ok)
        select
                        s.BugID,
                        t.idCliente,
                        t.nombre,
                        ReportedDate as fecha,
                        null as diastrancurridos,
                        s.Descripcion,
                        s.StatusID,
                        s.StatusDescripcion,
                        s.ReporterUserName,
                        iif(s.StatusID = 3,1,0) as ok
        from [BS-APEX01\APEX].Requerimientos.dbo.requerimientosT s
        inner join clientes t on t.codigo = s.clienteid
        WHERE ReportedDate >=  DATEADD(MONTH,-1,GETDATE())

        --agencias
        insert agencias(idAgenciaT,agencia,estado)
        select
        rtrim(s.UserName)  ,
        rtrim(s.nombre) ,
        1
        from agencias t
        right outer join gestoresT s on s.UserName = t.idAgenciaT
        where t.idAgencia is null

        update agencias set estado = 0

        update t
            set t.estado = 1
        from agencias t
        inner join gestoresT s on s.UserName = t.idAgenciaT

        --Gestores
        insert into gestores
        (codigo,idGestorT,nombre,idAgencia,idGrupo,ruta,estado,sistema)
        select
            rtrim(s.UserName) as idG,
            rtrim(s.UserName) as idG,
            rtrim(s.nombre) as G,
            null as a2,
            9,
            0,
            1,
            1
        from gestores t
        right outer join gestoresT s on s.UserName = t.codigo
        where t.idGestor is null

        insert into gestores (codigo,nombre,idGrupo,estado,sistema)
        select
            w.UserName,
            w.nombre,
            CASE w.CodigoPerfil
                WHEN 'GERNEGTC' THEN 10
                WHEN 'ASIEMPRE' THEN 11
                WHEN 'ASISTREVCTRL' THEN 14
                WHEN 'JEFREVCTRL' THEN 15
                WHEN 'TECREVCTRL' THEN 16
                WHEN 'ASISTREVCTRLDIG' THEN 17
                WHEN 'JEFPRODTAR' THEN 18
                WHEN 'OFICSEG' THEN 1
                WHEN 'SUBRIEPAR' THEN 1
                WHEN 'ASESCUE' THEN 19
                WHEN 'ASIOPECRE' THEN 20
                WHEN 'ASICREDI' THEN 21
                WHEN 'ANACREN1' THEN 22
                WHEN 'JEFCREDI' THEN 23
                WHEN 'GERCREDI' THEN 24
                WHEN 'OFIOPERPOS' THEN 25
                WHEN 'JEFOPMAT' THEN 26
                WHEN 'TECOPERREC' THEN 27
                WHEN 'PLATCOM' THEN 28
                WHEN 'GEREAGESUC' THEN 29
                WHEN 'ASINEGTRJ' THEN 42
                ELSE null
            END as idgrupo,
            1 as estado,
            1 as sistema
        from UsuariosWEBT w
        left join gestores us on us.codigo = w.UserName
        where us.idGestor is null

        update gestores set estado=0 where estado=1 and sistema = 1

        update t
        set
            t.estado = 1,
            t.idAgencia = a.idAgencia
        from gestores t
        inner join gestoresT s on s.UserName = t.codigo
        left join agencias a on a.idAgenciaT = t.codigo

        update t set
            t.estado = 1,
            t.idGrupo = CASE w.CodigoPerfil
                WHEN 'GERNEGTC' THEN 10
                WHEN 'ASIEMPRE' THEN 11
                WHEN 'ASISTREVCTRL' THEN 14
                WHEN 'JEFREVCTRL' THEN 15
                WHEN 'TECREVCTRL' THEN 16
                WHEN 'ASISTREVCTRLDIG' THEN 17
                WHEN 'JEFPRODTAR' THEN 18
                WHEN 'OFICSEG' THEN 1
                WHEN 'SUBRIEPAR' THEN 1
                WHEN 'ASESCUE' THEN 19
                WHEN 'ASIOPECRE' THEN 20
                WHEN 'ASICREDI' THEN 21
                WHEN 'ANACREN1' THEN 22
                WHEN 'JEFCREDI' THEN 23
                WHEN 'GERCREDI' THEN 24
                WHEN 'OFIOPERPOS' THEN 25
                WHEN 'JEFOPMAT' THEN 26
                WHEN 'TECOPERREC' THEN 27
                WHEN 'PLATCOM' THEN 28
                WHEN 'GEREAGESUC' THEN 29
                WHEN 'ASINEGTRJ' THEN 42
                ELSE null
            END
        from gestores  t
        inner join UsuariosWEBT w on w.UserName = t.codigo

        --lineasCredito
        insert lineasCredito(idLineaT,lineaCredito,estado)
        select
            s.tipoCreditos,--idLineaT
            s.tipoCreditos,
            1--estado
        from lineasCredito t
        right outer join (select tipoCreditos from comerciosT group by tipoCreditos) s on s.tipoCreditos = t.idLineaT
        where t.idLineaCredito is null

        update lineasCredito set estado = 0

        update t
            set t.estado = 1
        from lineasCredito t
        inner join (select tipoCreditos from comerciosT group by tipoCreditos) s on s.tipoCreditos = t.idLineaT

        --GruposAdesco
        insert gruposAdesco(idGrupoAdescoT,nombre,idEstado)
        select
            s.codigoComercio,
            s.nombreComercio,
            iif(s.estadoComercio = 1, 2, 3)
        from gruposAdesco t
        right outer join (select codigoComercio,nombreComercio,estadoComercio from comerciosT group by codigoComercio,nombreComercio,estadoComercio)as s on s.codigoComercio = t.idGrupoAdescoT
        where t.idGrupoAdesco is null

        update t
            set t.idEstado = iif(s.estadoComercio = 1, 2, 3)
        from gruposAdesco t
        inner join (select codigoComercio,nombreComercio,estadoComercio from comerciosT group by codigoComercio,nombreComercio,estadoComercio)as s on s.codigoComercio = t.idGrupoAdescoT

        --clientes
        insert clientes(idClienteT,codigo,nombre,idEstado,nDoc,direccion)
        select
            s.codigoEstablecimiento,--idClienteT
            s.codigoEstablecimiento,--codigo
            s.nombreEstablecimineto,
            --telefono,
            iif(s.estadoEstablecimiento = 1, 1, 2) as idEstado,
            s.RUC,--nDOC
            concat(s.nombreRepresentante,'--',s.direccion) as direccion
        from clientes t
        right outer join comerciosT s on s.codigoEstablecimiento = t.idClienteT
        where t.idCliente is null

        update t set
            t.idEstado = iif(s.estadoEstablecimiento = 1, 1, 2) ,
            t.direccion = concat(s.nombreRepresentante,'--',s.direccion)
        from clientes t
        inner join comerciosT s on s.codigoEstablecimiento = t.idClienteT

        --telefonosClientes
        insert telefonosCliente(idCliente,telefono)
        select
            cl.idCliente,
            s.telefono
        from telefonosCliente t
        right outer join ( select * from(
            select codigoEstablecimiento,telefono
            from comerciosT
            union
            select codigoEstablecimiento,telefonoRepresentante
            from comerciosT
        ) as t where telefono is not null  group by t.codigoEstablecimiento,t.telefono ) as s on s.telefono = t.telefono
        inner join clientes cl on cl.idClienteT = s.codigoEstablecimiento
        where idTelefono is null

        --creditos
        insert creditos(idCreditoT,referencia,idCliente,idLineaCredito,consumo,mpos,numeroTransacciones,idEstado,idGrupo,representante)
        select
            s.codigoEstablecimiento  as idCreditoT,
            concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC)) as referencia,
            cl.idCliente,--idCliente,
            lc.idLineaCredito,
            s.consumo,
            s.mpos,
            s.numeroTransacciones,
            iif(s.estadoEstablecimiento = 1, 1, 2) as idEstado,
            g.idGrupoAdesco,
            s.nombreRepresentante
        from creditos t
        right outer join comerciosT s on concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC)) = t.referencia
        inner join clientes cl on cl.idClienteT = s.codigoEstablecimiento
        inner join lineasCredito lc on lc.idLineaT = s.tipoCreditos
        inner join gruposAdesco g on g.idGrupoAdescoT = s.codigoComercio
        where t.idCredito is null and s.codigoEstablecimiento is not null

        update t set
            t.consumo = s.consumo,
            t.mpos = s.mpos,
            t.numeroTransacciones = s.numeroTransacciones,
            t.idEstado = iif(s.estadoEstablecimiento = 1, 1, 2) ,
            t.representante = s.nombreRepresentante
        from creditos t
        inner join comerciosT s on concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC)) = t.referencia

            update t set
        t.idAgencia = a.idAgencia
        from creditos t
        inner join comerciosT s on concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC)) = t.referencia
        inner join agencias a on a.idAgenciaT = s.usuario

        --CreditosAsignados
        update creditosAsignados set asignado = 0 where asignado = 1

        insert into creditosAsignados
        (idCredito,idCreditoT,referencia,idGestorT,idGestor,asignado)
        select
            cr.idCredito,
            s.codigoEstablecimiento,
            concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC)),
            s.usuario,
            g.idGestor,
            1
        from comerciosT s
        left join creditosAsignados t on concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC)) = t.referencia and s.usuario = t.idGestorT
        inner join creditos cr on cr.referencia = concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC))
        inner join gestores g on g.codigo = s.usuario
        where t.idCreditoAsignado is null

        update t set t.idGestor = g.idGestor
        from creditosAsignados t
        inner join gestores g on g.codigo = t.idGestorT
        where t.idGestor is null

        update t  set  asignado= 1
        from  creditosAsignados t
        inner join comerciosT s on concat(s.codigoEstablecimiento,'.', iif(s.RUC is null,'',s.RUC)) = t.referencia and s.usuario = t.idGestorT
        where t.asignado!=1

        --Guardando la asignacion de los grupos
            if(object_id('tempdb..#grupos') is not null)drop table #grupos
            select 
                dt.idGrupoAdesco,
                dt.idGestor
            into #grupos from(
                select
                    ga.idGrupoAdesco,
                    cr.idGestor
                from creditosAsignados_v cr
                inner join gruposAdesco ga on ga.idGrupoAdesco = cr.idGrupo
                inner join estadosCredito ec on ec.idEstado =  cr.idEstado
                where ec.codigo != 'CAN' group by ga.idGrupoAdesco, cr.idGestor
                union
                select 
                    ga.idGrupoAdesco,
                    ga.idGestor
                from gruposAdesco ga where ga.idGrupoAdescoT is null and ga.idEstado in(1,2)
                union
                select 
                    ga.idGrupoAdesco,
                    p.idGestor
                from gruposAdesco ga
                inner join (select idGrupoAdesco,idGestor,sum(iif(etapa=1,1,0)) as t from prospectos group by idGrupoAdesco,idGestor) p on p.idGrupoAdesco = ga.idGrupoAdesco and t>0
            ) dt

            insert into gruposAsignados (idGrupoAdesco,idGestor,asignado)
            select 
                dt.idGrupoAdesco,
                dt.idGestor,
                1
            from #grupos dt
            left join gruposAsignados ga on ga.idGrupoAdesco = dt.idGrupoAdesco and ga.idGestor = dt.idGestor
            where ga.idGrupoAsignado is null

            update gruposAsignados set asignado = 0

            update ga
            set
                ga.asignado = 1
            from gruposAsignados ga
            inner join  #grupos dt on ga.idGrupoAdesco = dt.idGrupoAdesco and ga.idGestor = dt.idGestor

        --usuarios
        insert into usuarios
        (idGestor,usuario,clave,idGrupo,fechaCierre,verificador,diasDesdeCambioClave,multiplesDispositivos)
        select
            s.idGestor,
            s.codigo,
            dbo.md5(codigo),
            s.idGrupo,
            getdate(),
            0,
            0,
            1
        from usuarios t
        right outer join gestores s on s.idGestor = t.idGestor
        where t.idUsuario is null

        update usuarios
        set
            fechaCierre = getdate(),
            diasDesdeCambioClave = DATEDIFF(DAY,coalesce(fechaCambioClave,fechaCierre),GETDATE()),
            fechaCambioClave = coalesce(fechaCambioClave,fechaCierre),
            fechaBloqueo = null,
            intentosFallidos = 0

        --Cumplimiento de rutas
            insert cumplimientoRuta
            (idGestor,meta,valor,fecha)
            select
                s.idGestor,
                s.meta,
                s.cumplido,
                s.fecha
            from cumplimientoRuta t
            right outer join cumplimientoRuta_v s on s.fecha = t.fecha
            where t.idGestor is null

	    exec ProcesarRankings

        exec establecerCriterios

        update gestores set totalClientes = 0, totalClientesMora=0,saldoCartera=0, ruta = 0 where estado = 1

        update t
        set
            t.saldoCartera = s.transacciones,
            t.totalClientes = s2.locales
        from gestores t
        inner join(select sum(numeroTransacciones) as transacciones,usuario from comerciosT group by usuario)as s on s.usuario = t.codigo
        inner join(select sum(1) as locales,idGestor from cartera_v group by idGestor) as s2 on s2.idGestor = t.idGestor
        where t.estado = 1

        update gruposAdesco set totalDesembolso = 0, totalMora = 0, totalVenceHoy=0, totalPrioridad=0, totalRenovacion = 0,totalVencimiento = 0 where idEstado in (1,2)
        
        --update t
        --set
        --	t.totalDesembolso = s.saldo,
        --	t.totalMora = s.mora,
        --	t.totalVenceHoy = venceHoy,
        --	t.totalPrioridad = prioridad,
        --	t.totalRenovacion = renovacion,
        --	t.totalVencimiento = vencimiento
        --from gruposAdesco t
        --inner join(
        --	select 
        --		idGrupoAdesco,
        --		sum(saldo)as saldo,
        --		sum(mora)as mora,
        --		sum(totalVenceHoy) as venceHoy,
        --		sum(totalVencimiento) as vencimiento,
        --		sum(renovacion) as renovacion,
        --		sum(prioridad)as prioridad
        --	from(
        --		select 
        --			idGrupoAdesco,
        --			coalesce(saldoCapitalVigente,0)as saldo,
        --			iif(diasCapitalMora > 0,1,0)as mora,
        --			iif(cuotaVenceHoy=1,1,0)as totalVenceHoy,
        --			iif(cobroPreventivo=1,1,0)as totalVencimiento,
        --			iif(renovacion=1,1,0)as renovacion,
        --			iif(prioridad>0,1,0)as prioridad
        --		from cartera_v
        --	)as dt
        --	group by idGrupoAdesco 
        --)as s on s.idGrupoAdesco = t.idGrupoAdesco
        --where t.idEstado in (1,2)
        		
        update g 
            set g.idEstado=iif(cg.R > 0,1,iif(NR>0,2,g.idEstado))
        from gruposAdesco g 
        inner join (
            select 
                idGrupo,
                sum(iif(c.renovacion = 1 and c.totalGestionesRenovacion = 0,1,0)) as R,
                sum(iif(c.renovacion=0 and c.totalGestionesRenovacion = 0,1,0)) as NR
            from creditos c
            where c.idEstado=1
            group by idGrupo
        ) as cg on cg.idGrupo = g.idGrupoAdesco
        where g.idGestor is null and (cg.R!=0 or cg.NR=0) 

        delete from notificaciones where estado = 0	
	end
	else select concat('--> no se encontro archivo:',@path) as error
end