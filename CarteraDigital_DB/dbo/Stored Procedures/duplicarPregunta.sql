create procedure duplicarPregunta(@idPregunta int,@idFormulario int,@nombre varchar(max),@rs varchar(max)=null out)as
begin
	if(object_id('tempdb..#p') is not null)drop table #p
	if(object_id('tempdb..#r') is not null)drop table #r
	if(object_id('tempdb..#dp') is not null)drop table #dp
	if(object_id('tempdb..#c') is not null)drop table #c

	declare @ID int = (select @idPregunta from preguntas where idFormulario = @idFormulario and cast(pregunta as varchar(max)) = @nombre and estado = 1)
	declare @error int, @message varchar(max)

	begin transaction t1

	if @ID is null begin
		set @ID = coalesce((select idPregunta from preguntas where idFormulario = @idFormulario and cast(pregunta as varchar(max)) = @nombre),(select max(idPregunta)+1 from preguntas))
		select *,0 as ID into #p from preguntas p where idPregunta = @idPregunta
		select r.*into #r from respuestas r inner join #p p on p.idPregunta = r.idPregunta where r.estado = 1
		select d.*into #dp from dependenciasPregunta d inner join #p p on p.idPregunta = d.idPregunta where d.estado = 1

		alter table #p drop column ID
		alter table #p add ID int
		update #p set idFormulario = coalesce(@idFormulario,idFormulario),pregunta = @nombre, ID = @ID

		declare @maxIndex int = (select max(_index)+1 from preguntas where idFormulario = @idFormulario and estado = 1)

		--Duplicando pregunta
		insert into preguntas
		(pregunta,idTipo,idEncuesta,idFormato,estado,_index,requerir,idFormulario,mask,fx,
			referenceTable,referenceId,referenceValue,referenceFk,idPreguntaFk,idRF,isHidden,_default,idTipoPhoto,indexReference)
		select 
			s.pregunta,s.idTipo,s.idEncuesta,s.idFormato,s.estado,@maxIndex,s.requerir,s.idFormulario,s.mask,s.fx,
			s.referenceTable,s.referenceId,s.referenceValue,s.referenceFk,s.idPreguntaFk,s.idRF,s.isHidden,s._default,s.idTipoPhoto,s.indexReference
		from preguntas p 
		right outer join #p s on s.ID = p.idPregunta
		where p.idPregunta is null

		declare @idPreguntaN int = scope_identity()

		update p
		set
			pregunta = s.pregunta,
			idTipo = s.idTipo,
			idFormato = s.idFormato,
			_index = @maxIndex,
			requerir = s.requerir,
			mask = s.mask,
			fx = s.fx,
			referenceTable = s.referenceTable,
			referenceId = s.referenceId,
			referenceValue = s.referenceValue,
			referenceFk = s.referenceFk,
			idPreguntaFk = s.idPreguntaFk,
			codigoAC = s.codigoAC,
			idRF = s.idRF,
			isHidden = s.isHidden,
			_default = s._default,
			idTipoPhoto = s.idTipoPhoto,
			indexReference = s.indexReference,
			estado = 1
		from preguntas p
		inner join #p s on rtrim(cast(s.pregunta as varchar(max))) = rtrim(cast(p.pregunta as varchar(max))) and p.estado != 1
		where @idPreguntaN is null

		update #p set ID = coalesce(@idPreguntaN, @ID),idFormulario = coalesce(@idFormulario,idFormulario)

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
			parent = s.parent
		from #dp t
		inner join(
			select 
				dp.idDependencia,
				p.ID,
				dp.parent
			from #p p
			left join #dp dp on dp.idPregunta = p.idPregunta
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

		insert dependenciasPregunta
		(idPregunta,parent,parentR,valorR,valorT,idOperador,idUnidad,indexG,fieldD1,estado)
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
		set @message = 'Pregunta duplicada correnctamente'
	end
	else begin
		set @error = 1
		set @message = 'No se puede duplicar una pregunta con el mismo nombre'
	end

	if @rs is not null set @rs = (select @error as error, @message as message for json path, without_array_wrapper)
	else select @error as error, @message as message

	commit transaction t1
end
