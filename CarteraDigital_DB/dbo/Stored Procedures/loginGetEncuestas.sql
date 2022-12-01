CREATE PROCEDURE [dbo].[loginGetEncuestas](@idUsuario int) AS
BEGIN
	select (select
		0 as error,
		'Verificado' as message,
		PCLToken = (select PCLToken from parametros where idParametro = 1),
		formatos = json_query(i.formatos),
		encuestas = json_query(i.encuestas)
	from inicioSesionJS i 
	where i.ID = 1 for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data
end
