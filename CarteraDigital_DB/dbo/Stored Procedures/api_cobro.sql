	create procedure [dbo].[api_cobro](@data nvarchar(max),@rsp nvarchar(max) out)as
	begin
		if(@data is not null and @data != '')begin
			declare @date date
			declare @tipo varchar(200)

			select top 1 @date = fecha,@tipo = tipo from openjson(@data)with(fecha date,tipo varchar(200))

			if(@tipo = '0')begin 
				set @rsp = ''
			end
			else if(@tipo = '1')begin
				set @rsp = (select coalesce((select
					idPago_CD = dp.idDetalleP,
					monto = dp.montoPorCobrar,
					comprobante = dp.numeroComprobante,
					fechaPago = dp.fechaPago,
					referenciaCredito = c.referencia,
					codigoGestor = g.codigo,
					fechaGestion = cast(ra.fecha as date),
					horaGestion = cast(ra.fecha as time)
				from detallePago dp
				inner join registroActividades ra on ra.idRegistroactividad = dp.idRegistroactividad
				inner join creditos c on c.idCredito = dp.idCredito
				inner join gestores g on g.idGestor = dp.idGestor
				where cast(ra.fecha as date) = @date for json path),'[]'))
			end
			else if(@tipo = '2')begin
				declare @cf int = dbo.fActividad('CVH')

				set @rsp = (select coalesce((select 
					idPago_CD = ra.idRegistroActividad,
					monto = dt.pago,
					comprobante = null,
					fechaPago = null,
					referenciaGrupo = idGrupoAdescoT,
					codigoGestor = g.codigo,
					fechaGestion = cast(ra.fecha as date),
					horaGestion = cast(ra.fecha as time)
				from (
						select 
						ra.idRegistroActividad,
						sum(ap.cuota) as pago
					from registroActividades ra 
					inner join acuerdosParticipante ap on ap.idRegistroActividad =ra.idRegistroActividad
					where ra.idActividad = @cf
					group by ra.idRegistroActividad) dt 
					inner join registroActividades ra on ra.idRegistroActividad = dt.idRegistroActividad
				inner join gestores g on g.idGestor = ra.idGestor
				left join gruposAdesco gg on gg.idGrupoAdesco = ra.idGrupo
				where ra.idActividad = @cf				
				and cast(ra.fecha as date) = @date for json path),'[]'))
			end
			else begin
				set @rsp = ''
			end
		end
	end
