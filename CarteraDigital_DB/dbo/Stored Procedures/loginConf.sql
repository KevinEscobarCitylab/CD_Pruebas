CREATE PROCEDURE [dbo].[loginConf](@idUsuario int,  @sessionid varchar(max) = null) as 
BEGIN
    declare @cultureInfo varchar(5),@version varchar(15)
    select
        @cultureInfo = cultureInfo,
        @version  = version
    from openjson((select conf from parametros))with(cultureInfo varchar(max), version varchar(15))

    if @idUsuario is not null begin
        declare @idG int = (select idGestor from usuarios where idUsuario = @idUsuario)

        select (select
            0 as error,
            'Verificado' as message,
            usuario = (select json_query(
                cast((select
                        u.sessionid,
                        GETDATE() as fechaSistema,
                        'Cartera Total' as saldoName,
                        format(g.saldoCartera,'C',@cultureInfo) as saldoCartera,
                        g.totalClientes,
                        g.totalClientesMora as clientesEnMora,
                        'Creditos' as creditoName,
                        format(u.fechaCierre,'Cierre: dddd, dd MMMM yyyy',@cultureInfo)as fechaCierre,
                        @version as versionDLL,
                        g.idGestor,
                        u.idUsuario,
                        g.nombre as gestor,
                        gg.grupo,
                        totalRuta = (select meta from metasGestorIndicador where idIndicador = 1 and idGestor = g.idGestor),
                        u.pin as 'PIN',
                        u.autoEnvio,
                        @cultureInfo as cultureInfo,
                        useTransaction = 1,
                        token = @sessionid,
                        idToken = (select top 1 idToken from sesionesUsuario where token = @sessionid)
                        from grupos gg
                        where gg.idGrupo = g.idGrupo for JSON PATH, WITHOUT_ARRAY_WRAPPER
                    )as nvarchar(max))
                )as ds
            ),
            app = isNull((select json_query(p.app) from parametros p where idParametro = 1),'{}'),
            historial = isNull((
				select
					ra.idActividad,
					ra.idReaccion,
					ra.idDetalle,
					ra.idMotivo,
					ra.idCredito,
					ra.idCliente,
					ra.idClienteP,
					ra.idGrupo,
					ra.idProspecto,
					c.cuotaVenceHoy as venceHoy,
					FORMAT(ra.fecha,'dd/MM/yyyy HH:mm:ss','es-ES') as fechaGestion,
					cl.nombre as cliente,
					cl.codigo as codigo
				from registroActividades ra
				left join clientes cl on cl.idCliente = ra.idCliente
				left join creditos c on c.idCredito = ra.idCredito
				where cast(ra.fecha as date) = cast(GETDATE() as date) and ra.idGestor = g.idGestor for JSON PATH),'[]'
			),
            actividades = json_query(i.actividades),
            detalleActividades = json_query(i.detalleActividades),
            reacciones = json_query(i.reacciones),
            motivoActividades = json_query(i.motivoActividades),
            campanias = json_query(i.campanias),
            menu = (select
                    m.codigo as cd,
                    m.categoria as ct,
                    m.menu as mn
                from menuMovil m
                inner join gruposMenuMovil gm on gm.idMenu = m.idMenu
                where gm.idGrupo = g.idGrupo and m.estado = 1 and gm.estado = 1 FOR JSON PATH
            ),
            indicadores = isNull((select
                    dt.*,
                    c.color
				from(
                    select
                    ig.idIndicador,
                    i.nombre,
                    ig.valor as resultado,
                    ig.valorT,
                    ig.meta,
                    dbo.fMetaPorcentual(ig.valor,ig.meta,i.inverso)as porcentual,
                    cast((cast(ig.valor as float)-cast(ig.meta as float))as decimal(10,2))as diferencia,
                    dbo.fIndicador(g.idGestor,ig.idIndicador,dbo.fMetaPorcentual(ig.valor,ig.meta,i.inverso))as idColor,
                    i.valorA,
                    i.valorM
                    from indicadoresGestor ig
                    inner join indicadores i on i.idIndicador = ig.idIndicador and i.idGrupo = g.idGrupo
                    where ig.idGestor = g.idGestor
                )as dt
                inner join coloresIndicador c on c.idColor = dt.idColor
                where dt.resultado is not null for JSON PATH
            ),'[]'),
            confRankings = json_query(g.clasificacion),
            promesasPago = isNull((select
                    idPromesa,
                    FORMAT(fechaPromesa,'dddd, dd-MMMM-yyyy','es-ES')as fechaPromesa,
                    FORMAT(fechaGestion,'dddd, dd-MMMM-yyyy','es-ES')as fechaGestion,
                    idCredito,
					montoPrometido,
					montoPagado,
					incumplida,
					porVencer,
					venceHoy
				from promesasPago
				where diasPromesa between -16 and 4 and montoPagado < montoPrometido and idGestor = g.idGestor for JSON PATH
            ),'[]'),
            clientesCampania = isNull((select
                    cc.idClienteCampania,
                    cc.idCampania,
                    cc.idCredito,
                    cc.idCliente,
                    cc.idClienteP,
                    cc.referencia,
                    cc.codigoCliente,
                    cc.cliente,
                    cc.direccion,
                    cc.telefono,
                    cc.fechaInicio,
                    cc.fechaFin,
                    cc.diasCampania,
                    cc.latitud,
                    cc.longitud,
                    cc.latitudNegocio,
                    cc.longitudNegocio,
                    cc.visita,
                    cc.actividadVisita,
                    cc.fechaVisita,
                    cc.diasVisita,
                    cc.visitaPopup,
                    cc.gestionado,
                    cc.DUG,
                    cc.UD as UG,
                    cc.popup,
                    cc.result
                from campaniaAlDia cc
                where cc.idGestor = g.idGestor for JSON PATH
            ),'[]'),
            agendados = isNull((select 
                    idRutaAgendada,
                    idCredito,
                    idClienteCampania,
                    idProspecto,
                    recomendacion as rec,
                    idActividad,
                    idGrupoAdesco,
                    format(fecha,'dd/MM/yyyy',@cultureInfo) as fecha,
                    acumulado,
                    agendado
                from rutasAgendadas r
                where r.fecha between cast(getdate() as date) and dateadd(day, 7, cast(getdate() as date)) 
                and estado = 1 and r.idGestor = g.idGestor for JSON PATH
            ),'[]'),    
            rutaAnterior = isNull((select 
                    idRuta,
                    idCredito,
                    idClienteCampania,
                    idProspecto,
                    recomendacion as rec,
                    idActividad,
                    idGrupoAdesco,
                    format(fecha,'dd/MM/yyyy',@cultureInfo) as fecha,
                    gestionado as gestion
                from rutas r
                where r.fecha = DATEADD(day, -1, cast(getdate() as date)) and estado = 1 and r.idGestor = g.idGestor for JSON PATH
            ),'[]'),
            ruta = isNull((select 
                    idRuta,
                    idCredito,
                    idClienteCampania,
                    idProspecto,
                    recomendacion as rec,
                    idActividad,
                    idGrupoAdesco,
                    format(r.fecha,'dd/MM/yyyy',@cultureInfo) as fecha
                from rutas r
                where r.fecha = cast(GETDATE()as date) and estado = 1 and r.idGestor = g.idGestor for JSON PATH
            ),'[]'),
            fiadores = isNull((select
                    f.idFiador,
                    f.idFiadorAsignado,
                    f.nombre,
                    f.telefono,
                    f.direccion,
                    f.latitud,
                    f.longitud,
                    f.idCredito,
                    f.imgCasa,
                    f.imgNegocio ,
                    f.pendienteCasa,
                    f.pendienteNegocio,
                    isNull((select idImagen,url,casa,idCliente,idFiador,idGrupo from imagenesGPS where idFiador = f.idFiador and estado = 1 for JSON PATH),'[]')as geoPic
                from fiadoresAsignados_v f
                where f.idGestor = g.idGestor for JSON PATH
            ),'[]' ),
            incidencias = json_query('[]')
        from usuarios u
        inner join gestores g on g.idGestor = u.idGestor
        inner join inicioSesionJS i on i.ID = 1
        where u.idUsuario = @idUsuario for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
    end
    else begin
        select (select 1 as error,'Usuario o contraseña incorrecto' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data
    end
END