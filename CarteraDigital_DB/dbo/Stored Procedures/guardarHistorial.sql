	Create procedure [dbo].[guardarHistorial] (@date date = null) as
	begin
		set @date = (select coalesce(@date,getDate()))

		alter table historialCreditosAsignados nocheck constraint all
		ALTER INDEX ALL ON historialCreditosAsignados disable
		delete from historialCreditosAsignados where DATEDIFF(day,fechaOut,@date) > 90
		alter index ALL ON historialCreditosAsignados rebuild;
		alter table historialCreditosAsignados check constraint ALL;

		alter table historialGestores nocheck constraint all
		alter index ALL ON historialGestores disable
		delete from historialGestores where DATEDIFF(day,fecha,@date) > 90
		alter index ALL ON historialGestores rebuild;
		alter table historialGestores check constraint ALL;

		alter table historialCredito nocheck constraint all
		alter index ALL ON historialCredito disable
		delete from historialCredito where DATEDIFF(day,fecha,@date) > 90
		alter index ALL ON historialCredito rebuild;
		alter table historialCredito check constraint ALL;

		declare @can int = dbo.fEstadoCredito('CAN')

		declare @isUpdate int = (select top 1 1 from historialCredito where fecha = @date)

		delete from historialCreditosAsignados where fechaIn = @date
		update hca set fechaOut = null from historialCreditosAsignados hca where fechaOut = @date

		--Eliminar registros de historial que superen los 70 dias desde que ingresaron
		delete from historial where fecha < cast(dateadd(day,-70,GETDATE()) as date)

		--insertar historialcreditosasignados
		insert into historialCreditosAsignados(idCredito,idGestor,fechaIn)
		select
			ca.idCredito,
			ca.idGestor,
			@date
		from creditosAsignados ca
		left join historialCreditosAsignados hca on ca.idCredito = hca.idCredito and ca.idGestor = hca.idGestor and hca.fechaOut is null
		where (hca.fechaOut is not null or (hca.idCredito is null)) and ca.asignado != 0 and ca.asignadoAyer = 0
		group by ca.idCredito,ca.idGestor

		--update historialcreditosasignados
		update hca
		set
			hca.fechaOut = @date
		from historialCreditosAsignados hca
		inner join creditosAsignados ca on ca.idCredito = hca.idCredito and ca.idGestor = hca.idGestor
		where hca.fechaOut is null and ca.asignado = 0 and ca.asignadoAyer != 0 

		--actualizar creditoAsignado
		update ca
		set
			ca.asignadoAyer = ca.asignado
		from creditosAsignados ca
		where ca.asignado != ca.asignadoAyer

		--si se corre varias veces el metodo 
		if(@isUpdate = 1)
		begin		
			--actualizar historial apartir de las nueva informacion
			UPDATE hc
			set
				hc.pagoParaEstarAlDia = c.pagoParaEstarAlDia,
				hc.pagoParaTramo30 = c.pagoParaTramo30,
				hc.pagoParaTramo60 = c.pagoParaTramo60,
				hc.pagoParaTramo90 = c.pagoParaTramo90,
				hc.deudaTotal = c.deudaTotal,
				hc.ultimoPago = c.ultimoPago,
				hc.fechaProximaCuota = c.fechaProximaCuota,
				hc.montoProximaCuota = c.montoProximaCuota,
				hc.saldoCapitalVencido = c.saldoCapitalVencido,
				hc.saldoCapitalVigente = c.saldoCapitalVigente,
				hc.diasCapitalMora = c.diasCapitalMora,
				hc.capitalMora = c.capitalMora,
				hc.capitalTotalAdeudado = c.capitalTotalAdeudado,
				hc.ultimaFechaPago = c.ultimaFechaPago,
				hc.idPrioridad = c.idPrioridad,
				hc.idCriterioSeguimiento = c.idCriterioSeguimiento,
				hc.desertado = c.desertado,
				--hc.institucionConsulta = c.institucionConsulta,
				hc.idEstado = c.idEstado,
				hc.seguimiento = coalesce(c.seguimiento,c.seguimiento,0),
				hc.prioridad = coalesce(c.prioridad,c.prioridad,0),
				hc.prioridadAgencia = coalesce(c.prioridadAgencia,c.prioridadAgencia,0),
				hc.promesas = coalesce(c.promesas,c.promesas,0),
				hc.renovacion = coalesce(c.renovacion,c.renovacion,0),
				hc.mora = iif(c.diasCapitalMora>0,1,0),	
				hc.porDesertar = coalesce(c.porDesertar,c.porDesertar,0)
			from historialCredito hc
			inner join creditos c on hc.idCredito = c.idCredito
			where hc.fecha = CAST(@date AS DATE)

			--insert new creditos
			insert into historialCredito(idCredito,fecha,pagoParaEstarAlDia,pagoParaTramo30,pagoParaTramo60,pagoParaTramo90,deudaTotal,ultimoPago,fechaProximaCuota,montoProximaCuota,saldoCapitalVencido,saldoCapitalVigente,diasCapitalMora,capitalMora,capitalTotalAdeudado,ultimaFechaPago,idPrioridad,idCriterioSeguimiento,desertado,idEstado,seguimiento,prioridad,prioridadAgencia,promesas,renovacion,mora,porDesertar)
			select 
				c.idCredito,
				@date as fecha,
				c.pagoParaEstarAlDia,
				c.pagoParaTramo30,
				c.pagoParaTramo60,
				c.pagoParaTramo90,
				c.deudaTotal,
				c.ultimoPago,
				c.fechaProximaCuota,
				c.montoProximaCuota,
				c.saldoCapitalVencido,
				c.saldoCapitalVigente,
				c.diasCapitalMora,
				c.capitalMora,
				c.capitalTotalAdeudado,
				c.ultimaFechaPago,
				c.idPrioridad,
				c.idCriterioSeguimiento,
				c.desertado,
				c.idEstado,
				coalesce(c.seguimiento,c.seguimiento,0) as seguimiento,
				coalesce(c.prioridad,c.prioridad,0) as prioridad,
				coalesce(c.prioridadAgencia,c.prioridadAgencia,0) as prioridadAgencia,
				coalesce(c.promesas,c.promesas,0) as promesas,
				coalesce(c.renovacion,c.renovacion,0) as renovacion,
				iif(c.diasCapitalMora>0,1,0)   as mora,		
				coalesce(c.porDesertar,c.porDesertar,0) as porDesertar
			from creditos c
			left join historialCredito hc on hc.idCredito = c.idCredito
			where c.idEstado not in (@can) and hc.idCredito is null

			--update historialGestores
			update hg
			set 
				hg.idGrupo = g.idGrupo,
				hg.idAgencia = g.idAgencia,
				hg.idSupervisor = g.idSupervisor--,
				--hg.saldoCartera = g.saldoCartera,
				--hg.totalClientes = g.totalClientes,
				--hg.totalClientesMora = g.totalClientesMora
			from historialGestores hg
			inner join  gestores g on g.idGestor = hg.idGestor

			--insertar historialGestores
			insert into historialGestores(idGestor,fecha,idGrupo,idAgencia,idSupervisor)--,saldoCartera,totalClientes,totalClientesMora)
			select 
				g.idGestor,
				@date,
				g.idGrupo,
				g.idAgencia,
				g.idSupervisor--,
				--saldoCartera,
				--totalClientes,
				--totalClientesMora
			from gestores g
			left join historialGestores hg on g.idGestor = hg.idGestor
			where estado != 0 and hg.idGestor is null

			--actualizar informacion de los creditos del dia, segun los historiales
			update h
			set
				h.mora = g.mora,
				h.prv = g.prv,
				h.pdd = g.pdd,
				h.seg = g.seg,
				h.cpr = g.cpr, 
				h.moraUnDia = g.moraUnDia,
				h.asignado = g.asignado,
				h.desasignado = g.desasignado
			from historial h 
			inner join (
				select 
					hcr.idCredito,
					hca.idGestor,
					max(hcr.mora) as mora,
					max(hcr.renovacion) as prv,
					max(hcr.desertado) as pdd,
					max(hcr.seguimiento)as seg,
					max(hcr.cobroPreventivo)as cpr,
					max(iif(hcr.diasCapitalMora = 1 and cast(hcr.fecha as date) = @date ,1,0)) as moraUnDia,
					max(iif(hca.fechaOut is null,1,0)) as asignado,
					max(iif(hca.fechaOut is not null and hca.revision = 0,1,0)) as desasignado,
					@date fecha
				from historialCreditosAsignados hca
				inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
				inner join gestores g on g.idGestor = hca.idGestor
				inner join agencias ag on ag.idAgencia = g.idAgencia 
				where (fechaIn between @date and @date or 
						fechaOut between @date and @date or
						@date between fechaIn and fechaOut or
						(fechaIn<=@date and fechaIn <= @date and fechaOut is null)) and
						hcr.fecha between @date and @date and g.estado = 1
				group by hcr.idCredito,hca.idGestor
			) g on h.idCredito = g.idCredito and h.idGestor = g.idGestor and h.fecha = g.fecha
		end
		else 
		begin	
			--insertar historialcredito
			insert into historialCredito(idCredito,fecha,pagoParaEstarAlDia,pagoParaTramo30,pagoParaTramo60,pagoParaTramo90,deudaTotal,ultimoPago,fechaProximaCuota,montoProximaCuota,saldoCapitalVencido,saldoCapitalVigente,diasCapitalMora,capitalMora,capitalTotalAdeudado,ultimaFechaPago,idPrioridad,idCriterioSeguimiento,desertado,idEstado,seguimiento,prioridad,prioridadAgencia,promesas,renovacion,mora,porDesertar)
			select 
				c.idCredito,
				@date as fecha,
				c.pagoParaEstarAlDia,
				c.pagoParaTramo30,
				c.pagoParaTramo60,
				c.pagoParaTramo90,
				c.deudaTotal,
				c.ultimoPago,
				c.fechaProximaCuota,
				c.montoProximaCuota,
				c.saldoCapitalVencido,
				c.saldoCapitalVigente,
				c.diasCapitalMora,
				c.capitalMora,
				c.capitalTotalAdeudado,
				c.ultimaFechaPago,
				c.idPrioridad,
				c.idCriterioSeguimiento,
				c.desertado,
				c.idEstado,
				coalesce(c.seguimiento,c.seguimiento,0) as seguimiento,
				coalesce(c.prioridad,c.prioridad,0) as prioridad,
				coalesce(c.prioridadAgencia,c.prioridadAgencia,0) as prioridadAgencia,
				coalesce(c.promesas,c.promesas,0) as promesas,
				coalesce(c.renovacion,c.renovacion,0) as renovacion,
				iif(c.diasCapitalMora>0,1,0)   as mora,		
				coalesce(c.porDesertar,c.porDesertar,0) as porDesertar
			from creditos c
			where c.idEstado not in (@can)
			
			--insertar historialGestores
			insert into historialGestores(idGestor,fecha,idGrupo,idAgencia,idSupervisor)--,saldoCartera,totalClientes,totalClientesMora)
			select 
				idGestor,
				@date,
				idGrupo,
				idAgencia,
				idSupervisor--,
				--saldoCartera,
				--totalClientes,
				--totalClientesMora
			from gestores
			where estado != 0

			--guardando informacion de los creditos del dia, segun los historiales
			insert into historial (idCredito,idGestor,mora,prv,pdd,seg,cpr,moraUnDia,asignado,desasignado,fecha,tarjeta)
			select 
				hcr.idCredito,
				hca.idGestor,
				max(hcr.mora) as mora,
				max(hcr.renovacion) as prv,
				max(hcr.desertado) as pdd,
				max(hcr.seguimiento)as seg,
				max(hcr.cobroPreventivo)as cpr,
				max(iif(hcr.diasCapitalMora = 1 and cast(hcr.fecha as date) = @date ,1,0)) as moraUnDia,
				max(iif(hca.fechaOut is null,1,0)) as asignado,
				max(iif(hca.fechaOut is not null and hca.revision = 0,1,0)) as desasignado,
				@date fecha,
				cr.tarjeta
			from historialCreditosAsignados hca
			inner join historialCredito hcr on hcr.idCredito = hca.idCredito and (hcr.fecha between hca.fechaIn and fechaOut or (hca.fechaIn <= hcr.fecha and hca.fechaOut is null))
			inner join creditos cr on cr.idCredito = hcr.idCredito
			inner join gestores g on g.idGestor = hca.idGestor
			inner join agencias ag on ag.idAgencia = g.idAgencia 
			where (fechaIn between @date and @date or 
					fechaOut between @date and @date or
					@date between fechaIn and fechaOut or
					(fechaIn<=@date and fechaIn <= @date and fechaOut is null)) and
					hcr.fecha between @date and @date and g.estado = 1
			group by hcr.idCredito,hca.idGestor,cr.tarjeta

		end

		select iif(@isUpdate = 1,'actualizado','insertado') as total
	end
