	--Migracion de usuarios web a usuarios app
		insert into gestores 
		(codigo,nombre,idAgencia,idGrupo,estado,sistema,usuarioWeb)
		select
			rtrim(s.usuario) as cod,
			rtrim(s.[Nombre]) as G,
			a2.idAgencia,
			s.idGrupo,
			1 as estado,
			0 as sistema,
			1 as usuarioWeb
		from gestores t
		right outer join usuariosSistema s on s.usuario = t.codigo
		left join agencias a2 on a2.idAgencia = s.idAgencia
		where t.idGestor is null and s.estado = 1

		update t
		set
			t.estado = 1,
			t.idGrupo = s.idGrupo,
			t.idAgencia = s.idAgencia,
			t.nombre = s.nombre,
			t.sistema = 0
		from gestores t
		inner join usuariosSistema  s on s.usuario = t.codigo
		where s.estado = 1

		insert into usuarios
		(idGestor,usuario,clave,idGrupo,verificador,diasDesdeCambioClave,multiplesDispositivos,sessionid)
		select
			s.idGestor,
			rtrim(s.codigo),
			us.clave,
			us.idGrupo,
			0,
			0,
			1,
			0
		from usuarios t
		right outer join gestores s on s.idGestor = t.idGestor
		inner join usuariosSistema us on us.usuario = s.codigo
		where t.idUsuario is null and us.estado = 1

		update t 
		set 
			t.idGrupo = s.idGrupo,
			t.clave = us.clave			
		from usuarios t
		inner join gestores s on s.idGestor = t.idGestor
		inner join usuariosSistema us on us.usuario = s.codigo
		where s.estado = 1
		go