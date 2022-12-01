	create procedure [dbo].[agregarFormularioR](@idFormulario int,@frData nvarchar(max),@db nvarchar(max) out) as 
	begin
		set nocount on
			declare @error int, @message nvarchar(max)
			declare @dt table(# int,idFormulario int)
			insert @dt select #=row_number() over(order by (select 1))-1,*from openjson(@db)with(idFormulario int)
			declare @total int = (select count(1) from @dt),@index int = 0, @existe bit = 0
			
			while @index < @total begin
				declare @sp varchar(max) = '''',@idFormularioS int = 0
				declare @sql nvarchar(max) = concat('set @ID = (select *from openjson(@d,',@sp,'$[',@index,']',@sp,')with(idFormulario int))')
				exec sp_executesql @sql,N'@ID int out,@d nvarchar(max)',@idFormularioS out,@db
				if(@idFormulario = @idFormularioS)begin
					set @existe = 1
					set @sql = concat('set @data = JSON_MODIFY(@data,',@sp,'$[',@index,']',@sp,',JSON_QUERY(@rw))')	
					begin try exec sp_executesql @sql,N'@data nvarchar(max) out,@rw nvarchar(max)',@db out,@frData end try
					begin catch 
						set @error = error_number() set @message  = error_message()
						print ' '
						print concat('---- Error:',@error,', ',@message,' ----')
						print concat(' Actualizar[',@index,'], F:',@idFormulario)
						print '----'
						--if(@error is not null)throw 50000,@message,1
					end catch
					set @index = @total + 1
				end
				set @index +=1
			end
			if(@existe = 0)begin
				set @sql = 'set @data = JSON_MODIFY(@data,''append $'',JSON_QUERY(@rw))'
				begin try exec sp_executesql @sql,N'@data nvarchar(max) out,@rw nvarchar(max)',@db out,@frData end try
				begin catch 
					set @error = error_number() set @message  = error_message()
					print ' '
					print concat('---- Error:',@error,', ',@message,' ----')
					print concat(' Agregar[',@total,'], F:',@idFormulario)
					print '----'
					--if(@error is not null)throw 50000,@message,1
				end catch
			end
		set nocount off
	end
