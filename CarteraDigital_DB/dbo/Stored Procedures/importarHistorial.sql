	CREATE   procedure [dbo].[importarHistorial] as 
	begin
		declare @error int = 0

		----Consulta Buro 
		--	declare @CB table (
		--		fecha datetime,
		--		codigoCliente varchar(150),
		--		nombre varchar(150),
		--		respuesta varchar(150),
		--		data varchar(max),
		--		b64 varchar(max),
		--		codGestor varchar(30),
		--		tipo varchar(50),
		--		cost int,
		--		error int
		--	)
		--	DECLARE @month3 DATE = DATEADD(MONTH, -3 , GETDATE())
		--	DECLARE @LastImport_CB DATETIME = (select top 1 lastImportConsultaBuro from cartera_digital_historial.dbo.parametrizacion)
		--	if(@LastImport_CB is null)set @LastImport_CB = '1990-01-01 00:01:01.000'

		--	insert @CB select * from H_ConsultaBuro
		--	insert cartera_digital_historial.dbo.H_ConsultaBuro select * from @CB where fecha > @LastImport_CB
		--	delete H_ConsultaBuro
		--	insert H_ConsultaBuro select * from @CB where fecha > @month3

		--	declare @dateImport_CB datetime = (select max(fecha) from @CB)
		--	if(@dateImport_CB < @LastImport_CB)update cartera_digital_historial.dbo.parametrizacion set lastImportConsultaBuro = @dateImport_CB
		--	else set @error = 1

		--	delete @CB
		----------End Consulta Buro 

		--select 
		--	@error as error,
		--	iif(@error = 0,'La importación ha finalizado','La importación ha finalizado pero con advertencias') as msg,
		--	iif(@dateImport_CB < @LastImport_CB,'ok',concat('no hay consultas nuevas desde ',@LastImport_CB,'. Ultima consulta es de ',@dateImport_CB)) as consultaBuro
	end
