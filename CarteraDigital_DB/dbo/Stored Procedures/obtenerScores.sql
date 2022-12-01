CREATE PROCEDURE [dbo].[obtenerScores] (@idSexo varchar(max), @idClienteT varchar(max), @idGestor int) as 
begin
	--Almaceno la solicitud como historial.
	insert into historialScore(idCliente,idGestor,idAgencia,scoreCliente,scoreGestor,scoreAgencia,scoreCD)
	select 
		cl.idCliente,
		g.idGestor,
		a.idAgencia,
		cl.notaCD as scoreCliente,
		g.notaCD as scoreGestor,
		a.notaCD as scoreAgencia,
		(((a.notaCD + ( g.notaCD * 2) + (cl.notaCD * 2))/500)*100) as scoreCD
	from clientes cl 
	cross join gestores g
	inner join agencias a on a.idAgencia=g.idAgencia
	where cl.idClienteT = @idClienteT and g.idGestor=@idGestor

	declare @idHistorialScore int = (SELECT SCOPE_IDENTITY())

	select 
		c.nDoc as dui,
		@idSexo as sexo,

		c.nombre as cliente,
		g.nombre as gestor,
		a.agencia as agencia,

		c.idCliente,
		g.idGestor,
		a.idAgencia,

		convert (int,hs.scoreCliente) as scorecliente,
		convert (int,hs.scoreGestor) as scoregestor,
		convert (int,hs.scoreAgencia) as scoreagencia,
		convert (int,hs.scoreCD) as scoreCD1,

		concat(convert (int,hs.scoreCliente),'%') as scorecliente1,
		concat(convert (int,hs.scoreGestor),'%') as scoregestor1,
		concat(convert (int,hs.scoreAgencia),'%') as scoreagencia1,
		concat(convert (int,hs.scoreCD),'%') as scoreCD
	from historialScore hs
	inner join clientes c on c.idCliente = hs.idCliente
	inner join gestores g on g.idGestor = hs.idGestor
	inner join agencias a on a.idAgencia = hs.idAgencia
	where idHistorialScore = @idHistorialScore
end
