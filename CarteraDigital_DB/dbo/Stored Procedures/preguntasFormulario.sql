	CREATE PROCEDURE [dbo].[preguntasFormulario](@idFormulario int,  @idProspecto int, @sessionid varchar(max)= null, @d varchar(max) output)as
	begin
		--declare @idFormulario int = 1
		declare @idUsuario int = (dbo.getIdUsuarioByToken(@sessionid))

		if (@idUsuario is not null or @sessionid is null)
		begin
			declare @ds table (idPregunta int,idRespuesta int,respuesta nvarchar(MAX),idRespuestaT nvarchar(max),referenceFk varchar(50), indexP int)
            declare @dt table (idPregunta int, _reference int)
            declare @identity int = coalesce((select max(idRespuesta) from respuestas),0)
            declare dt cursor FOR (
                select
                    p.idPregunta,
                    p.referenceTable,
                    p.referenceId,
                    p.referenceValue,
                    p.referenceFk,
                    ROW_NUMBER() OVER(partition by p.referenceTable order by p.referenceTable,p._index) AS indexP,
                    p.indexReference
                from preguntas p
                inner join formularios fr on fr.idFormulario = p.idFormulario
                inner join encuestas e on e.idEncuesta = fr.idEncuesta
                where p.idFormato = 13 and p.referenceTable is not null and p.estado=1 and e.estado = 1 and fr.estado = 1 and p.idFormulario = @idFormulario
            )
            open dt
            declare @idPregunta int, @referenceTable nvarchar(max),@referenceId nvarchar(max),@referenceValue nvarchar(max),@referenceFk varchar(max), @indexP int,@reference int,@indexReference varchar(50)
            FETCH NEXT FROM dt INTO @idPregunta,@referenceTable,@referenceId,@referenceValue,@referenceFk,@indexP,@indexReference

            while @@FETCH_STATUS = 0
            begin
                declare @w bit = iif((select 1 from information_schema.columns where table_name = @referenceTable and column_name = '_index')is not null,1,0)
                declare @fk nvarchar(max) = iif(@referenceFk is not null and @referenceFk !='',concat(',',@referenceFk,' as referencia'),',null as referencia')
                declare @sql nvarchar(max)= concat('select ',@idPregunta,' as idPregunta,(ROW_NUMBER() OVER(ORDER BY ',iif(@w = 1, concat('_index,',@referenceId), @referenceId),' ASC)+',@identity,') as idRespuesta,',@referenceValue,',',@referenceId,@fk,',',@indexP,'from ',@referenceTable)
                --if(@indexP=1)begin
                    insert @ds exec sp_executesql @sql
                    set @reference = @idPregunta
                --end
                --else insert @dt(idPregunta,_reference) values(@idPregunta, @reference)
                set @identity = coalesce((select max(idRespuesta) from @ds),@identity)
                FETCH NEXT FROM dt INTO @idPregunta,@referenceTable,@referenceId,@referenceValue,@referenceFk,@indexP,@indexReference
            end

            close dt
            deallocate dt

             set @d = (
             select (
             select
                preguntas = (
                    select
                        ROW_NUMBER() over(partition by p.idFormulario order by p._index) _index,
                        p.idPregunta,
                        cast(p.pregunta as varchar(max))as pregunta,
                        p.idFormulario,
                        p.idTipo as tipoPregunta,
                        f.tipo,
                        dependencia = (select
                            ROW_NUMBER() over(partition by dp.indexG order by dp.indexG) id,
                            dp.parent idPreguntaPadre,
                            dp.valorR valorRespuestaDependiente,
                            dp.idOperador operadorRespuestaDependiente,
                            dp.idUnidad unidadRespuestaDependiente,
                            dp.parentR as idRespuestaPadre,
                            dp.valorT valorCatalogoRD,
                            dp.fieldD1 configuracionRD,
                            dp.indexG grupoRD
                        from dependenciasPregunta dp
                        where dp.estado = 1 and dp.idPregunta = p.idPregunta
                        for json path) ,
                        p.mask,
                        p.fx,
                        p.idRF,
                        p.idEncuesta,
                        coalesce(p.requerir,0) requerir,
                        p.idPreguntaFk,
                        p.isHidden,
                        p.multiple,
                        p.saved1,
                        p.disable,
                        --_ds._reference,
                        _tf.typeGetPhoto,
                        (select * from(
                            select idRespuesta,cast(respuesta as varchar(max)) as respuesta,valor,ID as IDT,cast(d1 as varchar(max)) as d1,_index,null as idRespuestaT,null as referenceFk,null as indexP from respuestas r where r.idPregunta = p.idPregunta and r.estado = 1
                            union
                            select idRespuesta,respuesta,null as valor,null as IDT,null as d1,idRespuesta as _index,idRespuestaT,referenceFk,indexP from @ds where idPregunta = p.idPregunta
                        )as dsr
                        order by dsr._index for JSON path) respuestas,
                        '' respuesta,
                        0 anexo,
                        1 np
                    from preguntas p
                    inner join formularios _fr on _fr.idFormulario = p.idFormulario
                    inner join formatos f on p.idFormato = f.idFormato
                    left join tiposFoto _tf on _tf.idTipoPhoto = p.idTipoPhoto
                    --left join @dt _ds on _ds.idPregunta = p.idPregunta
                    where _fr.idFormulario = @idFormulario and p.estado = 1 and _fr.estado = 1 order by _fr._index,p._index
                for JSON PATH)
             for JSON PATH, WITHOUT_ARRAY_WRAPPER,INCLUDE_NULL_VALUES)as data)
		end
		else begin
			set @d =(select (select 403 as error,'Acceso Denegado' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER) as data)
		end
	end
