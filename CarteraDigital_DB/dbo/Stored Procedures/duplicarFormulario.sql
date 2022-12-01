create procedure duplicarFormulario(@idFormulario int,@idEncuesta int,@nombre varchar(max), @rs varchar(max) = null out) as 
begin
    --declare @idFormulario int = 2,@idEncuesta int = 13,@nombre varchar(max) = 'aa', @rs varchar(max) = null
	if(object_id('tempdb..#f') is not null)drop table #f
	if(object_id('tempdb..#p') is not null)drop table #p
	if(object_id('tempdb..#r') is not null)drop table #r
	if(object_id('tempdb..#dp') is not null)drop table #dp

	--Inicio
	declare @ID int = (select idFormulario from formularios where idEncuesta = @idEncuesta and nombre = @nombre and estado = 1)
	declare @error int, @message varchar(max)

	begin transaction t1

	if @ID is null begin
		set @ID = coalesce((select idFormulario from formularios where idEncuesta = @idEncuesta and nombre = @nombre),(select max(idFormulario)+1 from formularios))
		select *into #f from formularios where idFormulario = @idFormulario
		select *,0 as ID into #p from preguntas p where idFormulario = @idFormulario and estado = 1
		select r.*into #r from respuestas r inner join #p p on p.idPregunta = r.idPregunta where r.estado = 1
		select d.*,0 as diff into #dp from dependenciasPregunta d inner join #p p on p.idPregunta = d.idPregunta where d.estado = 1

		alter table #f drop column idFormulario
		alter table #f add idFormulario int
		update #f set nombre = @nombre, idEncuesta = coalesce(@idEncuesta,idEncuesta), idFormulario = @ID
	
		--Duplicando formulario
			insert formularios(nombre,idEncuesta,_index,estado)
			select 
				s.nombre,
				s.idEncuesta,
				s._index,
				s.estado
			from formularios f
			right outer join #f s on s.idFormulario = f.idFormulario
			where f.idFormulario is null

			declare @idFormularioN int = scope_identity()

			update f
			set
				nombre = s.nombre,
				idEncuesta = s.idEncuesta,
				_index = s._index,
				estado = 1
			from formularios f
			inner join #f s on s.idFormulario = f.idFormulario
			where @idFormularioN is null

			update #p set idFormulario = coalesce(@idFormularioN, @ID),idEncuesta = coalesce(@idEncuesta,idEncuesta)

		--Duplicando preguntas
			update p
			set
				pregunta = s.pregunta,
				idTipo = s.idTipo,
				idFormato = s.idFormato,
				_index = s._index,
				requerir = s.requerir,
				mask = s.mask,
				[maxLength] =s.[maxLength],
				fx = s.fx,
				referenceTable = s.referenceTable,
				referenceId = s.referenceId,
				referenceValue = s.referenceValue,
				referenceFk = s.referenceFk,
				idPreguntaFk = s.idPreguntaFk,
				grupo = iif(s.codigoSIM is not null,coalesce(s.grupo,1) + 1, null),
				idTablaSIM = s.idTablaSIM,
				codigoSIM = s.codigoSIM,
				codigoAC = s.codigoAC,
				idRF = s.idRF,
				isHidden = s.isHidden,
				_default = s._default,
				idTipoPhoto = s.idTipoPhoto,
				indexReference = s.indexReference,
				estado = 1
			from preguntas p
			inner join #p s on rtrim(cast(s.pregunta as varchar(max))) = rtrim(cast(p.pregunta as varchar(max))) and p.estado != 1 and s.idFormulario = p.idFormulario

			insert into preguntas
			(pregunta,idTipo,idEncuesta,idFormato,estado,_index,requerir,idFormulario,mask,[maxLength],fx,grupo,idTablaSIM,codigoSIM,
				referenceTable,referenceId,referenceValue,referenceFk,idPreguntaFk,idRF,isHidden,_default,idTipoPhoto,indexReference,codigoAC)
			select 
				s.pregunta,
				s.idTipo,
				s.idEncuesta,
				s.idFormato,
				s.estado,
				s._index,
				s.requerir,
				s.idFormulario,
				s.mask,
				[maxLength] =s.[maxLength],
				s.fx,
				iif(s.codigoSIM is not null,coalesce(s.grupo,1) + 1, null),
				s.idTablaSIM,
				s.codigoSIM,
				s.referenceTable,
				s.referenceId,
				s.referenceValue,
				s.referenceFk,
				s.idPreguntaFk,
				s.idRF,
				s.isHidden,
				s._default,
				s.idTipoPhoto,
				s.indexReference,
				s.codigoAC
			from preguntas p 
			right outer join #p s on rtrim(cast(s.pregunta as varchar(max))) = rtrim(cast(p.pregunta as varchar(max))) and s.idFormulario = p.idFormulario
			where p.idPregunta is null
		
			update s set ID = p.idPregunta from #p s inner join preguntas p on rtrim(cast(p.pregunta as varchar(max))) = rtrim(cast(s.pregunta as varchar(max))) and p.idFormulario = s.idFormulario

		--Actualizando funciones de cálculo
			alter table #p alter column fx varchar(max)

			declare @index int = 0
			while @index <100 begin
				update t
				set 
					fx = replace(t.fx,concat('p',s.enLugarDe),concat('p',s.reemplazar))
				from #p t
				inner join(
					select
						s.idPregunta as IDC,
						p.idPregunta enLugarDe,
						(select top 1 ID from #p where idPregunta = p.idPregunta) as reemplazar		
					from #p p
					inner join #p s on s.fx like concat('%p',p.idPregunta,'%')
				)s on s.IDC = t.idPregunta
				if(@@ROWCOUNT = 0) set @index = 100
				else set @index = @index + 1
			end

			update p
			set
				fx = s.fx
			from preguntas p
			inner join #p s on s.ID = p.idPregunta

		--Duplicando respuestas		
			update r
			set
				r.idPregunta = p.ID 
			from #r r
			inner join #p p on p.idPregunta = r.idPregunta

			update r
			set
				respuesta = s.respuesta,
				valor = s.valor,
				_index = s._index,
				alias= s.alias,
				ID = s.ID,
				d1 = s.d1,
				estado = 1
			from respuestas r
			inner join #r s on rtrim(cast(s.respuesta as varchar(max))) = rtrim(cast(r.respuesta as varchar(max))) and s.idPregunta = r.idPregunta

			insert respuestas
			(respuesta,idPregunta,valor,_index,alias,ID,d1,estado)
			select
				s.respuesta,
				s.idPregunta,
				s.valor,
				s._index,
				s.alias,
				s.ID,
				s.d1,
				1
			from respuestas r
			right outer join #r s on rtrim(cast(s.respuesta as varchar(max))) = rtrim(cast(r.respuesta as varchar(max))) and s.idPregunta = r.idPregunta
			where r.idRespuesta is null

		--Duplicando dependencias de pregunta
			update t
			set 
				idPregunta = s.ID,
				parent = s.parent,
				estado = 1
			from #dp t
			inner join(
				select 
					dp.idDependencia,
					p.ID,
					p1.ID as parent
				from #p p
				left join #dp dp on dp.idPregunta = p.idPregunta
				left join #p p1 on p1.idPregunta = dp.parent
				where idDependencia is not null
			)s on s.idDependencia = t.idDependencia
		
			update t
			set 
				idPregunta = s.idPregunta,
				parent = s.parent,
				parentR = s.parentR,
				valorR = s.valorR,
				valorT = s.valorT,
				idOperador = s.idOperador,
				idUnidad = s.idUnidad,
				indexG = s.indexG,
			    fieldD1 = s.fieldD1,
				estado = 1
			from dependenciasPregunta t
			inner join #dp s on s.idPregunta  = t.idPregunta and s.parent = t.parent

			insert dependenciasPregunta (idPregunta,parent,parentR,valorR,valorT,idOperador,idUnidad,indexG,fieldD1,estado)
			select
				s.idPregunta,
				s.parent,
				s.parentR,
				s.valorR,
				s.valorT,
				s.idOperador,
				s.idUnidad,
				s.indexG,
			    s.fieldD1,
				1
			from dependenciasPregunta t
			right outer join #dp s on s.idPregunta  = t.idPregunta and s.parent = t.parent
			where t.idDependencia is null
			set @error =0
			set @message = 'Formulario duplicado correnctamente'

		--Normalizando referencias de preguntas de tipo javascript
			declare @dts table(ID int identity(1,1),idPregunta1 int,idPregunta2 int)
			insert @dts select 
				idPregunta1 = px1.idPregunta,
				idPregunta2 = px2.idPregunta 
			from preguntas px1
			inner join preguntas px2 on px1.pregunta = px2.pregunta and px2.idFormulario = @idFormularioN
			where px1.idFormato in (15,20) and px1.idFormulario = @idFormulario

			declare @indexJS int = 1, @total int = (select count(1) from @dts)
			declare @idPregunta1 int, @idPregunta2 int, @references nvarchar(max), @preg nvarchar(max)

			while @indexJS <= @total begin
				select 
					@idPregunta1 = idPregunta1,
					@idPregunta2 = idPregunta2,
					@references = '[]',
                    @preg = '[]'
				from @dts
				where ID = @indexJS

				select
					@references = json_modify(@references,'append $',json_query((select c.idPregunta, a.alias,a.d1,a.[parse],a.[format],a.requerir for json path,without_array_wrapper)))
				from preguntas p
				inner join respuestas r on r.idPregunta = p.idPregunta
				cross apply openjson(r.d1,'$.references')with(idPregunta int, alias varchar(50),d1 varchar(50),[parse] int,[format] varchar(50),requerir bit)a
				inner join preguntas ref on ref.idPregunta = a.idPregunta
				left join preguntas c on c.pregunta = ref.pregunta and c.idFormulario in(select idFormulario from preguntas idPregunta where idPregunta = @idPregunta2)
				where p.idPregunta = @idPregunta1

                select
					@preg = json_modify(@preg,'append $',json_query((select c.idPregunta, a.alias,a.[parse],a.[format],a.requerir for json path,without_array_wrapper)))
				from preguntas p
				inner join respuestas r on r.idPregunta = p.idPregunta
				cross apply openjson(r.d1,'$.preguntas')with(idPregunta int, alias varchar(50),[parse] int,[format] varchar(50),requerir bit)a
				inner join preguntas ref on ref.idPregunta = a.idPregunta
				left join preguntas c on c.pregunta = ref.pregunta and c.idFormulario in(select idFormulario from preguntas idPregunta where idPregunta = @idPregunta2)
				where p.idPregunta = @idPregunta1

				update r
				set 
					d1 = json_modify(d1,'$.references',json_query(@references))
				from respuestas r where idPregunta = @idPregunta2 and @references != '[]'

                update r
				set 
					d1 = json_modify(d1,'$.preguntas',json_query(@preg))
				from respuestas r where idPregunta = @idPregunta2 and @preg != '[]'

				set @indexJS +=1
			end

		--Normalizando referencias de preguntas de tipo buros
			declare @dtsapi table(ID int identity(1,1),idPregunta1 int,idPregunta2 int)

			insert @dtsapi select 
				idPregunta1 = px1.idPregunta,
				idPregunta2 = px2.idPregunta 
			from preguntas px1
			inner join preguntas px2 on px1.pregunta = px2.pregunta and px2.idFormulario = @idFormularioN
			where px1.idFormato in (7,8,14,16,19) and px1.idFormulario = @idFormulario

			declare @indexbu int = 1, @totalbu int = (select count(1) from @dtsapi)

			while @indexbu <= @totalbu begin
				select 
					@idPregunta1 = idPregunta1,
					@idPregunta2 = idPregunta2,
					@references = (select d1 from respuestas where idPregunta = idPregunta2)
				from @dtsapi
				where ID = @indexbu

				declare @dtsbu table(rownum int,d1 nvarchar(max),ref nvarchar(max))
				DELETE from @dtsbu				

				insert @dtsbu select 
					ROW_NUMBER() OVER (ORDER BY (SELECT NULL))-1 AS rownum,
					r.d1,
					a.ref
				from preguntas p
				inner join respuestas r on r.idPregunta = p.idPregunta
				cross apply openjson(r.d1) WITH(ref nvarchar(max) '$.references' as json ) a
				where p.idPregunta = @idPregunta1

				select 
					@references = json_modify(@references,concat('$[',a.rownum,'].references[',ID,']'), json_query((select c.idPregunta, a.alias,a.d1,a.[parse],a.[format],a.requerir for json path,without_array_wrapper))) 
				from (
					select ROW_NUMBER() OVER (partition by dt.rownum order by (SELECT NULL))-1 AS ID,dt.rownum, dt2.* 
					from @dtsbu as dt
					cross apply openjson(dt.ref) with(idPregunta int, alias varchar(50),d1 varchar(50),[parse] int,[format] varchar(50),requerir int) dt2
				) a
				inner join preguntas ref on ref.idPregunta = a.idPregunta
				left join preguntas c on c.pregunta = ref.pregunta and c.idFormulario in(select idFormulario from preguntas idPregunta where idPregunta = @idPregunta2)

				DELETE from @dtsbu

				insert @dtsbu select 
					ROW_NUMBER() OVER (ORDER BY (SELECT NULL))-1 AS rownum,
					r.d1,
					a.ref
				from preguntas p
				inner join respuestas r on r.idPregunta = p.idPregunta
				cross apply openjson(r.d1) WITH(ref nvarchar(max) '$.preguntas' as json ) a
				where p.idPregunta = @idPregunta1

				select 
					@references = json_modify(@references,concat('$[',a.rownum,'].preguntas[',ID,']'), json_query((select c.idPregunta, a.alias,a.[parse],a.[format],a.requerir for json path,without_array_wrapper))) 
				from (
					select ROW_NUMBER() OVER (partition by dt.rownum order by (SELECT NULL))-1 AS ID,dt.rownum, dt2.* 
					from @dtsbu as dt
					cross apply openjson(dt.ref) with(idPregunta int, alias varchar(50),d1 varchar(50),[parse] int,[format] varchar(50),requerir int) dt2
				) a
				inner join preguntas ref on ref.idPregunta = a.idPregunta
				left join preguntas c on c.pregunta = ref.pregunta and c.idFormulario in(select idFormulario from preguntas idPregunta where idPregunta = @idPregunta2)

				update r
				set 
					d1 = @references
				from respuestas r where idPregunta = @idPregunta2

				set @indexbu +=1
			end

		--Normalizando referencias de datos
			update p 
			set 
				idPreguntaFk = ref.idPregunta
			from preguntas p
			inner join preguntas fk on fk.idPregunta = p.idPreguntaFk
			inner join preguntas ref on ref.pregunta = fk.pregunta and ref.idFormulario = @idFormularioN
			where p.idFormulario = @idFormularioN and p.idFormato = 13 and p.idPreguntaFK is not null

		--Normalizando parentR para dependencias
			update dp
			set 
				parentR = r2.idRespuesta
			from preguntas p 
			inner join dependenciasPregunta dp on dp.idPregunta = p.idPregunta
			inner join respuestas r1 on r1.idRespuesta = dp.parentR
			inner join respuestas r2 on r2.idPregunta = dp.parent and r2.respuesta = r1.respuesta
			where p.idFormulario = @idFormularioN and dp.estado = 1 and parentR is not null
	end
	else begin
		set @error = 1
		set @message = 'No se puede duplicar un formulario con el mismo nombre'
	end

	if @rs is not null set @rs = (select @error as error, @message as message for json path, without_array_wrapper)
	else select @error as error, @message as message

	commit transaction t1
end
