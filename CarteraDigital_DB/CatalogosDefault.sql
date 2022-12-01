/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
este script es para actulizar los catalogos por default sin modificar nada importante				
--------------------------------------------------------------------------------------
*/
--------------------------------------------------------------------------------------
 --Version			
--------------------------------------------------------------------------------------
go
	declare @version varchar(20) = '1.0.26.0'

	
	declare @data nvarchar(max) = (select conf from parametros)
	set @data = json_modify(@data,'$.version', @version)
	update parametros set conf = @data where idParametro = 1

	update parametros set VersionDB = @version
go
--------------------------------------------------------------------------------------
--accionesEtapa
--------------------------------------------------------------------------------------
GO
	declare @max int = (select max(idAccion) from accionesEtapa)
	exec resetIdentity 'accionesEtapa',@max
	declare @dt table(accion varchar(100), _class varchar(100), icon varchar(100), codigo varchar(100), tipo varchar(100), idEtapa int)

	insert @dt 
	select * from(
		select  'Revisar' as accion, 	'btn btn-sm btn-warning' as _class, 	'fal fa-file-search' as icon, 	'REV' as codigo, 	'button' as tipo,	2 as idEtapa
		union 
		select  'Analizar' as accion, 	'btn btn-sm btn-success' as _class, 	'fal fa-user-chart' as icon, 	'FRM' as codigo, 	'button' as tipo,	3 as idEtapa
		union 
		select  'Observar' as accion, 	'btn btn-icon' as _class, 	'fas fa-eye' as icon, 	'OBS' as codigo, 	'a' as tipo,	1 as idEtapa
		union 
		select  'Aprobar' as accion, 	'btn btn-sm btn-success' as _class, 	'fal fa-check' as icon, 	'APRB' as codigo, 	'button' as tipo,	5 as idEtapa
		union 
		select  'Rechazar' as accion, 	'btn btn-sm btn-danger' as _class, 	'fal fa-times' as icon, 	'RCHZ' as codigo, 	'button' as tipo,	6 as idEtapa
		union 
		select  'Formalizar' as accion, 	'btn btn-sm btn-info' as _class, 	'fal fa-file-check' as icon, 	'FMLZ' as codigo, 	'button' as tipo,	4 as idEtapa
		union 
		select  'Reemplazar' as accion, 	'' as _class, 	NULL as icon, 	'RMPZ' as codigo, 	'context' as tipo,	NULL as idEtapa
		union 
		select  'Editar' as accion, 	'btn btn-icon' as _class, 	'fas fa-pen' as icon, 	'EDIT' as codigo, 	'a' as tipo,	NULL as idEtapa
		union 
		select  'Adjuntar' as accion, 	'fa fa-upload' as _class, 	NULL as icon, 	'UPLD' as codigo, 	'attach' as tipo,	NULL as idEtapa
		union 
		select  'Excepciones' as accion, 	'btn btn-sm btn-success' as _class, 	'fal fa-user-chart' as icon, 	'EXCP' as codigo, 	'button' as tipo,	NULL as idEtapa
		union 
		select  'Aprobaciones de crédito' as accion, 	'btn btn-sm btn-success' as _class, 	'fal fa-user-chart' as icon, 	'POLCR' as codigo, 	'button' as tipo,	NULL as idEtapa
		union 
		select  'Descargar' as accion, 	NULL as _class, 	'fal fa-file-archive' as icon, 	'DWLD' as codigo, 	'context' as tipo,	NULL as idEtapa
		union 
		select  'Eliminar' as accion, 	NULL as _class, 	'fal fa-trash-alt' as icon, 	'DEL' as codigo, 	'context' as tipo,	NULL as idEtapa
		union 
		select  'Finalizar' as accion, 	'btn btn-sm btn-success' as _class, 	'fal fa-file-invoice-dollar' as icon, 	'END' as codigo, 	'button' as tipo,	7 as idEtapa
		union 
		select  'Visualizar' as accion, 	NULL as _class, 	'fa fa-edit' as icon, 	'VIS' as codigo, 	'dropdown' as tipo,	NULL as idEtapa
	) as dt

	insert accionesEtapa(accion,_class, icon , codigo, tipo, idEtapa)
	select 
		t.accion
		,t._class
		,t.icon
		,t.codigo
		,t.tipo
		,t.idEtapa
	from @dt t
	left join accionesEtapa s on s.codigo = t.codigo
	where s.idAccion is null

	update t
    set
        t._class = s._class,
        t.icon = s.icon,
        t.tipo = s.tipo
    from accionesEtapa t
    inner join @dt s on s.codigo = t.codigo
--------------------------------------------------------------------------------------
--encabezadoTipo
--------------------------------------------------------------------------------------
Go
	declare @max int = (select max(idET) from encabezadoTipo)
	exec resetIdentity 'encabezadoTipo',@max
	declare @dt table(idET int, tipo varchar(100), alias varchar(50))

	insert @dt 
	select * from(
		select  1 as idET,		'Encabezado' as tipo, 	'encabezado' as alias
		union 
		select 	2 as idET,		'Extra' as tipo, 	'extra' as alias
		union 
		select 	3 as idET,		'Edad' as tipo, 	'edad' as alias
		union 
		select 	4 as idET,		'Monto' as tipo, 	'monto' as alias
		union 
		select 	5 as idET,		'Nombre completo' as tipo, 	'nombreC' as alias
		union 
		select 	6 as idET,		'Direccion' as tipo, 	'direccion' as alias
		union 
		select 	7 as idET,		'Documento de identidad' as tipo, 	'nDoc' as alias
		union 
		select 	8 as idET,		'Linea credito' as tipo, 	'lineaC' as alias
		union 
		select 	9 as idET,		'Telefono' as tipo, 	'telefono' as alias
		union 
		select 	10 as idET,		'GPS Casa' as tipo, 	'gpsCasa' as alias
		union 
		select 	11 as idET,		'GPS Negocio' as tipo, 	'gpsNegocio' as alias
		union 
		select 	12 as idET,		'Ciclo' as tipo, 	'ciclo' as alias
		union 
		select 	13 as idET,		'Asignar A' as tipo, 	'asignarA' as alias
		union 
		select 	14 as idET,		'Correo' as tipo, 	'correo' as alias
	) as dt
	
	SET IDENTITY_INSERT encabezadoTipo ON
	insert encabezadoTipo(idET,tipo)
	select 
		t.idET
		,t.tipo
	from @dt t
	left join encabezadoTipo s on s.idET = t.idET
	where s.idET is null

	SET IDENTITY_INSERT encabezadoTipo OFF

	update s set 
		s.tipo = t.tipo
		,s.alias = t.alias
	from encabezadoTipo s
	inner join @dt t on t.idET = s.idET
--------------------------------------------------------------------------------------
--Formatos
--------------------------------------------------------------------------------------
Go
	declare @max int = (select max(idFormato) from formatos)
	exec resetIdentity 'formatos',@max
	declare @dt table(idFormato int, tipo varchar(50), alias varchar(50), icon varchar(30))

	insert @dt 
	select * from(
		select  1 as idFormato,		'int' as tipo, 	'Numérico' as alias, 	'sort-numeric-asc' as icon
		union 
		select 	2 as idFormato,		'float' as tipo, 	'Decimal' as alias, 	'hashtag' as icon
		union 
		select 	3 as idFormato,		'string' as tipo, 	'Texto' as alias, 	'text-width' as icon
		union 
		select 	4 as idFormato,		'date' as tipo, 	'Fecha' as alias, 	'calendar' as icon
		union 
		select 	5 as idFormato,		'img' as tipo, 	'Imagen' as alias, 	'image' as icon
		union 
		select 	6 as idFormato,		'file' as tipo, 	'Documento' as alias, 	'file' as icon
		union 
		select 	7 as idFormato,		'api' as tipo, 	'Buró' as alias, 	'gear' as icon
		union 
		select 	8 as idFormato,		'b64f' as tipo, 	'Documento b64' as alias, 	'clipboard' as icon
		union 
		select 	9 as idFormato,		'math' as tipo, 	'Cálculo' as alias, 	'calculator' as icon
		union 
		select 	10 as idFormato,	'gps' as tipo, 	'GEO-Referencia' as alias, 	'map-marker' as icon
		union 
		select 	11 as idFormato,	'caps' as tipo, 	'Mayúsculas' as alias, 	'text-height' as icon
		union 
		select 	12 as idFormato,	'name' as tipo, 	'Nombre' as alias, 	'font' as icon
		union 
		select 	13 as idFormato,	'datasource' as tipo, 	'Referencia de datos' as alias, 	'database' as icon
		union 
		select 	14 as idFormato,	'list' as tipo, 	'Buro Lista' as alias, 	'file-text' as icon
		union 
		select 	15 as idFormato,	'script' as tipo, 	'Javascript' as alias, 	'gears' as icon
		union 
		select 	16 as idFormato,	'autocomplete' as tipo, 	'Auto completador de preguntas' as alias, 	'automobile' as icon
		union 
		select 	17 as idFormato,	'geocode' as tipo, 	'Geocoding Service' as alias, 	'map' as icon
		union 
		select 	18 as idFormato,	'loop' as tipo, 	'Iterador' as alias, 	'retweet' as icon
		union 
		select 	19 as idFormato,	'datalist' as tipo, 	'Lista de datos' as alias, 	'tasks' as icon
		union 
		select 	20 as idFormato,	'validscript' as tipo, 	'Script validador' as alias, 	'gears' as icon
		union 
		select 	22 as idFormato,	'vmes' as tipo, 	'Venta Mensual' as alias, 	'calendar' as icon
		union 
		select 	23 as idFormato,	'vsemanal' as tipo, 	'Venta Samanal' as alias, 	'calendar' as icon
		union 
		select 	24 as idFormato,	'vdiario' as tipo, 	'Venta Diaria' as alias, 	'calendar' as icon
	) as dt

	insert formatos (tipo)
	select s.tipo
	from @dt s
	left join formatos t on s.idFormato = t.idFormato
	where t.idFormato is null

	update t set
		t.tipo = s.tipo,
		t.alias = s.alias,
		t.icon = s.icon
	from formatos t
	inner join @dt s on s.idFormato = t.idFormato
--------------------------------------------------------------------------------------
--Actividades
--------------------------------------------------------------------------------------
GO
	declare @max int = (select max(idActividad) from actividades)
	exec resetIdentity 'actividades',@max
	declare @dt table (codigo varchar(max), actividad varchar(max))

	insert @dt 
	select * from(
		select  'ADM' as codigo,	'Recopilación' as actividad
		union 
		select  'COB' as codigo,	'Cobro' as actividad
		union 
		select  'EDU' as codigo,	'Educativas' as actividad
		union 
		select  'PRO' as codigo,	'Promoción y organización' as actividad
		union 
		select  'SEG' as codigo,	'Seguimiento' as actividad
		union 
		select  'PRV' as codigo,	'Renovaciones' as actividad
		union 
		select  'PDD' as codigo,	'Desertados' as actividad
		union 
		select  'CPN' as codigo,	'Campaña' as actividad
		union 
		select  'LLM' as codigo,	'Llamada' as actividad
		union 
		select  'RCP' as codigo,	'Nuevo prospecto' as actividad
		union 
		select  'CFD' as codigo,	'Cobro fiador' as actividad
		union 
		select  'CPR' as codigo,	'Cobro preventivo' as actividad
		union 
		select  'SLC' as codigo,	'Prospecto' as actividad
		union 
		select  'GRP' as codigo,	'Grupos Nuevos' as actividad
		union 
		select  'DSB' as codigo,	'Desembolso' as actividad
		union 
		select  'CVH' as codigo,	'Cierre de Fichas' as actividad
		union 
		select  'CCS' as codigo,	'Concursos' as actividad
		union 
		select  'RHZ' as codigo,	'Rechazo Prospecto' as actividad
		union 
		select  'CA1' as codigo,	'Capacitación 1' as actividad
		union 
		select  'CA2' as codigo,	'Capacitación 2' as actividad
		union 
		select  'CA3' as codigo,	'Visto Bueno' as actividad
		union 
		select  'CA4' as codigo,	'Recontratación' as actividad
	) as dt

	insert actividades(codigo,actividad,estado)
	select 
		s.codigo,
		s.actividad,
		0 as estado
	from @dt s
	left join actividades t on t.codigo = s.codigo
	where t.idActividad is null
--------------------------------------------------------------------------------------
--ReacionesTipo
--------------------------------------------------------------------------------------
go
	declare @max int = (select max(idRT) from reaccionTipo)
	exec resetIdentity 'reaccionTipo',@max
	declare @dt table(idRT int, tipo varchar(50))

	insert @dt 
	select * from(
		select 1 as idRT,	'Promesa pago' as tipo union
		select 2 as idRT,	'Verificación pago' as tipo union
		select 3 as idRT,	'Visita reprogramada' as tipo union
		select 4 as idRT,	'Renovación' as tipo union
		select 5 as idRT,	'No quiere renovación' as tipo union
		select 6 as idRT,	'Pago cuota' as tipo union
		select 7 as idRT,	'Capacitacion' as tipo union
		select 8 as idRT,	'Visto Bueno' as tipo union
		select 9 as idRT,	'Depositado' as tipo union
		select 10 as idRT,	'Cliente no interesado o no aplica para campaña' as tipo union
		select 11 as idRT,	'Asignacion de credito a otro perfil' as tipo union
		select 12 as idRT,	'Whatsapp' as tipo 
	) as dt

	insert reaccionTipo (tipo)
	select s.tipo
	from @dt s
	left join reaccionTipo t on s.idRT = t.idRT
	where t.idRT is null

	update t set
		t.tipo = s.tipo
	from reaccionTipo t
	inner join @dt s on s.idRT = t.idRT
--------------------------------------------------------------------------------------
--categoriasInfoExtendida
--------------------------------------------------------------------------------------
GO
	declare @max int = (select max(idCategoria) from categoriasInfoExtendida)
	exec resetIdentity 'categoriasInfoExtendida',@max
	declare @dt table(idCategoria int, categoria varchar(50), _index int)

	insert @dt 
	select * from(
		select  1 as idCategoria,	'Cobro' as categoria, 			1 as _index
		union 
		select  2 as idCategoria,	'Seguimiento' as categoria, 	2 as _index
		union 
		select  3 as idCategoria,	'Desertado' as categoria, 		3 as _index
		union 
		select  4 as idCategoria,	'Renovación' as categoria, 		4 as _index
		union 
		select  5 as idCategoria,	'Sin categoría' as categoria, 	6 as _index
		union 
		select  6 as idCategoria,	'Desembolso' as categoria, 		5 as _index
	) as dt

	insert categoriasInfoExtendida(categoria,_index)
	select 
		s.categoria,
		s._index
	from @dt s
	left join categoriasInfoExtendida t on t.idCategoria = s.idCategoria
	where t.idCategoria is null

	update t set
		t.categoria = s.categoria,
		t._index = s._index
	from categoriasInfoExtendida t
	inner join @dt s on s.idCategoria = t.idCategoria
--------------------------------------------------------------------------------------
--infoExtendia
--------------------------------------------------------------------------------------
GO
	insert infoExtendida
	(codigo,descripcion,idCategoria,formato,emergente,estado,_index,tipo)
	select
		s.codigo,
		s.descripcion,
		s.idCategoria,
		s.formato,
		s.emergente,
		1,
		s._index,
		1
	from infoExtendida t
	right outer join(
		--Cobro
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	1 as idCategoria,	'C' as formato,	 0 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Saldo Pendiente' as descripcion,	1 as idCategoria,	'C' as formato,	 0 as emergente, 1 as _index union
		select 'valorCuota'			as codigo,	'Cuota' as descripcion,				1 as idCategoria,	null as formato, 0 as emergente, 2 as _index union
		--cierre Fiche																									 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	2 as idCategoria,	'C' as formato,	 0 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Saldo Pendiente' as descripcion,	2 as idCategoria,	'C' as formato,	 0 as emergente, 1 as _index union
		select 'valorCuota'			as codigo,	'Cuota' as descripcion,				2 as idCategoria,	null as formato, 0 as emergente, 2 as _index union
		--desertado																										 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	3 as idCategoria,	'C' as formato,	 0 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Saldo Pendiente' as descripcion,	3 as idCategoria,	'C' as formato,	 0 as emergente, 1 as _index union
		select 'valorCuota'			as codigo,	'Cuota' as descripcion,				3 as idCategoria,	null as formato, 0 as emergente, 2 as _index union
		--renovacion																									 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	4 as idCategoria,	'C' as formato,	 0 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Al dia' as descripcion,			4 as idCategoria,	'C' as formato,	 0 as emergente, 1 as _index union
		select 'valorCuota'			as codigo,	'Cuota' as descripcion,				4 as idCategoria,	null as formato, 0 as emergente, 2 as _index union
		--Sin categoria																									 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	5 as idCategoria,	'C' as formato,	 0 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Saldo Pendiente' as descripcion,	5 as idCategoria,	'C' as formato,	 0 as emergente, 1 as _index union
		select 'valorCuota'			as codigo,	'Cuota' as descripcion,				5 as idCategoria,	null as formato, 0 as emergente, 2 as _index union
		--Emergente																										 				 
		--Cobro 																										 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	1 as idCategoria,	'C' as formato,	 1 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Al dia' as descripcion,			1 as idCategoria,	'C' as formato,	 1 as emergente, 1 as _index union
		--seguimiento																									 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	2 as idCategoria,	'C' as formato,	 1 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Al dia' as descripcion,			2 as idCategoria,	'C' as formato,	 1 as emergente, 1 as _index union
		--desertado																										 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	3 as idCategoria,	'C' as formato,	 1 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Al dia' as descripcion,			3 as idCategoria,	'C' as formato,	 1 as emergente, 1 as _index union
		--renovacion																									 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	4 as idCategoria,	'C' as formato,	 1 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Al dia' as descripcion,			4 as idCategoria,	'C' as formato,	 1 as emergente, 1 as _index union
		--Sin categoria																									 				 
		select 'montoOtorgado'		as codigo,	'Monto desembolso' as descripcion,	5 as idCategoria,	'C' as formato,	 1 as emergente, 0 as _index union
		select 'pagoParaEstarAlDia'	as codigo,	'Al dia' as descripcion,			5 as idCategoria,	'C' as formato,	 1 as emergente, 1 as _index
	)s on s.codigo = t.codigo and s.emergente = t.emergente and s.idCategoria = t.idCategoria and t.tipo = 1
	where t.codigo is null
--------------------------------------------------------------------------------------
--Valor default para score
--------------------------------------------------------------------------------------
GO
    update clientes set promedioGestionAlSalirMora = 0 where promedioGestionAlSalirMora is null
    update clientes set numGestionesCob = 0 where numGestionesCob is null
    update clientes set avgGestionesCob = 0 where avgGestionesCob is null
    update clientes set acuerdosCumplidos = 0 where acuerdosCumplidos is null
    update clientes set atraso_Promedio = 0 where atraso_Promedio is null
    update clientes set imf = 0 where imf is null
    update clientes set atraso_Maximo = 0 where atraso_Maximo is null
    update clientes set monto_Maximo_Atraso = 0 where monto_Maximo_Atraso is null
    update clientes set AVGDiasGestionSalirMora = 0 where AVGDiasGestionSalirMora is null
    update agencias set porceMora = 0 where porceMora is null
    update agencias set diasMora = 0 where diasMora is null
    update agencias set promedioGestion = 0 where promedioGestion is null
    update agencias set notaCD = 0 where notaCD is null
    update agencias set porceMontoMora30 = 0 where porceMontoMora30 is null
    update gestores set promedioGestionesClientesMora = 0 where promedioGestionesClientesMora is null
    update gestores set acuerdosCumplidos = 0 where acuerdosCumplidos is null
    update gestores set notaCD = 0 where notaCD is null
--------------------------------------------------------------------------------------
-- TipoEncuesta
--------------------------------------------------------------------------------------
go
	declare @max int = (select max(idTipoEncuesta) from tiposEncuesta)
	exec resetIdentity 'tiposEncuesta',@max
	declare @dt table(idTipoEncuesta int, codigo varchar(5), tipo varchar(50), app int DEFAULT NULL)

	insert @dt 
	select * from(
		select  1 as idTipoEncuesta, 'ENC' as codigo, 'Encuesta' as tipo, NULL as app
        union
        select  2 as idTipoEncuesta, 'PCL' as codigo, 'Prospección de clientes' as tipo, 1 as app
        union
        select  3 as idTipoEncuesta, 'ORG' as codigo, 'Organizaciones locales' as tipo, NULL as app
        union
        select  4 as idTipoEncuesta, 'GRP' as codigo, 'Grupos' as tipo, 1 as app
        union
        select  5 as idTipoEncuesta, 'INF' as codigo, 'Captura de información' as tipo, null as app
        union
        select  6 as idTipoEncuesta, 'CALC' as codigo, 'Cálculo' as tipo, 1 as app
        union
        select  7 as idTipoEncuesta, 'PERS' as codigo, 'PERS' as tipo, 1 as app
	) as dt

	insert tiposEncuesta (codigo)
	select s.codigo
	from @dt s
	left join tiposEncuesta t on s.idTipoEncuesta = t.idTipoEncuesta
	where t.idTipoEncuesta is null

	update t set
		t.codigo = s.codigo,
		t.tipo = s.tipo,
		t.app = s.app
	from tiposEncuesta t
	inner join @dt s on s.idTipoEncuesta = t.idTipoEncuesta
--------------------------------------------------------------------------------------
-- tiposFormularios
--------------------------------------------------------------------------------------
go
	declare @max int = (select max(idTipoFormularios) from tiposFormularios)
	exec resetIdentity 'tiposFormularios',@max
	declare @dt table(idTipoFormularios int, tipo varchar(50), codigo varchar(50))

		insert @dt 
		select * from(
			select  1 as idTipoFormularios, 'ASOC' as codigo, 'Asociacion' as tipo
			union
			select  2 as idTipoFormularios, 'DEFA' as codigo, 'Default' as tipo
		) as dt

	insert tiposFormularios (codigo)
	select s.codigo
	from @dt s
	left join tiposFormularios t on s.idTipoFormularios = t.idTipoFormularios
	where t.idTipoFormularios is null

	update t set
		t.tipo = s.tipo,
		t.codigo = s.codigo
	from tiposFormularios t
	inner join @dt s on s.idTipoFormularios = t.idTipoFormularios
--------------------------------------------------------------------------------------
-- menuMovil
--------------------------------------------------------------------------------------
go
	select * from menuMovil
	declare @max int = (select max(idMenu) from menuMovil)
	exec resetIdentity 'menuMovil',@max
	declare @dt table(idMenu INT,menu varchar(100),codigo varchar(5),descripcion varchar(MAX),categoria int,estado int, _index int)

    insert @dt 
    select * from(
	select  1 as idMenu, 'Inicio' as menu, 'STR' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  2 as idMenu, 'Nuevo grupo' as menu, 'NGP' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  3 as idMenu, 'Nuevo prospecto' as menu, 'NCL' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  4 as idMenu, 'Cartera de clientes' as menu, 'CCL' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  6 as idMenu, 'Calculador de cuota' as menu, 'CCT' as codigo,  '' as descripcion, 0 as categoria, 0 as estado, NULL as _index
	Union
	select  7 as idMenu, 'Mi ruta' as menu, 'CRT' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  8 as idMenu, 'Actividades administrativas' as menu, 'ADM' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  9 as idMenu, 'Actividades promocionales' as menu, 'PRO' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  10 as idMenu, 'Actividades educativas' as menu, 'EDU' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  11 as idMenu, 'Historial de actividades' as menu, 'HAC' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  12 as idMenu, 'Cerrar sesión' as menu, 'CSS' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
	Union
	select  13 as idMenu, 'Prioridades' as menu, 'PRD' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  14 as idMenu, 'Cartera en gestión' as menu, 'COB' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  15 as idMenu, 'Prospectos' as menu, 'SLC' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  16 as idMenu, 'En mora' as menu, 'IMR' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  17 as idMenu, 'Reestructura COVID19' as menu, 'IDS' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  18 as idMenu, 'Cierre de fichas' as menu, 'IVH' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  19 as idMenu, 'Seguimientos' as menu, 'IST' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  20 as idMenu, 'Renovaciones' as menu, 'IRV' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  21 as idMenu, 'Desertados' as menu, 'IDE' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  22 as idMenu, 'Campañas' as menu, 'ICP' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  23 as idMenu, 'Promesas' as menu, 'IPM' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  24 as idMenu, 'Gestionados' as menu, 'IGD' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  25 as idMenu, 'Saneados' as menu, 'ISN' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  26 as idMenu, 'Prioridades' as menu, 'GPRD' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  27 as idMenu, 'Cartera en gestión' as menu, 'GGP' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  28 as idMenu, 'En mora' as menu, 'GMR' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  29 as idMenu, 'Desembolsos' as menu, 'GDS' as codigo,  '' as descripcion, 2 as categoria, 0 as estado, NULL as _index
	Union
	select  30 as idMenu, 'Cierre de fichas' as menu, 'GVH' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  31 as idMenu, 'Renovaciones' as menu, 'GRV' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  32 as idMenu, 'En proceso' as menu, 'GPR' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  33 as idMenu, 'Gestionado' as menu, 'GTND' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  34 as idMenu, 'Cartera en gestión' as menu, 'OGP' as codigo,  '' as descripcion, 3 as categoria, 1 as estado, NULL as _index
	Union
	select  35 as idMenu, 'Prioridad' as menu, 'OPRD' as codigo,  '' as descripcion, 3 as categoria, 1 as estado, NULL as _index
	Union
	select  36 as idMenu, 'En mora' as menu, 'OMR' as codigo,  '' as descripcion, 3 as categoria, 1 as estado, NULL as _index
	Union
	select  37 as idMenu, 'Desembolsos' as menu, 'ODS' as codigo,  '' as descripcion, 3 as categoria, 1 as estado, NULL as _index
	Union
	select  38 as idMenu, 'Cierre de fichas' as menu, 'OVH' as codigo,  '' as descripcion, 3 as categoria, 1 as estado, NULL as _index
	Union
	select  39 as idMenu, 'Renovaciones' as menu, 'ORV' as codigo,  '' as descripcion, 3 as categoria, 1 as estado, NULL as _index
	Union
	select  40 as idMenu, 'Actividades administrativas' as menu, 'RAD' as codigo,  '' as descripcion, 4 as categoria, 1 as estado, NULL as _index
	Union
	select  41 as idMenu, 'Actividades promocionales' as menu, 'RPR' as codigo,  '' as descripcion, 4 as categoria, 1 as estado, NULL as _index
	Union
	select  42 as idMenu, 'Actividades educativas' as menu, 'RED' as codigo,  '' as descripcion, 4 as categoria, 1 as estado, NULL as _index
	Union
	select  43 as idMenu, 'Prospectos' as menu, 'RSL' as codigo,  '' as descripcion, 4 as categoria, 1 as estado, NULL as _index
	Union
	select  44 as idMenu, 'Visitas Reprogramadas' as menu, 'IVR' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  45 as idMenu, 'Vencimientos' as menu, 'IVT' as codigo,  '' as descripcion, 1 as categoria, 0 as estado, NULL as _index
	Union
	select  46 as idMenu, 'Vencimientos' as menu, 'GVT' as codigo,  '' as descripcion, 2 as categoria, 1 as estado, NULL as _index
	Union
	select  47 as idMenu, 'Presidentes de Grupo' as menu, 'ITG' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  48 as idMenu, 'No Geolocalizados' as menu, 'ING' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  49 as idMenu, 'No Geolocalizados' as menu, 'GNG' as codigo,  '' as descripcion, 2 as categoria, 0 as estado, NULL as _index
	Union
	select  50 as idMenu, 'Vencimientos' as menu, 'IVO' as codigo,  '' as descripcion, 1 as categoria, 1 as estado, NULL as _index
	Union
	select  51 as idMenu, 'Vencimientos' as menu, 'GVO' as codigo,  '' as descripcion, 2 as categoria, 0 as estado, NULL as _index
	Union
	select  52 as idMenu, 'Capacitación 1' as menu, 'GC1' as codigo,  '' as descripcion, 2 as categoria, 0 as estado, NULL as _index
	Union
	select  53 as idMenu, 'Capacitación 2' as menu, 'GC2' as codigo,  '' as descripcion, 2 as categoria, 0 as estado, NULL as _index
	Union
	select  54 as idMenu, 'Recontratación' as menu, 'GC4' as codigo,  '' as descripcion, 2 as categoria, 0 as estado, NULL as _index
	Union
	select  55 as idMenu, 'Visto Bueno' as menu, 'GC3' as codigo,  '' as descripcion, 2 as categoria, 0 as estado, NULL as _index
	Union
	select  56 as idMenu, 'Personas' as menu, 'PERS' as codigo,  '' as descripcion, 0 as categoria, 1 as estado, NULL as _index
    ) as dt

    insert menuMovil (codigo)
	select s.codigo
	from @dt s
	left join menuMovil t on s.idMenu = t.idMenu
	where t.idMenu is null

	update t set
		t.menu = s.menu,
		t.codigo = s.codigo,
		t.descripcion = s.descripcion,
		t.categoria = s.categoria,
		t.estado = s.estado,
		t._index = s._index
	from menuMovil t
	inner join @dt s on s.idMenu = t.idMenu
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--Procesos de Actualizacion
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
--formatoR
--------------------------------------------------------------------------------------
go
	--Proceso de uso hasta que se actualize o llene el campo FormatoR automaticamente
	GO
	UPDATE p set 
		p.formatoR = dbo.getFormatR(p.idTipo,f.tipo,p.multiple)
	from preguntas p 
	inner join formatos f on f.idFormato = p.idFormato
	where p.formatoR is null