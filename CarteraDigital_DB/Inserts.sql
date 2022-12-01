/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 Este scrip solo se corre una vez para base de datos nuevas				
--------------------------------------------------------------------------------------
*/
SET IDENTITY_INSERT parametros ON

	insert parametros(idParametro,bc,conf,app,PCLToken,rep,CP)
	select 
		t.*
	from ( select 
		idParametro = 1
		,bc = '{}'
		,conf = '{}'
		,app = '{}'
		,PCLToken = GETDATE()
		,rep = '{}'
		,CP = 0
	) as t
	left join parametros s on s.idParametro = t.idParametro
	where s.idParametro is null

	SET IDENTITY_INSERT parametros OFF
--------------------------------------------------------------------------------------
--Parametros.Conf
--------------------------------------------------------------------------------------
	declare @t bit = 1
	declare @f bit = 0

	declare @data nvarchar(max) = (select conf from parametros)
	set @data = json_modify(@data,'$."wUrl"','http://localhost/AGC/AGC.ServiceApp.svc/')
	set @data = json_modify(@data,'$.imgUrl','../../AGC/img/ws.svc/')
	set @data = json_modify(@data,'$.imgPath','C:/inetpub/wwwroot/AGC/img/')
	set @data = json_modify(@data,'$.diasBC', 7)
	set @data = json_modify(@data,'$.diasVerificacionClave', 30)
	set @data = json_modify(@data,'$.rangoVerificacionClave', 6)
	set @data = json_modify(@data,'$.tiempoEsperaSesion', 5)
	set @data = json_modify(@data,'$.horaInicioSesion', '07:00:00')
	set @data = json_modify(@data,'$.horaLimiteSesion', '19:00:00')
	set @data = json_modify(@data,'$.minutosRetrasoApp', 15)
	set @data = json_modify(@data,'$.verificarHoraDispositivo', @f)
	set @data = json_modify(@data,'$.depuracionInformes', @f)
	set @data = json_modify(@data,'$.depuracionDispositivo', @f)
	set @data = json_modify(@data,'$.cultureInfo', 'es-SV')
	set @data = json_modify(@data,'$.habilitarSesionAD', @f)
	set @data = json_modify(@data,'$.limiteDiaGestion', 6)
	set @data = json_modify(@data,'$.permitirUsuariosApp', @t)
	set @data = json_modify(@data,'$.bloqueoPorIntentosFallidos', @f)
	set @data = json_modify(@data,'$.submitDebug', @f)
	set @data = json_modify(@data,'$.useTransaction', @t)
	set @data = json_modify(@data,'$.visRepVig', 3)
	set @data = json_modify(@data,'$.visRepVen', 3)
	set @data = json_modify(@data,'$.autorizarGPSPic', @t)
	set @data = json_modify(@data,'$.acumularCreditosRuta', @f)
	set @data = json_modify(@data,'$.acumularGruposRuta', @f)
	set @data = json_modify(@data,'$.agregarVisitaReprogramadaRuta', @t)
	set @data = json_modify(@data,'$.agregarAcuerdoPagoRuta', @t)
	set @data = json_modify(@data,'$.mascaraTelefono', '9999-9999')
	set @data = json_modify(@data,'$.diaCalculoDistanciaRegAct', -1)
	set @data = json_modify(@data,'$.cambioClaveWeb', @t)
	set @data = json_modify(@data,'$.fechaInfoScore1', -6)
	set @data = json_modify(@data,'$.fechaInfoScore2', -1)
	set @data = json_modify(@data,'$.fechaInfoScore3', -3)
	set @data = json_modify(@data,'$.diasMaximoEsperRenov', 15)
	set @data = json_modify(@data,'$.idReaccionAcept', 146)
	set @data = json_modify(@data,'$.metaIndicadorDesembolso', 24)
	set @data = json_modify(@data,'$.sendMailDB', @f)
	set @data = json_modify(@data,'$.cantidadProspectos', 10)
	set @data = json_modify(@data,'$.addAPRuta',@f)
	set @data = json_modify(@data,'$.addVRRuta',@f)
	set @data = json_modify(@data,'$.procesarInfoE_Grupos', 10)
	set @data = json_modify(@data,'$.diasRechazoAuto', 30)

	update parametros set conf = @data where idParametro = 1
--------------------------------------------------------------------------------------
--Parametros.App
--------------------------------------------------------------------------------------
go
	declare @data nvarchar(max) = (select app from parametros)
	set @data = json_modify(@data,'$.activityTo', 'G')
	set @data = json_modify(@data,'$.rutaGestionadal', -1)
	set @data = json_modify(@data,'$.recomendarRuta', 4)
	set @data = json_modify(@data,'$.recomendarPxP', 1)
	set @data = json_modify(@data,'$.backNear', 1)
	set @data = json_modify(@data,'$.imgEDU', 2)
	set @data = json_modify(@data,'$.imgPRO', 2)
	set @data = json_modify(@data,'$.imgADM', 0)
	set @data = json_modify(@data,'$.imgGI', 2)
	set @data = json_modify(@data,'$.imgGG', 2)
	set @data = json_modify(@data,'$.maxTel', 8)
	set @data = json_modify(@data,'$.minTel', 8)
	set @data = json_modify(@data,'$.validPromesa', 1)
	set @data = json_modify(@data,'$.geoPic', 1)
	set @data = json_modify(@data,'$.reporteExtendAction', 'reporteExtendAction')
	set @data = json_modify(@data,'$.reporteExtend', 1)
	set @data = json_modify(@data,'$.viewGroupAtIndividual', 0)
	set @data = json_modify(@data,'$.anunciosAction', 'getAnuncios')
	set @data = json_modify(@data,'$.useSwipeGeocode', 0)
	set @data = json_modify(@data,'$.agendadosObligatorios', 0)
	set @data = json_modify(@data,'$.useWaypoints', 1)
	set @data = json_modify(@data,'$.etapaAnteriorProspecto', 0)
	set @data = json_modify(@data,'$.getInformacionAction', 'getInformacionCD')
	
	update parametros set app = @data where idParametro = 1
--------------------------------------------------------------------------------------
--Parametros.reportes
--------------------------------------------------------------------------------------
go
	declare @t bit = 1
	declare @f bit = 0

	declare @data nvarchar(max) = (select rep from parametros)
	set @data = json_modify(@data,'$.llamadaContactada', 1)
	set @data = json_modify(@data,'$.llamadaNoContactada', 0)
	set @data = json_modify(@data,'$.llamadaSeguimiento', 1)
	set @data = json_modify(@data,'$.diasMaximoPermitido', 15)
	set @data = json_modify(@data,'$.cultureInfo', 'es-SV')
	set @data = json_modify(@data,'$.imgUrl', '../../AGC/img/ws.svc/')
	
	update parametros set rep = @data where idParametro = 1

--------------------------------------------------------------------------------------
--CriteriosRuta
--------------------------------------------------------------------------------------
go
	insert criteriosRuta
	select 
		s.descripcion,
		s.condicion,
		0 as estado
	from ( 
		select 1 as idCriterio, 'Ejemplo' as descripcion, 'creditos.idCredito = 0' as condicion 
	) s
	left join criteriosRuta t on s.idCriterio = t.idCriterio
	where t.idCriterio is null
--------------------------------------------------------------------------------------
--criteriosRutaGrupos
--------------------------------------------------------------------------------------
go
	insert criteriosRutaGrupos
	select 
		s.descripcion,
		s.condicion,
		0 as estado
	from (
		select 1 as idCriterio, 'Ejemplo' as descripcion, 'gruposAdesco.idGrupoAdesco = 0' as condicion
	) s 
	left join criteriosRutaGrupos t on s.idCriterio = t.idCriterio
	where t.idCriterio is null
--------------------------------------------------------------------------------------
--criteriosColocacion
--------------------------------------------------------------------------------------
go
	insert criteriosColocacion(descripcion,condicion,estado)
	select 
		s.descripcion,
		s.condicion,
		1 as estado
	from (
		select 1 as idCriterio, 'Ejemplo' as descripcion, '1 = 1' as condicion
	) s 
	left join criteriosColocacion t on s.idCriterio = t.idCriterio
	where t.idCriterio is null
--------------------------------------------------------------------------------------
--inicioSesionJS
--------------------------------------------------------------------------------------
go
	insert inicioSesionJS (usuario)
	select
		s.usuario
	from (
		select usuario = 1 ,ID = 1 union all
		select usuario = 1 ,ID = 2 union all
		select usuario = 1 ,ID = 2
	) s
	left join inicioSesionJS t  on s.ID = t.ID
	where t.ID is null
go
--------------------------------------------------------------------------------------
--etapasGestionProspecto
--------------------------------------------------------------------------------------
go
	declare @max int = (select max(idEtapaG) from etapasGestionProspecto)
	exec resetIdentity 'etapasGestionProspecto',@max
	declare @dt table (idEtapaG int, etapa varchar(300),nivel int,_index int)

	insert @dt 
	select * from(
		select  1 as idEtapaG, 	'Recopilación' as etapa, 		1 as nivel, 	1 as _index
		union 
		select  2 as idEtapaG, 	'Revisión' as etapa, 			2 as nivel, 	2 as _index
		union 
		select  3 as idEtapaG, 	'Análisis y comité' as etapa, 	3 as nivel, 	3 as _index
		union 
		select  4 as idEtapaG, 	'Formalización' as etapa, 		4 as nivel, 	4 as _index
		union 
		select  5 as idEtapaG, 	'Aprobación' as etapa, 			5 as nivel, 	5 as _index
		union 
		select  6 as idEtapaG, 	'Rechazo' as etapa, 			0 as nivel, 	99 as _index
		union 
		select  7 as idEtapaG, 	'Finalizado' as etapa, 			6 as nivel, 	6 as _index
	) as dt

	SET IDENTITY_INSERT [dbo].etapasGestionProspecto ON
	insert etapasGestionProspecto
	(idEtapaG,etapa,nivel,_index)
	select 
		s.idEtapaG,
		s.etapa,
		s.nivel,
		s._index
	from @dt s
	left join etapasGestionProspecto t on t.idEtapaG = s.idEtapaG
	where t.idEtapaG is null

	SET IDENTITY_INSERT [dbo].etapasGestionProspecto OFF