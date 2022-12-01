CREATE procedure [dbo].[getInfoExtend](@idGestor int,@idCredito int,@idCliente int) as 
begin
--SP por empresa esta es Default
    declare @cultureInfo varchar(max) = dbo.fParameters('cultureInfo')

    if @idGestor is not null begin
        select (select 
            0 as error,
            'Correcto' as message,
            (select json_query((select concat('[',

                    (select
                            9 as 'tipo',
                            'HISTORIAL DE GESTIONES' as 'name',
                            (select (
                                select json_query((select concat('[',
										(select
												'Fecha' as 'name',
												format(ra.fecha,'dd MMM yyyy',@cultureInfo) as 'value',
												'#ffffff' as 'colorT'
										for JSON PATH, WITHOUT_ARRAY_WRAPPER),',',
										(select
												'Actividad' as 'name',
												coalesce(ac2.actividad,ac.actividad) as 'value',
												'#ffffff' as 'colorT'
										for JSON PATH, WITHOUT_ARRAY_WRAPPER),',',
										(select
												'Tipo' as 'name',
												iif(ac2.idActividad is null,N'⛟',N'✆') as 'value',
												'#ffffff' as 'colorT'
										for JSON PATH, WITHOUT_ARRAY_WRAPPER),',',
										(select
												'Contactado' as 'name',
												iif(da.contactado = 1,N'👍',N'👎') as 'value',
												'#ffffff' as 'colorT'
										for JSON PATH, WITHOUT_ARRAY_WRAPPER),',',
										(select
												'Resultado' as 'name',
												rc.reaccion as 'value',
												'#ffffff' as 'colorT'
										for JSON PATH, WITHOUT_ARRAY_WRAPPER),',',
										(select
												'Motivo' as 'name',
												iif(cast(ma.motivo as varchar(max)) = '' or ma.motivo is null,'--',ma.motivo) as 'value',
												'#ffffff' as 'colorT'
										for JSON PATH, WITHOUT_ARRAY_WRAPPER),',',
										(select
												'Observacion' as 'name',
												iif(cast(ra.observacion as varchar(max)) = '' or ra.observacion is null,'--',ra.observacion) as 'value',
												'#ffffff' as 'colorT'
										for JSON PATH, WITHOUT_ARRAY_WRAPPER)
                                ,']') ))        
                            ) as columns from registroActividades ra
                            inner join actividades ac on ac.idActividad = ra.idActividad
                            left join reacciones rc on rc.idReaccion = ra.idReaccion
                            left join motivoActividades ma on ra.idMotivo = ma.idMotivo
                            left join detalleActividades da on da.idDetalle = ra.idDetalle
                            left join actividades ac2 on ac2.idActividad = rc.idActividad
                            left join creditos cr on cr.idCredito = ra.idCredito
                            where cr.idCredito = @idCredito order by ra.idRegistroActividad desc
                            for JSON PATH) as 'rows' 
                    for JSON PATH, WITHOUT_ARRAY_WRAPPER)

            ,']') ))) as tables
        from usuarios u
        where u.idGestor = @idGestor
        for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
    end 
    else begin 
        select (select 1 as error,'Error al obtener datos' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data
    end
end