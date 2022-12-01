CREATE PROCEDURE [dbo].[crearIndicadoresGestor] as 
begin
    -----calculo
    if(object_id('tempdb..#co') is not null)drop table #co
    select g.idGestor,ta.TA,tna.TNA,(ta.TA+tna.TNA) as t
    into #co from gestores g
    inner join (select  idGestor, count(1) as TA
        from (
            select  g.idGestor, ga.idGrupoAdesco
            from gestores g 
            left join creditosAsignados ca on ca.idGestor = g.idGestor and ca.asignado = 1
            left join creditos c on c.idCredito = ca.idCredito and c.idEstado = 1
            left join gruposAdesco ga on ga.idGrupoAdesco = c.idGrupo
            where g.estado = 1
            group by g.idGestor,ga.idGrupoAdesco
        ) as dt
        group by idGestor) as ta on ta.idGestor = g.idGestor
    inner join (select g.idGestor,sum(iif(p.idProspecto is null,0,1)) as TNA
        from gestores g
        left join prospectos p on p.idGestor = g.idGestor and p.etapa in (1,2,3)
        where g.estado = 1
    group by  g.idGestor) as tna on tna.idGestor = g.idGestor

    if(object_id('tempdb..#con') is not null)drop table #con
    select 
        idGestor,
        sum(iif(consumo > 0,1,0)) as CC, 
        sum(iif(consumo = 0,1,0)) as SC,
        sum(iif(idGrupoAdesco is null,0,1)) as t
    into #con from (select  g.idGestor, ga.idGrupoAdesco,sum(c.consumo) as consumo
        from gestores g 
        left join creditosAsignados ca on ca.idGestor = g.idGestor and ca.asignado = 1
        left join creditos c on c.idCredito = ca.idCredito and c.idEstado = 1
        left join gruposAdesco ga on ga.idGrupoAdesco = c.idGrupo
        where g.estado = 1
        group by g.idGestor,ga.idGrupoAdesco) as dt
    group by idGestor

    --indicador comercios activos afiliados por gestor
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        distinct
        g.idGestor,
        i.idIndicador
    from gestores g
    inner join indicadores i on i.codigo = 'CAA'
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = i.idIndicador
    where ig.idIndicadorG is null and g.estado = 1  
    update t set 
        t.valor = s.TA,
        t.meta = s.t
    from indicadoresGestor t
    inner join indicadores i on i.idIndicador = t.idIndicador and i.codigo = 'CAA'
    inner join #co as s on s.idGestor = t.idGestor 

    --indicador comercios no afiliados por gestor
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        distinct
        g.idGestor,
        i.idIndicador
    from gestores g
    inner join indicadores i on i.codigo = 'CNA'
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = i.idIndicador
    where ig.idIndicadorG is null and g.estado = 1
    update t set 
        t.valor = s.TNA,
        t.meta = s.t
    from indicadoresGestor t
    inner join indicadores i on i.idIndicador = t.idIndicador and i.codigo = 'CNA'
    inner join #co as s on s.idGestor = t.idGestor 

    --indicador comercios activos afiliados por zona con consumo
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        distinct
        g.idGestor,
        i.idIndicador
    from gestores g
    inner join indicadores i on i.codigo = 'CAC'
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = i.idIndicador
    where ig.idIndicadorG is null and g.estado = 1 
    update t set 
        t.valor = s.CC,
        t.meta =  s.t
    from indicadoresGestor t
    inner join indicadores i on i.idIndicador = t.idIndicador and i.codigo = 'CAC'
    inner join #con as s on s.idGestor = t.idGestor 

    --indicador comercios activos afiliados por zona sin consumo
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        distinct
        g.idGestor,
        i.idIndicador
    from gestores g
    inner join indicadores i on i.codigo = 'CASC'
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = i.idIndicador
    where ig.idIndicadorG is null and g.estado = 1 
    update t set 
        t.valor = s.SC,
        t.meta =  s.t
    from indicadoresGestor t
    inner join indicadores i on i.idIndicador = t.idIndicador and i.codigo = 'CASC'
    inner join #con as s on s.idGestor = t.idGestor 

    --indicador monto de venta por zona
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        distinct
        g.idGestor,
        i.idIndicador
    from gestores g
    inner join indicadores i on i.codigo = 'CMV'
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = i.idIndicador
    where ig.idIndicadorG is null and g.estado = 1 
    update t set 
        t.valor = coalesce(s.consumo,0)
    from indicadoresGestor t
    inner join indicadores i on i.idIndicador = t.idIndicador and i.codigo = 'CMV'
    inner join (select  g.idGestor,sum(c.consumo) as consumo
        from gestores g 
        left join creditosAsignados ca on ca.idGestor = g.idGestor and ca.asignado = 1
        left join creditos c on c.idCredito = ca.idCredito and c.idEstado = 1
        left join gruposAdesco ga on ga.idGrupoAdesco = c.idGrupo
        where g.estado = 1
        group by g.idGestor
    ) as s on s.idGestor = t.idGestor 

    ----------------------indicador facturacion
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        g.idGestor,
        11
    from gestores g
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = 11
    where ig.idIndicadorG is null
    insert metasGestorIndicador(idGestor,idIndicador)
    select 
        g.idGestor,
        11
    from gestores g
    left join metasGestorIndicador ig on ig.idGestor = g.idGestor and ig.idIndicador = 11
    where ig.idMetaG is null
    update indicadoresGestor set valor = 0 where idIndicador = 11
    update t set 
        t.valor = s.consumo
    from indicadoresGestor t
    inner join (select 
        ca.idGestor ,sum(c.consumo)  as consumo
        from creditosAsignados ca inner join creditos c on c.idCredito = ca.idCredito and c.idEstado = 1 and ca.asignado = 1
        group by ca.idGestor 
    ) as s on s.idGestor = t.idGestor
    where t.idIndicador = 11

    ----------------------indicador comercios
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        g.idGestor,
        12
    from gestores g
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = 12
    where ig.idIndicadorG is null
    insert metasGestorIndicador(idGestor,idIndicador)
    select 
        g.idGestor,
        12
    from gestores g
    left join metasGestorIndicador ig on ig.idGestor = g.idGestor and ig.idIndicador = 12
    where ig.idMetaG is null
    update indicadoresGestor set valor = 0 where idIndicador = 12
    update t set 
        t.valor = s.comercios
    from indicadoresGestor t
    inner join (select idGestor,count(1) as comercios from (
            select 
                ca.idGestor ,c.idGrupo
            from creditosAsignados ca 
            inner join creditos c on c.idCredito = ca.idCredito and c.idEstado = 1 and ca.asignado = 1
            group by ca.idGestor ,c.idGrupo
        ) as dt 
        group by idGestor
    ) as s on s.idGestor = t.idGestor
    where t.idIndicador = 12

    ----------------------indicador mpos
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        g.idGestor,
        13
    from gestores g
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = 13
    where ig.idIndicadorG is null
    insert metasGestorIndicador(idGestor,idIndicador)
    select 
        g.idGestor,
        13
    from gestores g
    left join metasGestorIndicador ig on ig.idGestor = g.idGestor and ig.idIndicador = 13
    where ig.idMetaG is null
    update indicadoresGestor set valor = 0 where idIndicador = 13
    update t set 
        t.valor = s.mpos
    from indicadoresGestor t
    inner join (select 
        ca.idGestor ,sum(c.mpos)  as mpos
        from creditosAsignados ca inner join creditos c on c.idCredito = ca.idCredito and c.idEstado = 1
        group by ca.idGestor 
    ) as s on s.idGestor = t.idGestor
    where t.idIndicador = 13

    ----------------------indicador numeroTransacciones
    insert indicadoresGestor(idGestor,idIndicador)
    select 
        g.idGestor,
        14
    from gestores g
    left join indicadoresGestor ig on ig.idGestor = g.idGestor and ig.idIndicador = 14
    where ig.idIndicadorG is null
    insert metasGestorIndicador(idGestor,idIndicador)
    select 
        g.idGestor,
        14
    from gestores g
    left join metasGestorIndicador ig on ig.idGestor = g.idGestor and ig.idIndicador = 14
    where ig.idMetaG is null
    update indicadoresGestor set valor = 0 where idIndicador = 14
    update t set 
        t.valor = s.numeroTransacciones
    from indicadoresGestor t
    inner join (select 
        ca.idGestor ,sum(c.numeroTransacciones)  as numeroTransacciones
        from creditosAsignados ca inner join creditos c on c.idCredito = ca.idCredito and c.idEstado = 1 and ca.asignado = 1
        group by ca.idGestor 
    ) as s on s.idGestor = t.idGestor
    where t.idIndicador = 14
end
