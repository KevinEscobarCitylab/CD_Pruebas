CREATE procedure [dbo].[inicioSesion](@idUsuario int,  @sessionid varchar(max) = null, @PCLToken varchar(max) = null)as
begin
    declare @useTransaction varchar(max),@version varchar(max),@cultureInfo varchar(max),@usarDatosCierre bit
    select
        @useTransaction = useTransaction,
        @version  = version,
        @cultureInfo = cultureInfo,
        @usarDatosCierre = usarDatosCierre
    from openjson((select conf from parametros))with(useTransaction bit, version varchar(max), cultureInfo varchar(max),usarDatosCierre bit)

    set @idUsuario = coalesce(@idUsuario,(select idUsuario from usuarios where sessionid=@sessionid and len(@sessionid) > 2 and @sessionid is not null))
    declare @parcial int = iif(@sessionid in('-1','-2','-3','-4'),1,0)--prospecto, grupo, grupo + prospecto,vacio
    if(@parcial = 1)set @parcial = @sessionid
    declare @app nvarchar(max) = (select p.app from parametros p where idParametro = 1 and @parcial = 0)
    declare @PCL_Token varchar(max) = (select PCLToken from parametros where idParametro = 1)
    declare @tokenDiffPCL int = iif(@PCLToken is null or @PCLToken = '',1, datediff(minute,@PCLToken,@PCL_Token))
    declare @showRefused int = (select [value] as CI from openjson((select conf from parametros)) where [key] = 'showRefused')
    declare @ddVig int = (select dbo.fParameters('visRepVig'))
    declare @ddVen int = (select dbo.fParameters('visRepVen'))
    declare @rsp nvarchar(max)

    if @idUsuario is not null begin
        declare @idG int = (select idGestor from usuarios where idUsuario = @idUsuario)

        --Encabezados
        set nocount on
            declare @temp table(# int identity(1,1), idProspecto int, idPregunta int,idFormulario int,idEncuestaR int, ob int, observacion2 varchar(max),tApi int, api varchar(max),observacion varchar(max),B64 int,B64Name varchar(max),idFormato int,indexAPI int)
            declare @_rsp table(idProspecto int, idPregunta int,idFormulario int,idEncuestaR int, ob int, observacion2 varchar(max),tApi int, api varchar(max),observacion varchar(max),B64 int,B64Name varchar(max),idFormato int)
            declare @formulariosRespondidos table(idFormularioR int identity(1,1),idFormulario int,idProspecto int,fechaRegistro datetime,totalCampos int)
            declare @api int, @b64f int,@img int,@file int

            select
                @api=iif(tipo='api',idFormato,@api),
                @b64f=iif(tipo='b64f',idFormato,@b64f),
                @img=iif(tipo='img',idFormato,@img),
                @file=iif(tipo='file',idFormato,@file)
            from formatos
            where tipo in('api','b64f','img','file')

            declare @pp table(# int, idProspecto int, respuestas nvarchar(max))
            insert @pp
            select
                # = row_number() over(order by(select 1)),
                idProspecto,respuestas
            from prospectos
            
            where idGestor = @idG and  (etapa in (1,3) ) and (@parcial = 0 or (@parcial in(-1,-3) and actualizado = 1))

            declare @totalPP int = (select count(1) from @pp),@indexPP int = 1

            while @indexPP <= @totalPP begin
                declare @idProspecto int = (select idProspecto from @pp where # = @indexPP)
                declare @fr table(# int,idFormulario int,fecha datetime, rsp nvarchar(max))
                declare @dat nvarchar(max) = (select respuestas from prospectos where idProspecto = @idProspecto);

                insert @fr select 
                    #=row_number() over(order by (select 1)), 
                    s.idFormulario,
                    s.fechaCreacion,
                    s.respuestas 
                from openjson(@dat)with(idFormulario int,fechaCreacion datetime,respuestas nvarchar(max)as json)s
                inner join formularios f on f.idFormulario = s.idFormulario
                where coalesce(f.web,0)=0
                
                declare @totalF int = (select count(1) from @fr),@indexF int = 1

                while @indexF <= @totalF begin
                    declare @idFormulario int = null, @fechaRegistro datetime = null
                    select
                        @idFormulario = idFormulario,
                        @fechaRegistro = fecha
                    from @fr where # = @indexF

                    insert @_rsp
                    select
                        idProspecto = @idProspecto,
                        p.idPregunta,
                        idFormulario = @idFormulario,
                        idEncuestaR = @idProspecto,
                        ob = iif(dbo.notEmpty(t.observacion2) is null,0,1),
                        t.observacion2,
                        tApi = iif(p.idFormato=@api,1,0),
                        api,
                        observacion = iif(p.idFormato in(@api,@b64f,@img,@file),t.observacion,null),
                        B64 = iif(p.idFormato in(@b64f,@img,@file),1,0),
                        B64Name = iif(p.idFormato in(@b64f,@img,@file),p.pregunta,null),
                        p.idFormato
                    from openjson((select rsp from @fr where # = @indexF))with(idPregunta int, observacion varchar(max), api varchar(max),observacion2 varchar(max)) t
                    inner join preguntas p on p.idPregunta = t.idPregunta and p.estado = 1
                    --where t.observacion is not null

                    insert @temp select *,0 as indexAPI from @_rsp where (dbo.notEmpty(observacion2) is not null or idFormato in(@api,@b64f,@img,@file))

                    insert @formulariosRespondidos
                    (idFormulario,idProspecto,fechaRegistro,totalCampos)
                    select
                        idFormulario = @idFormulario,
                        idProspecto = @idProspecto,
                        fechaRegistro = @fechaRegistro,
                        totalCampos = (select count(1) from @_rsp)

                    delete from @_rsp
                    set @indexF +=1
                end

                delete from @fr
                set @indexPP +=1
            end

            declare @max int = coalesce((select MAX(#) from @temp),0)
            update @temp set indexAPI = @max + # where tApi = 1
            update @temp set tApi = 1 , B64 = 0 where B64 = 1 and tApi = 0 and observacion not like '%/img_%'
            update @temp set B64 = 0 where B64 = 1 and observacion is null
        set nocount off

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
                        PCLToken = format(convert(datetime,@PCL_Token),'yyyy-MM-dd HH:mm:ss'),
                        resetDB2 = iif(@tokenDiffPCL>0,1,0),
                        @version as versionDLL,
                        g.idGestor,
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
                        where gg.idGrupo = g.idGrupo and @parcial = 0 for JSON PATH, WITHOUT_ARRAY_WRAPPER
                    )as nvarchar(max))
                )as ds
            ),
            app = isNull((select json_query(@app)),'{}'),
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
            formatos = json_query(iif(@parcial = 0 and @tokenDiffPCL > 0,i.formatos,null)),
            encuestas = json_query(iif(@parcial = 0 and @tokenDiffPCL > 0,i.encuestas,null)),
            actividades = json_query(iif(@parcial = 0,i.actividades,null)),
            detalleActividades = json_query(iif(@parcial = 0,i.detalleActividades,null)),
            reacciones = json_query(iif(@parcial = 0,i.reacciones,null)),
            motivoActividades = json_query(iif(@parcial = 0,i.motivoActividades,null)),
            campanias = json_query(iif(@parcial = 0,i.campanias,null)),
            prospectos = isNull((SELECT 
                    p.idProspecto,
                    p.idCredito,
                    cl.nombre as nombreCr,
                    format(p.fecha,'dd MMM yyyy','es-ES')as fecha,
                    datediff(day,p.fecha,getdate())as diasProspecto,
                    formulariosR = (select
                            idFormularioR,
                            idFormulario,
                            fechaRegistro = format(fechaRegistro,'dd MMM yyyy',@cultureInfo),
                            horaRegistro = format(fechaRegistro,'HH:mm',@cultureInfo),
                            totalCampos
                        from @formulariosRespondidos
                        where idProspecto = p.idProspecto for JSON PATH
                    ),
                    p.latitud,
                    p.longitud,
                    p.latitudNegocio,
                    p.longitudNegocio,
                    p.d1,
                    p.idEncuesta,
                    p.idGrupoAdesco,
                    p.renovado,
                    p.encabezado,
                    iif(p.nDoc is null,iif(cl.nDoc is null,cast(p.idProspecto as varchar(max)),cl.nDoc),p.nDoc) as nDoc, 
                    p.extra,
                    p.edad,
                    p.d2,
                    p.d3,
                    p.d4,
                    p.rechazado,
                    (case when p.isNew=1 then 1 else 0 end) isNew,
                    isNull((select B64Name as pregunta,observacion as respuesta,idFormulario,idPregunta from @temp t where t.idProspecto = p.idProspecto and B64 =1 for json path),'[]')as b64Url,
                    isNull((select idPregunta,idEncuestaR,observacion2 from @temp t where t.idProspecto = p.idProspecto and ob=1 for json path),'[]') as observaciones,
                    isNull((select idPregunta,idEncuestaR,api,observacion from @temp t where t.idProspecto = p.idProspecto and tApi=1 and ob=0 for json path),'[]') as api,
                    (select *from(
                        select 'Prospecto' as Actividad,
                        (select * from(
                            select 'Tipo' as 'name',cast(e.nombre as varchar(max)) as 'value'
                            union select 'Etapa' as 'name',(select etapa from etapasGestionProspecto where idEtapaG = p.etapa) as 'value'
                        ) as dt for json path) as params
                    )as ds for json path, WITHOUT_ARRAY_WRAPPER) as popup
                FROM prospectos p
                inner join encuestas e on e.idEncuesta = p.idEncuesta
                left join creditos c on c.idCredito = p.idCredito
                left join clientes cl on cl.idCliente = c.idCliente
                where p.idGestor = @idG and (p.etapa in (1,2,3) or (p.etapa=6 and @showRefused = 1 and cast(p.fecha as date) = cast(getdate() as date))) and (@parcial = 0 or (@parcial in(-1,-3) and p.actualizado = 1)) for JSON PATH),'[]'
            ),
            menu = (select
                    m.codigo as cd,
                    m.categoria as ct,
                    m.menu as mn
                from menuMovil m
                inner join gruposMenuMovil gm on gm.idMenu = m.idMenu
                where gm.idGrupo = g.idGrupo and m.estado = 1 and gm.estado = 1 and @parcial = 0 FOR JSON PATH
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
                where dt.resultado is not null and @parcial = 0 for JSON PATH
            ),'[]'),
            confRankings = (select json_query(g.clasificacion)),
            organizacionesLocales = json_query (isNull(iif(@parcial =0, (select
                    idOrganizacion,
                    nombre as organizacion,
                    totalMora,
                    totalDesembolso,
                    totalVenceHoy,
                    totalRenovacion,
                    totalPrioridad
		from organizacionesLocales_v
		where idGestor = g.idGestor  for JSON PATH
	    ),null),'[]')),
            grupos = isNull((select distinct
                ga.idGrupoAdesco,
                ga.nombre ,
                ga.totalMora,
                ga.totalDesembolso,
                ga.totalVenceHoy,
                ga.totalRenovacion,
                ga.totalVencimiento,
                ga.totalPrioridad,
                ga.codigoGrupo,
                ga.idEstado,
                ga.representante,
                ga.latitud,
                ga.longitud,
                ga.imgReferencia,
                ga.pendienteReferencia,
                ga.table_ext,
                ga.emergentes as popup,
                ga.infoE as result,
                ga.domicilioReunion,
                ga.gestionado,
                isNull((select idImagen,url,casa,idCliente,idFiador,idGrupo from imagenesGPS where idGrupo = ga.idGrupoAdesco and estado = 1 for JSON PATH),'[]')as geoPic
                from gruposAdesco_v ga
                where idGestor = g.idGestor and (@parcial = 0 or (@parcial in(-2,-3) and ga.actualizado = 1)) for JSON PATH
            ),'[]'),
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
				where diasPromesa between -16 and 4 and montoPagado < montoPrometido and idGestor = g.idGestor and @parcial = 0 for JSON PATH
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
                where cc.idGestor = g.idGestor and @parcial = 0 for JSON PATH
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
                and estado = 1 and r.idGestor = g.idGestor and @parcial = 0 for JSON PATH
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
                where r.fecha = DATEADD(day, -1, cast(getdate() as date)) and estado = 1 and r.idGestor = g.idGestor and @parcial = 0 for JSON PATH
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
                where r.fecha = cast(GETDATE()as date) and estado = 1 and r.idGestor = g.idGestor and @parcial = 0 for JSON PATH
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
                where f.idGestor = g.idGestor and @parcial = 0 for JSON PATH),'[]'
            ),
            incidencias = json_query('[]'),
            carteraClientes = isNull((select
                idCliente,
                iif(diasCapitalMora>0,diasCapitalMora,10000) as indexP,
                c.codigo as codigoCliente,
                cliente,
                direccion,
                telefono,
                c.idCredito,
                referencia,
                valorCuota,
                diasCapitalMora,
                fechaVencimiento,
                capitalMora,
                ultimaFechaPago,
                prioridad,
                prioridadAgencia,
                diasPrioridad,
                diasPrioridadAgencia,
                idOrganizacion,
                promesas,
                diasPromesa,
                porDesertar,
                desertado,
                fechaCancelacion,
                seguimiento,
                etapaSeguimiento,
                renovacion,
                diasUltimoSeguimiento,
                diasPorDesertar,
                fechaDesercion,
                diasDesertado,
                desembolso,
                diasDesembolso,
                rtrim(lineaCredito)as lineaCredito,
                saneado,
                latitud,
                longitud,
                latitudNegocio,
                longitudNegocio,
                imgCasa,
                imgNegocio,
                pendienteCasa,
                pendienteNegocio,
                idGrupoAdesco,
                cuotaVenceHoy,
                pagoParaEstarAlDia,
                DUG,
                UG,
                enMora,
                gestionado,
                cobroPreventivo,
                titular,
                vencimiento,
                f1,
                iif(idVisita is not null,1,0) as visita,
                a.actividad as actividadVisita,
                format(vr.fechaVisita,'dd MMM yyyy',@cultureInfo) as fechaVisita,
                vr.diasVisita,
                iif(vr.diasVisita between -@ddVen and @ddVig,1,0) as visitaPopup,
                cast((c.d1)as nvarchar(max)) as d1,
                isNull((select idImagen,url,casa,idCliente,idFiador,idGrupo from imagenesGPS where idCliente = c.idCliente and estado = 1 for JSON PATH),'[]')as geoPic,
                emergentes as popup,
                infoE as result,
                table_ext
                from cartera_v c
                left join VisitasReprogramadas vr on vr.idCredito = c.idCredito and vr.fechaVisita >=  DATEADD(day,-@ddVen,cast(GETDATE() as date)) and realizada = 0 and vr.idCampania is null
                left join actividades a on a.idActividad = vr.idActividad
                where c.idGestor = g.idGestor and @parcial = 0 for JSON PATH
            ),'[]')
        from usuarios u
        inner join gestores g on g.idGestor = u.idGestor
        inner join inicioSesionJS i on i.ID = 1
        where u.idUsuario = @idUsuario for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data

        update prospectos set actualizado = 0 where actualizado = 1 and idGestor = @idG
        update prospectos set isNew=0 where idGestor = @idG and isNew=1
        update t set actualizado = 0 from gruposAdesco t
        inner join gruposAdesco_v ga on ga.idGrupoAdesco = t.idGrupoAdesco
        where ga.idGestor = @idG and ga.actualizado = 1
    end
    else begin
        select (select 1 as error,'Usuario o contraseña incorrecto' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data
    end
end
