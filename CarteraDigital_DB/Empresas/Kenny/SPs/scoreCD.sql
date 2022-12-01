create   PROCEDURE scoreCD as 
begin
    declare @fecha1 date = dateadd(year,-1,getdate()) 
    declare @fecha2 date = getdate()
    declare @cob int = (select idActividad from actividades where codigo = 'COB')
    declare @cobFiador int = (select idActividad from actividades where codigo = 'CFD')
    declare @datelimir date = (select DATEADD(YEAR,-3,GETDATE()))

    --update reset 
        update clientes set promedioGestionAlSalirMora = 0 where promedioGestionAlSalirMora != 0
        update clientes set numGestionesCob = 0 where numGestionesCob != 0
        update clientes set avgGestionesCob = 0 where avgGestionesCob != 0
        update clientes set acuerdosCumplidos = 0 where acuerdosCumplidos != 0
        update agencias set porceMora = 0 where porceMora != 0
        update agencias set diasMora = 0 where diasMora != 0
        update agencias set promedioGestion = 0 where promedioGestion != 0
        update agencias set notaCD = 0 where notaCD != 0
        update agencias set porceMontoMora30 = 0 where porceMontoMora30 != 0
        update gestores set promedioGestionesClientesMora = 0 where promedioGestionesClientesMora != 0
        update gestores set acuerdosCumplidos = 0 where acuerdosCumplidos != 0

    --update variables base
        update gs set
            gs.acuerdosCumplidos = iif(numCliente = 0,0,(acuerdosPagados * 100.0) /numCliente)
        from(
            select 
                idGestor,
                sum(iif(montoReal >= montoPrometido,1,0)) acuerdosPagados,
                count(1) numCliente
            from promesasPago_v 
            where fechaGestion between @fecha1 and @fecha2
            group by idGestor
        ) dt 
        inner join gestores gs on gs.idGestor = dt.idGestor

        update g set
            g.porcMora3H = iif(totalMora = 0,0, (TotalMoraMayor3 * 100.0 / totalMora))
        from gestores g 
        inner join (
            select 
                idGestor
                ,sum(IIF(diasCapitalMora>3,1,0)) as TotalMoraMayor3
                ,sum(1) as totalMora
            from (
                select 
                    hcr.idCredito,
                    hca.idGestor,
                    max(hcr.diasCapitalMora) as diasCapitalMora
                from historialCreditosAsignados hca
                inner join creditos cr on hca.idcredito = cr.idcredito
                inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
                where (fechaIn between @fecha1 and @fecha2 or 
                    fechaOut between @fecha1 and @fecha2 or
                    @fecha1 between fechaIn and fechaOut or
                    @fecha2 between fechaIn and fechaOut or
                    (fechaIn<=@fecha1 and fechaIn <= @fecha2 and fechaOut is null)) and
                    hcr.fecha between @fecha1 and @fecha2 and hcr.mora = 1
                group by hcr.idCredito,hca.idGestor
            ) as dt
            group by idGestor
        ) as d on d.idGestor = g.idGestor

        update g set 
            g.AVGDiasMora = iif(diasCapitalMora = 0,0, (diasCapitalMora * 1.0 / credMora))
        from gestores g 
        inner join (
            select 
                ca.idGestor
                ,sum(c.diasCapitalMora) as diasCapitalMora
                ,sum(1) as credMora
            from creditosAsignados ca
            inner join creditos c on c.idCredito = ca.idCredito 
            where ca.asignado = 1 and c.diasCapitalMora > 0
            group by ca.idGestor
        ) as dt on dt.idGestor = g.idGestor

        update gs set
            gs.promedioGestionesClientesMora = cast(round(convert(decimal, dt3.numGestiones) / dt3.numCreditosAtrasados,4) as float (3))
        from(
            select 
                dt2.idGestor,
                count(1) numCreditosAtrasados,
                sum(dt2.numGestiones) numGestiones
            from(
                select 
                    dt.idGestor,
                    dt.idCredito,
                    count(1) numGestiones
                from (
                    select 
                        hcr.idCredito,
                        hca.idGestor,
                        max(hcr.mora) as mora
                    from historialCreditosAsignados hca
                    inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
                    inner join gestores g on g.idGestor = hca.idGestor
                    inner join agencias ag on ag.idAgencia = g.idAgencia 
                    where (fechaIn between @fecha1 and @fecha2 or 
                            fechaOut between @fecha1 and @fecha2 or
                            @fecha1 between fechaIn and fechaOut or
                            @fecha2 between fechaIn and fechaOut or
                            (fechaIn<=@fecha1 and fechaIn <= @fecha2 and fechaOut is null)) and
                            hcr.fecha between @fecha1 and @fecha2 and g.estado = 1 and g.idGrupo = dbo.fGrupo('ASC') 
                    group by hcr.idCredito,hca.idGestor
                ) dt
                left join registroActividades ra on ra.idCredito = dt.idCredito and ra.idGestor = dt.idGestor
                left join reacciones re on re.idReaccion = ra.idReaccion
                left join detalleActividades da on da.idDetalle = ra.idDetalle
                where dt.mora = 1 and (ra.idActividad in (@cob,@cobFiador) or re.idActividad in (@cob,@cobFiador)) and ra.fecha between @fecha1 and @fecha2
                group by dt.idGestor,dt.idCredito,dt.mora
            ) dt2
            group by dt2.idGestor
        ) dt3
        inner join gestores gs on gs.idGestor = dt3.idGestor

        if(object_id('tempdb..#ga') is not null)drop table #ga
        select 
            idAgencia,sum(total) as total,sum(mora) as mora, sum(diasCapitalMora) as diasMora,sum(mora30) as mora30,sum(totalCartera) as totalCartera
        into #ga from (
            select 
                a.idAgencia,
                c.idCredito,
                1 as total,
                iif(c.diasCapitalMora > 0,1,0) as mora,
                c.diasCapitalMora
                ,iif(c.diasCapitalMora > 30,c.pagoParaEstarAlDia,0) as mora30
                ,c.deudaTotal as totalCartera
            from agencias a
            inner join gestores g on g.idAgencia = a.idAgencia
            inner join creditosAsignados ca on ca.idGestor = g.idGestor and ca.asignado = 1
            inner join creditos c on c.idCredito = ca.idCredito 
            where c.idEstado = 1
            group by a.idAgencia,c.idCredito,c.diasCapitalMora,c.pagoParaEstarAlDia,c.deudaTotal
        ) as dt
        group by idAgencia

        update a set
            a.porceMora = (ga.mora * 100) / CONVERT(decimal(10,2), ga.total) ,
            a.diasMora = iif(ga.mora = 0 or ga.mora = 0,CONVERT(decimal(10,2),0) ,(ga.diasMora * 100) / CONVERT(decimal(10,2), ga.mora))
            ,a.porceMontoMora30 = iif(ga.totalCartera = 0,CONVERT(decimal(20,2),0), ga.mora30 * 100 / CONVERT(decimal(20,2), ga.totalCartera))
        from agencias a
        inner join #ga ga on ga.idAgencia = a.idAgencia 

        update gs
        set
            gs.promedioGestion = iif(dt3.idAgencia is not null,cast(round(convert(decimal, dt3.numGestiones) / dt3.numCreditosAtrasados,4) as float (3)),0)
        from agencias gs
        inner join (
            select 
                dt2.idAgencia,
                count(1) numCreditosAtrasados,
                sum(dt2.numGestiones) numGestiones
            from(
                select 
                    dt.idAgencia,
                    dt.idCredito,
                    count(1) numGestiones
                from (
                    select 
                        hcr.idCredito,
                        g.idAgencia,
                        max(hcr.mora) as mora
                    from historialCreditosAsignados hca
                    inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
                    inner join gestores g on g.idGestor = hca.idGestor
                    where (fechaIn between @fecha1 and @fecha2 or 
                            fechaOut between @fecha1 and @fecha2 or
                            @fecha1 between fechaIn and fechaOut or
                            @fecha2 between fechaIn and fechaOut or
                            (fechaIn<=@fecha1 and fechaIn <= @fecha2 and fechaOut is null)) and
                            hcr.fecha between @fecha1 and @fecha2 
                    group by hcr.idCredito,g.idAgencia
                ) dt
                left join registroActividades ra on ra.idCredito = dt.idCredito
                left join reacciones re on re.idReaccion = ra.idReaccion
                left join detalleActividades da on da.idDetalle = ra.idDetalle
                where dt.mora = 1 and (ra.idActividad in (@cob,@cobFiador) or re.idActividad in (@cob,@cobFiador)) and ra.fecha between @fecha1 and @fecha2
                group by dt.idAgencia,dt.idCredito
            ) dt2
            group by dt2.idAgencia
        ) dt3 on gs.idAgencia = dt3.idAgencia

        update cl set 
            promedioGestionAlSalirMora = iif(mo.idCliente is null,0,(g.totalGMora *1.0 / mo.vezMora))
        from clientes cl
        inner join (
            select 
                cl.idCliente
                ,sum(1) as totalGMora
            from clientes cl
            inner join creditos cr on cr.idCliente = cl.idCliente
            left join registroActividades ra on ra.idCredito = cr.idCredito
            left join reacciones re on re.idReaccion = ra.idReaccion
            where (ra.idActividad in (@cob,@cobFiador) or re.idActividad in (@cob,@cobFiador)) and ra.fecha >= @datelimir
            group by cl.idCliente
        ) as g on g.idCliente = cl.idCliente
        left join (
            select  
                cl.idCliente,
                sum(1) as vezMora
            from clientes cl
            inner join creditos cr on cr.idCliente = cl.idCliente
            inner join historialCredito hc1 on hc1.idCredito = cr.idCredito
            inner join historialCredito hc2 on hc2.idCredito = cr.idCredito
            where hc1.fecha >= @datelimir and hc2.fecha >= @datelimir  and hc1.mora = 0 and hc2.mora = 1 and hc2.fecha = DATEADD(DAY,1,hc1.fecha)
            group by cl.idCliente
        ) as mo on mo.idCliente = cl.idCliente

        if(OBJECT_ID('tempdb..#conteoGestiones') is not null) drop table #conteoGestiones
        select 
            cr.idCredito,
            cr.idCliente,
            cr.idEstado,
            count(1) as numeroGestiones
        into #conteoGestiones from creditos cr
        left join registroActividades r on cr.idCredito = r.idCredito
        left join reacciones c on r.idReaccion = c.idReaccion
        where (r.idActividad in (@cob,@cobFiador) or c.idActividad in (@cob,@cobFiador))
        group by cr.idCredito,cr.idCliente,cr.idEstado

        update cl
        set
            cl.numGestionesCob = iif(gs.idCliente is not null,gs.numeroGestiones,0)
        from clientes cl 
        left join (
            select 
                dt3.idCliente,
                sum(dt3.numeroGestiones) numeroGestiones
            from (	
                select
                    dt.idCliente,
                    dt.numeroGestiones
                from #conteoGestiones dt
                where dt.idEstado in (1,3)
                union all
                select
                    dt2.idCliente,
                    dt2.numeroGestiones
                from(
                    select
                        ROW_NUMBER() over(partition by dt.idCliente order by dt.idCredito desc) id,
                        dt.idCliente,
                        dt.idCredito,
                        dt.numeroGestiones
                    from #conteoGestiones dt
                    where dt.idEstado = 2
                ) dt2
                where dt2.id = 1
            ) dt3 group by dt3.idCliente
        ) gs on cl.idCliente = gs.idCliente

        set @fecha1 = dateadd(YEAR,-3,getdate())

        update cl
        set
            cl.avgGestionesCob = iif(dt3.idcliente is not null,cast(round(convert(decimal, dt3.numGestiones) / dt3.numCreditos,2) as float (2)),0)
        from clientes cl
        left join (
            select
                dt2.idcliente,
                count(1) numCreditos,
                sum(numGestiones) numGestiones
            from(
                select 
                    dt.idcliente,
                    dt.idCredito,
                    count(1) numGestiones
                from (
                    select 
                        hcr.idCredito,
                        cr.idcliente 
                    from historialCreditosAsignados hca
                    inner join creditos cr on hca.idcredito = cr.idcredito
                    inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
                    where (fechaIn between @fecha1 and @fecha2 or 
                            fechaOut between @fecha1 and @fecha2 or
                            @fecha1 between fechaIn and fechaOut or
                            @fecha2 between fechaIn and fechaOut or
                            (fechaIn<=@fecha1 and fechaIn <= @fecha2 and fechaOut is null)) and
                            hcr.fecha between @fecha1 and @fecha2 
                    group by hcr.idCredito,cr.idCliente
                ) dt
                left join registroActividades ra on ra.idCredito = dt.idCredito 
                left join reacciones re on re.idReaccion = ra.idReaccion
                left join detalleActividades da on da.idDetalle = ra.idDetalle
                where (ra.idActividad in (@cob,@cobFiador) or re.idActividad in (@cob,@cobFiador)) and ra.fecha between @fecha1 and @fecha2
                group by dt.idcliente,dt.idCredito
            ) dt2 group by dt2.idCliente
        ) dt3 on cl.idCliente = dt3.idCliente

        update cl
        set
            cl.acuerdosCumplidos = iif(numAcuerdos= 0,0,(acuerdosPagados * 100.0) /numAcuerdos )
        from(
            select
                cr.idCliente,
                sum(iif(vp.montoReal >= vp.montoPrometido,1,0)) acuerdosPagados,
                count(1) numAcuerdos
            from promesasPago_v vp
            inner join creditos cr on vp.idCredito = CR.idCredito
            where fechaGestion between @fecha1 and @fecha2
            group by cr.idCliente
        ) dt 
        inner join clientes cl on cl.idCliente = dt.idCliente

        update g set
            g.porc_mora = isnull(pxg.porc_mora,0),
            g.porc_monto_mora_30 = isnull(pxg.porc_monto_mora_30,0)
        from gestores g
        inner join (
            select 
                idGestor,
                cast(
                    (
                        case when CreditosMora>0 and CreditosActivos>0 then CreditosMora * 100.00 / CreditosActivos
                        else 0 end
                    ) as decimal(10,2)
                ) as porc_mora,
                cast(
                    (
                        case when totalCarteraActiva>0 and totalMora>0 then TotalMora / totalCarteraActiva * 100 
                        else 0 end
                    ) as decimal(10,2)
                ) as porc_monto_mora_30
            from (
                select 
                    ca.idGestor,
                    sum(case when c.diasCapitalMora>0 then 1 else 0 end) CreditosMora,
                    count(1) CreditosActivos,
                    sum(case when c.diasCapitalMora>30 then c.pagoParaEstarAlDia else 0 end) TotalMora,
                    sum(c.deudaTotal) totalCarteraActiva
                from creditos c
                inner join creditosAsignados ca on ca.idCredito = c.idCredito
                where c.idEstado=1
            group by ca.idGestor) as r
        ) as pxg on pxg.idGestor=g.idGestor

	--update vstClientes
		--update c
		--set
		--    c.atraso_Promedio = sc.atraso_Promedio,
		--    c.imf = sc.imf,
		--    c.atraso_Maximo = sc.atraso_Maximo,
		--    c.monto_Maximo_Atraso = sc.monto_Maximo_Atraso
		--from Clientes c
		--inner join [192.168.1.95].PCSC.dbo.score_cliente_v sc on sc.cliente_Id=c.idcliente
        
    --update score global by agencia
        update agencias set notaCD = (((dbo.getPointsPorce(porceMora) + dbo.getPointsDay(diasMora) + dbo.getPointsPorce(porceMontoMora30) + dbo.getPointsGestion(promedioGestion) + 1) * 100.0)/400)

        update cl set
            cl.notaCD = (((m*3)+(n*2)+o+p+q+r+s+t+u+1)*100)/1100
        from (
            SELECT
                idCliente
                ,q = dbo.getPointsGestion(numGestionesCob)
                ,r = dbo.getPointsGestion(avgGestionesCob)
                ,s = dbo.getPointsGestion(promedioGestionAlSalirMora)
                ,u = dbo.getPointsPorceInverso(acuerdosCumplidos)
                ,m = dbo.getPointsGestion(atraso_Promedio)
                ,n = dbo.getPointsGestion(atraso_Maximo)
                ,o = imf
                ,p = dbo.getPointsPorce(monto_Maximo_Atraso)
                ,t = dbo.getPointsDay(AVGDiasGestionSalirMora)
            from clientes
        ) as dt
        inner join clientes cl on cl.idCliente = dt.idCliente

        update g SET
            g.notaCD = (( (f*3.0)+(i*2.0)+k+g+j+h+1)*100) / 900
        from (
            select 
                idGestor
                ,j = dbo.getPointsGestion(promedioGestionesClientesMora)
                ,h = dbo.getPointsPorceInverso(acuerdosCumplidos)
                ,f = dbo.getPointsPorce(porc_mora)
                ,g = dbo.getPointsPorce(porc_monto_mora_30)
                ,i = dbo.getPointsDay(AVGDiasMora)
                ,k = dbo.getPointsPorce(porcMora3H)
            from gestores
        ) as dt
        inner join gestores g on g.idGestor = dt.idGestor
end
