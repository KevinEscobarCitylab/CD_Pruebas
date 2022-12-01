create procedure [dbo].[actualizarEncabezados](@idProspecto int, @errorNumber int=null out, @warning varchar(max) = null out) as
begin
	
	declare @data varchar(max)= (select respuestas from prospectos where idProspecto = @idProspecto)
	declare @dt table(# int,idFormulario int)
	insert @dt select #=row_number() over(order by (select 1))-1,* from openjson(@data)with(idFormulario int)
	declare @total int=(select count(1) from @dt),@index int = 0, @sp varchar(3) = ''''

	declare @m varchar(max)='''';
		
	declare @sqlEC nvarchar(max) = replace((select
		concat('update prospectos set ',alias,'=',@m,rtrim(replace(valor,@m,concat(@m,@m))),@m,' where idProspecto = @idProspecto ')
	from(
		select 
			idProspecto = @idProspecto,
			et.alias,				
			valor = (
				select 
					concat(rtrim(cast(obs.respuesta as varchar(max))),' ') 
				from solicitudR1(@idProspecto) obs 
				inner join encabezadoEncuesta ee on ee.idPregunta = obs.idPregunta
				inner join encabezadoTipo et1 on et1.idET = ee.idET
				where ee.idET = ee1.idET and ee.estado = 1 and dbo.notEmpty(respuesta) is not null group by obs.idPregunta,obs.respuesta,_index order by _index for xml path('')
			)
		from encabezadoEncuesta ee1
		inner join encabezadoTipo et on et.idET = ee1.idET
		inner join preguntas p on p.idPregunta = ee1.idPregunta
		inner join solicitudR1(@idProspecto) obs1 on obs1.idPregunta = p.idPregunta
		inner join (select column_name from ..INFORMATION_SCHEMA.COLUMNS where table_name = 'prospectos') sd on sd.column_name = et.alias
		where ee1.estado = 1
		group by ee1.idEt,et.alias
	) as dt where idProspecto is not null and dbo.notEmpty(valor) is not null for xml path('')),' ,',' ')
				
	begin try exec sp_executesql @sqlEC,N'@idProspecto int,@m varchar(max)',@idProspecto,@m end try
	begin catch select @errorNumber= ERROR_NUMBER(), @warning = ERROR_MESSAGE()	end catch

	--Actualizando GPS casa y negocio a prospectos
	declare @latitud varchar(max)=null, @longitud varchar(max)=null, @latitudNegocio varchar(max)=null, @longitudNegocio varchar(max)=null,@fechaC datetime=null, @fechaN datetime=null
	select
		@latitud = iif(ee.idET = 10,substring(r.respuesta,0,charindex(',',r.respuesta)),null),
		@longitud = iif(ee.idET = 10, substring(r.respuesta,charindex(',',r.respuesta)+1,LEN(r.respuesta)),null),
		@fechaC = iif(ee.idET = 10, current_timestamp, null),
		@latitudNegocio = iif(ee.idET = 11,substring( r.respuesta,0,charindex(',',r.respuesta)),null),
		@longitudNegocio = iif(ee.idET = 11, substring(r.respuesta,charindex(',',r.respuesta)+1,LEN(r.respuesta)),null),
		@fechaN = iif(ee.idET = 11, current_timestamp, null)
	from encabezadoEncuesta ee
	inner join encabezadoTipo et on et.idET = ee.idET
	inner join solicitudR1(@idProspecto) r on r.idPregunta = ee.idPregunta
	where ee.idET in(10,11) and cast(r.respuesta as varchar(max)) != ''

	update p
	set 
		latitud = coalesce(@latitud,latitud), 
		longitud = coalesce(@longitud,longitud),
		latitudNegocio = coalesce(@latitudNegocio,latitudNegocio),
		longitudNegocio = coalesce(@longitudNegocio,longitudNegocio),
		fechaGPSCasa = coalesce(@fechaC,fechaGPSCasa),
		fechaGPSNegocio = coalesce(@fechaN,fechaGPSNegocio)
	from prospectos p
	where idProspecto = @idProspecto
end
