	create procedure [dbo].[actualizarRespuesta](@idProspecto int,@idFormulario int, @idPregunta int, @key varchar(max),@value varchar(max))as
	begin
		set nocount on
			declare @error int, @message nvarchar(max)
			declare @indexF int,@indexR int,@sp varchar(3)=''''
			declare @data nvarchar(max) = (select respuestas from prospectos where idProspecto = @idProspecto)
	        
			declare @sql nvarchar(max) = 'set @indexF = (select [#] from(select [#]=ROW_NUMBER() over(order by (select 0))-1,idFormulario from openjson(@data)with(idFormulario int))t where idFormulario=@idFormulario)'
			exec sp_executesql @sql,N'@idFormulario int,@data nvarchar(max),@indexF int out',@idFormulario,@data,@indexF out
			        
			set @sql = concat(
				'set @indexR = (select top 1 [#] from(',
					'select # = row_number() over(order by (select 0))-1,idPregunta,observacion ',
				'from openjson(@data,''$[',@indexF,'].respuestas'')with(idPregunta int,observacion varchar(max)))t ',
				'where idPregunta = @idPregunta) '
			)
			begin try exec sp_executesql @sql,N'@idPregunta int,@data nvarchar(max),@indexR int out',@idPregunta,@data,@indexR out end try
			begin catch 
				set @error = error_number() set @message = error_message()
				print concat('---- Error: ',@error,'. ',@message,' ----')
				print concat(' Respuesta1(',@idProspecto,',',@idFormulario,',',@idPregunta,'"',@key,'","',@value,'"')
				print concat(' $[',@indexF,'].respuestas')
				print '----'
				print ' '
				--if(@error is not null)throw 50000,@message,1
			end catch
			
			if(@indexR is null) set @sql = concat('set @data = json_modify(@data,',@sp,'append $[',@indexF,'].respuestas',@sp,',json_query(',@sp,'{"idPregunta":',@idPregunta,',"',@key,'":"',@value,'"}',@sp,'))')
			else set @sql = concat('set @data = json_modify(@data,''$[',@indexF,'].respuestas[',@indexR,'].',@key,''',@value)')
			begin try exec sp_executesql @sql,N'@data nvarchar(max) out,@value varchar(max)',@data out,@value end try
			begin catch
				set @error = error_number() set @message = error_message()
				print concat('---- Error: ',@error,'. ',@message,' ----')
				print concat(' Respuesta2(',@idProspecto,',',@idFormulario,',',@idPregunta,'"',@key,'","',@value,'"')
				print concat(' $[',@indexF,'].respuestas[',@indexR,']')
				print '----'
				print ' '
				--if(@error is not null)throw 50000,@message,1
			end catch

			set @sql = ''
			if(@key = 'observacion2' and @value is null)
			begin
				if(@indexF is not null) set @sql = concat('set @data = json_modify(@data,''$[',@indexF,'].observado',''',0)')	
			end
			else if(@key = 'observacion2' and @value is not null)
			begin
				if(@indexF is not null) set @sql = concat('set @data = json_modify(@data,''$[',@indexF,'].observado',''',1)')	
			end
			
			begin try exec sp_executesql @sql,N'@data nvarchar(max) out',@data out end try
			begin catch
				set @error = error_number() set @message = error_message()
				print concat('---- Error: ',@error,'. ',@message,' ----')
				print concat(' Formulario(',@idProspecto,',',@idFormulario)
				print concat(' $[',@indexF,'].observado')
				print '----'
				print ' '
				--if(@error is not null)throw 50000,@message,1
			end catch
	        
			update prospectos set respuestas = @data where idProspecto=@idProspecto
			exec actualizarEncabezados @idProspecto
		set nocount off
	end
