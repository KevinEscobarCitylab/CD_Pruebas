create view promesasPagoPorVencer_v as(
	select *from promesasPago_v where fechaPromesa = convert(date,getdate())
)
