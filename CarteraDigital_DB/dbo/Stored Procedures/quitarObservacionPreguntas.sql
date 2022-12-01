	CREATE procedure [dbo].[quitarObservacionPreguntas](@idProspecto varchar(max),@idFormulario int, @respuestas varchar(max) output)as
	begin

		declare @data varchar(max),@indexF int,@indexR int, @data2 varchar(max)
		set @data  = (select respuestas from prospectos where idProspecto = @idProspecto)

		declare @sql nvarchar(max) = 'set @indexF = (select [#] from(select [#]=ROW_NUMBER() over(order by (select 0))-1,idFormulario from openjson(@data)with(idFormulario int))t where idFormulario=@idFormulario)'
		exec sp_executesql @sql,N'@idFormulario int,@data nvarchar(max),@indexF int out',@idFormulario,@data,@indexF out

		set @sql = concat(
			'set @respuestas = (select * from openjson(@data,''$[',@indexF,'].respuestas'')',
			'with(idPregunta int, observacion varchar(max), idRespuesta int, idRespuestaT varchar(max), idRM varchar(max)) for json path)'
		)
		exec sp_executesql @sql,N'@data nvarchar(max),@respuestas nvarchar(max) out',@data,@respuestas out

		set @sql = concat(
			'set @data = json_modify(@data,''$[',@indexF,'].respuestas'',json_query(''',@respuestas,'''))'	
		)
		exec sp_executesql @sql,N'@data nvarchar(max) out,@respuestas nvarchar(max)',@data out,@respuestas

		set @sql = concat(
			'set @data2 = json_modify(@data,''$[',@indexF,'].observado'',0)'	
		)

		exec sp_executesql @sql,N'@data nvarchar(max), @data2 nvarchar(max) out',@data, @data2 out

		set @respuestas = @data2
	end
