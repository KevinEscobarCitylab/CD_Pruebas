CREATE PROCEDURE [dbo].[loginGetCartera](@idUsuario int) AS
BEGIN
    declare @cultureInfo varchar(10),@ddVen int,@ddVig int
    select
        @cultureInfo = cultureInfo,
        @ddVen = visRepVen,
        @ddVig = visRepVig
    from openjson((select conf from parametros))with(visRepVen int,visRepVig int, cultureInfo varchar(10))
    
    if @idUsuario is not null begin
        declare @idG int = (select idGestor from usuarios where idUsuario = @idUsuario)

        select (select
            0 as error,
            'Verificado' as message,
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
                where c.idGestor = u.idGestor for JSON PATH
            ),'[]')
        from usuarios u
        where u.idUsuario = @idUsuario for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
    end
    else begin
        select (select 1 as error,'Usuario o contraseña incorrecto' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data
    end
end
