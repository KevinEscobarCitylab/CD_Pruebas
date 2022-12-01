	create    function [dbo].[fConsultaBuro](@fecha varchar(max))returns varchar(max) as
	begin

		declare @ret varchar(max)
		
		declare @detalle table(
			id int identity (1,1),
			idGestor int,
			asesor varchar(max),
			idAgencia int,
			agencia varchar(max),
			mes int,
			fecha varchar(max),
			costo int,
			proveedor varchar(max)
		)
		insert into @detalle (idGestor,asesor,idAgencia,agencia,mes,fecha,costo,proveedor)
		select
			*
		from(
			select 
				ges.idGestor,
				ges.nombre asesor,
				ag.idAgencia,
				ag.agencia,
				format(cb.fecha,'MM','es-ES') mes,
				format(cb.fecha,'MMMM','es-ES') fecha,
				cb.cost,
				cb.tipo 
			from H_ConsultaBuro cb
			inner join gestores ges on cb.codGestor = ges.idGestor
			inner join agencias ag on ag.idAgencia = ges.idAgencia
			where cast(cb.fecha as date) between dbo.fDateRange(@fecha,1) and dbo.fDateRange(@fecha,2)
		) dt
		order by dt.mes asc

		declare @cantAsesores int = (select count(1) from(select idGestor from @detalle group by idGestor)dt)

		set @ret = (select 
			((select count(1) from @detalle where costo = 1) * cast(dbo.fReport('costoConsultaBuro') as decimal(10,2))) costo,
			(select concat('[', STUFF((select distinct concat(',"',agencia,'"') from @detalle for xml path('')),1,1,'') ,']')  ) categoriesAgencia,
			(select 
					proveedor name,
					concat('[', STUFF((
						select 
							concat(',[',  (select count(1) from @detalle b where b.agencia = dt.agencia and b.proveedor = gs.proveedor)  ,']') 
						 from(
							select 
								distinct
								agencia
							from @detalle 
						 ) dt
						 for xml path('')
					 ),1,1,''),']') data
				from(
					select distinct proveedor from @detalle
				) gs	
				for json path
			) seriesAgencia,
			(select concat('[', STUFF(( select concat(',"',fecha,'"') from(select distinct fecha from @detalle) dt for xml path('')),1,1,'') ,']')  ) categoriesMes,
			(select 
				'Promedio de consultas mensuales' name,
				concat('[', STUFF((
					select 
						concat(',[',  (select count(1)/@cantAsesores from @detalle b where b.mes = dt.mes)  ,']') 
						from(
						select 
							distinct
							mes
						from @detalle 
						) dt
					for xml path('')
				),1,1,''),']') data
				for json path
			) seriesAsesor
		for json path)

		return @ret
	end
