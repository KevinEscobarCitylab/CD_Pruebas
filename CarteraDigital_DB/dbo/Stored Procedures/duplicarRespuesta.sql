	create procedure duplicarRespuesta(@idRespuesta int,@nombre varchar(max),@rs varchar(max) out) as 
	begin
		if(object_id('tempdb..#dr') is not null)drop table #r
		declare @error int,@message varchar(max)

		begin transaction t

		select *into #r from respuestas where idRespuesta = @idRespuesta

		if(select top 1 1 from #r where cast(respuesta as varchar(max))=@nombre) is null begin
			update #r set respuesta = @nombre

			insert respuestas
			(respuesta,idPregunta,valor,alias,ID,d1,_index,estado)	
			select 
				s.respuesta,
				s.idPregunta,
				s.valor,
				s.alias,
				s.ID,
				s.d1,
				s._index,
				1	
			from respuestas t
			right outer join #r s on s.idPregunta = t.idPregunta and cast(s.respuesta as varchar(max)) = cast(t.respuesta as varchar(max)) and t.estado != 1
			where t.idRespuesta is null

			declare @ID int= scope_identity()

			update t
			set 
				respuesta = s.respuesta,
				estado = 1
			from respuestas t
			inner join #r s on s.idPregunta = t.idPregunta and cast(s.respuesta as varchar(max)) = cast(t.respuesta as varchar(max))
			where @ID is null

			set @error =0
			set @message = 'Pregunta duplicada correnctamente'
		end
		else begin
			set @error = 1
			set @message = 'No se puede duplicar una respuesta con el mismo nombre'
		end
		if @rs is not null set @rs = (select @error as error, @message as message for json path, without_array_wrapper)
		else select @error as error, @message as message

		commit transaction t
	end
