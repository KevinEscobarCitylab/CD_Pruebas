	create   procedure guardarConsultaBuro(@js varchar(max))as 
	begin
		declare @CB table (
			idConsulta int,
			fecha datetime,
			codigoCliente varchar(150),
			nombre varchar(150),
			respuesta varchar(150),
			data varchar(max),
			b64 varchar(max),
			codGestor varchar(30),
			tipo varchar(50),
			idClienteT varchar(20),
			saved int,
			cost int,
			error int
		 )
		insert @CB
		SELECT 
			idConsulta,
			coalesce(fecha,getDate()),
			codigoCliente,
			nombre,
			respuesta,
			data,
			b64,
			codGestor,
			tipo,
			idClienteT,
			coalesce(saved,0),
			coalesce(cost,0),
			coalesce(error,0)
		FROM OPENJSON (@js) WITH (   
			idConsulta   int,
			fecha datetime,
			codigoCliente varchar(150),
			nombre varchar(150),
			respuesta varchar(150),
			data varchar(max),
			b64 varchar(max),
			codGestor varchar(30),
			tipo varchar(50),
			idClienteT varchar(20),
			saved int,
			cost int,
			error int
		)

		insert H_ConsultaBuro
		select 
			fecha,
			codigoCliente,
			nombre,
			respuesta,
			data,
			b64,
			codGestor,
			tipo,
			cost,
			error
		from @CB
		where codigoCliente is not null
		insert consultaBuro(codigoCliente,nombre,score,fecha,data,tipo,saved,codGestor,idClienteT)
		select 
			codigoCliente,
			nombre,
			respuesta,
			fecha,
			data,
			tipo,
			saved,
			codGestor,
			idClienteT
		from @CB
		where codigoCliente is not null and idConsulta is null and error = 0
		update c set
			nombre = s.nombre,
			score = s.respuesta,
			fecha = s.fecha,
			data = s.data,
			saved = s.saved,
			codGestor = s.codGestor,
			idClienteT = s.idClienteT
		from consultaBuro c
		inner join @CB s on s.idConsulta = c.idConsulta and error = 0
	end
