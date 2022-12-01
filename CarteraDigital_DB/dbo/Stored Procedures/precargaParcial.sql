	create procedure [dbo].[precargaParcial] as
	begin
		set nocount on
		declare @DA varchar(50)
		declare @DM varchar(50)
		update inicioSesionJS set encuestas = (select PCLToken from parametros) where ID = 3

		--------------------------------------
		--APP
			set @DA = (select app from inicioSesionJS where ID = 2)
			set @DM = (select app from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				update s set
					s.app = (select p.app from parametros p where idParametro = 1)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.app = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.app = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
						s.app = @DM
					from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
		--Formatos
			set @DA = (select formatos from inicioSesionJS where ID = 2)
			set @DM = (select formatos from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				update s set
					s.formatos = (select idFormato,tipo from formatos for JSON PATH)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.formatos = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.formatos = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
					s.formatos = @DM
				from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
		--Encuestas
			set @DA = (select encuestas from inicioSesionJS where ID = 2)
			set @DM = (select encuestas from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				declare @_dt table(ID int identity(1,1), idPregunta int, referenceTable varchar(max),referenceId varchar(max),referenceValue varchar(max),referenceFk varchar(max),indexP int,indexReference varchar(max))

				insert @_dt
				(idPregunta,referenceTable,referenceId,referenceValue,referenceFk,indexP,indexReference)
				select
					p.idPregunta,
					p.referenceTable,
					p.referenceId,
					p.referenceValue,
					p.referenceFk,
					row_number() over(partition by p.referenceTable,p.referenceFk order by p.referenceTable, p._index) as indexP,
					p.indexReference
				from preguntas p
				inner join formatos f on f.idFormato = p.idFormato
				inner join formularios fr on fr.idFormulario = p.idFormulario
				inner join encuestas e on e.idEncuesta = fr.idEncuesta
				where f.tipo = 'datasource' and p.referenceTable is not null and e.estado = 1 and fr.estado = 1 and p.estado=1 and p._default is null  and (fr.web != 1 or fr.web is null)

				declare @ds table (idPregunta int,idRespuesta int,respuesta nvarchar(MAX),idRespuestaT nvarchar(50),referenceFk varchar(50), indexP int)
				declare @dt table (idPregunta int, _reference int)
				declare @totalP int = (select max(ID) from @_dt), @_index int= 1, @identity int = coalesce((select max(idRespuesta) from respuestas),0),@reference int

				while @_index <= @totalP begin
					declare @idPregunta int=null, @referenceTable nvarchar(max)=null,@referenceId nvarchar(max)=null,@referenceValue nvarchar(max)=null,@referenceFk varchar(max)=null, @indexP int=null

					select
						@idPregunta = idPregunta,
						@referenceTable = referenceTable,
						@referenceId = referenceId,
						@referenceValue = referenceValue,
						@referenceFk = referenceFk,
						@indexP = indexP
					from @_dt where ID = @_index

					declare @w bit = iif((select 1 from information_schema.columns where table_name = @referenceTable and column_name = '_index')is not null,1,0)
					declare @fk nvarchar(max) = iif(@referenceFk is not null and @referenceFk !='',concat(',',@referenceFk,' as referencia'),',null as referencia')
					declare @sql nvarchar(max)= concat('select ',@idPregunta,' as idPregunta,(ROW_NUMBER() OVER(ORDER BY ',iif(@w = 1, concat('_index,',@referenceId), @referenceId),' ASC)+',@identity,') as idRespuesta,',@referenceValue,',',@referenceId,@fk,',',@indexP,'from ',@referenceTable)
					if(@indexP=1)begin
						insert @ds exec sp_executesql @sql
						set @reference = @idPregunta
					end
					else begin
						--print concat('idPregunta: ',@idPregunta,', ','referencia: ',@reference)
						insert @dt(idPregunta,_reference) values(@idPregunta, @reference)
					end
					set @identity = coalesce((select max(idRespuesta) from @ds),@identity)
					set @_index +=1
				end

				update s set
					s.encuestas = (
						select
							e.idEncuesta,
							e.nombre,
							te.codigo,
							gruposEncuesta = (select *from grupoEncuesta where idEncuesta = e.idEncuesta and (estado=1 or estado is null) order by _index for JSON path),
							formularios = isNull((
								select
									fr.idFormulario,
									fr.nombre,
									fr.idGrupoE,
									fr._index as _order,
									fr.parents,
									fr.idTipo as tipoFormulario,
									fr.printer,
									fr.conf,
									fr.d1,
									preguntas = isNull((
										select
											p.idPregunta,
											_fr.idEncuesta,
											p.pregunta,
											p.idTipo,
											p.idFormato,
											p.requerir,
											p.mask,
											p.fx,
											p.idFormulario,
											p.idPreguntaFk,
											p.idRF,
											p.isHidden,
											p.saveD1,
											_ds._reference,
											_tf.typeGetPhoto,
											p.multiple,
											p.alias as 'pivot',
											p.[maxLength],
											p.forRejection,
											p.maxDecimal,
											p.showDecimal,
											respuestas = isNull((
												select *from(
													select idRespuesta,cast(respuesta as varchar(max)) as respuesta,valor,ID as IDT,cast(d1 as varchar(max)) as d1,_index,null as idRespuestaT,null as referenceFk,null as indexP from respuestas r where r.idPregunta = p.idPregunta and r.estado = 1 and p.idFormato != 13
													union
													select idRespuesta,respuesta,null as valor,null as IDT,null as d1,idRespuesta as _index,idRespuestaT,referenceFk,indexP from @ds where idPregunta = p.idPregunta
												)as dsr
												order by dsr._index for JSON path
											),'[]'),
											dependencias = isNull((
												select
													dp.parent,
													dp.valorR,
													dp.idOperador,
													dp.idUnidad,
													dp.parentR,
													dp.valorT,
    												dp.indexG,
													dp.fieldD1
												from dependenciasPregunta dp where dp.idPregunta = p.idPregunta and estado = 1 for JSON path
											),'[]') 
										from preguntas p
										inner join formularios _fr on _fr.idFormulario = p.idFormulario
										left join tiposFoto _tf on _tf.idTipoPhoto = p.idTipoPhoto
										left join @dt _ds on _ds.idPregunta = p.idPregunta
										where _fr.idFormulario = fr.idFormulario and p.estado = 1 and _fr.estado = 1 and p._default is null and (_fr.web != 1 or _fr.web is null) order by _fr._index,p._index for JSON path
									),'[]')
								from  formularios fr
								where fr.idEncuesta = e.idEncuesta and estado = 1 and (web != 1 or web is null) order by _index for JSON PATH
							),'[]'),
							encabezados = isNull((select idEP,idPregunta,idET,_index from encabezadoEncuesta where idEncuesta = e.idEncuesta and estado = 1 for JSON PATH),'[]')
						from encuestas e
						inner join tiposEncuesta te on te.idTipoEncuesta = e.idTipoEncuesta
						where e.estado = 1 and te.app is not NULL
					for JSON PATH)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.encuestas = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.encuestas = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
					s.encuestas = @DM
				from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
		--Actividades
			set @DA = (select actividades from inicioSesionJS where ID = 2)
			set @DM = (select actividades from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				update s set
					s.actividades = (select idActividad,actividad,codigo,motivoObligatorio,fotoObligatorio,observacionObligatorio,wa from actividades where estado=1 for JSON PATH)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.actividades = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.actividades = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
					s.actividades = @DM
				from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
		--detalleActividades
			set @DA = (select detalleActividades from inicioSesionJS where ID = 2)
			set @DM = (select detalleActividades from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				update s set
					s.detalleActividades = (select idDetalle,detalle,idActividad,parent,contactado from detalleActividades where estado=1 for JSON PATH)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.detalleActividades = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.detalleActividades = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
					s.detalleActividades = @DM
				from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
		--reacciones
			set @DA = (select reacciones from inicioSesionJS where ID = 2)
			set @DM = (select reacciones from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				update s set
					s.reacciones = (select idReaccion,reaccion,idDetalle,idActividad,idRT,formatPrint,formatPrintG from reacciones where estado = 1 for JSON PATH)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.reacciones = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.reacciones = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
					s.reacciones = @DM
				from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
		--motivoActividades
			set @DA = (select motivoActividades from inicioSesionJS where ID = 2)
			set @DM = (select motivoActividades from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				update s set
					s.motivoActividades = (select idMotivo,motivo,idActividad,idMotivoT from motivoActividades where idActividad is not null and estado = 1 for JSON PATH)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.motivoActividades = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.motivoActividades = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
					s.motivoActividades = @DM
				from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
		--campanias
			set @DA = (select campanias from inicioSesionJS where ID = 2)
			set @DM = (select campanias from inicioSesionJS where ID = 3)

			if(@DA is null or @DM is null or @DA != @dm)begin
				update s set
					s.campanias = (select
							c.idCampania,
							c.titulo,
							cast(c.proposito as varchar(MAX)) as proposito,
							c.fechaInicio,
							c.fechaFin
						from campanias c
						where c.estado = 1 for JSON PATH)
				from inicioSesionJS s where ID = 1

				if(@DM is null)begin
					update s set
						s.campanias = GETDATE()
					from inicioSesionJS s where ID = 2

					update s set
						s.campanias = GETDATE()
					from inicioSesionJS s where ID = 3
				end
				else begin
					update s set
					s.campanias = @DM
				from inicioSesionJS s where ID = 2
				end
			end
		--------------------------------------
			print 'Precarga parcial finalizada'
		set nocount off
	end
