CREATE PROCEDURE [dbo].[loginConfExtra](@idUsuario int,@parcial int = 0,@PCLToken varchar(50) = null) AS
BEGIN
    declare @showRefused int
    select
        @showRefused = showRefused
    from openjson((select conf from parametros))with(showRefused int)

    declare @PCL_Token varchar(max) = (select PCLToken from parametros where idParametro = 1)
    declare @tokenDiffPCL int = iif(@PCLToken is null or @PCLToken = '',1, datediff(minute,@PCLToken,@PCL_Token))

    if @idUsuario is not null begin
        select (select
            0 as error,
            'Verificado' as message,
            encuestas = iif(@parcial = 0 and @tokenDiffPCL > 0,1,0),
            prospectos = isNull((SELECT 
                    p.idProspecto
                FROM prospectos p
                inner join encuestas e on e.idEncuesta = p.idEncuesta
                left join creditos c on c.idCredito = p.idCredito
                left join clientes cl on cl.idCliente = c.idCliente
                where p.idGestor = g.idGestor and (p.etapa in (1,2,3) or (p.etapa=6 and @showRefused = 1 and cast(p.fecha as date) = cast(getdate() as date))) and (@parcial = 0 or (@parcial in(-1,-3) and p.actualizado = 1)) for JSON PATH
            ),'[]'),
            organizacionesLocales = json_query (isNull(iif(@parcial = 0, (select
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
            ),'[]')
        from usuarios u
        inner join gestores g on g.idGestor = u.idGestor
        where u.idUsuario = @idUsuario for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
    end
    else begin
        select (select 1 as error,'Usuario o contraseña incorrecto' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data
    end
end
