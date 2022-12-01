create procedure [dbo].[actualizarInfoExtendida] as
begin
	declare @cultureInfo varchar(max), @useCI_CRED bit, @infoEGrupos bit,@CI_CRED varchar(50),@sp varchar(5) = ''''

	select 
		@cultureInfo = cultureInfo,
		@useCI_CRED = usarInfoE_CI_Credito,
		@infoEGrupos = procesarInfoE_Grupos,
		@CI_CRED = iif(usarInfoE_CI_Credito = 1,'cultureInfo',concat(@sp,@cultureInfo,@sp))
	from openjson((select conf from parametros where idParametro = 1))with(cultureInfo varchar(10), usarInfoE_CI_Credito bit, procesarInfoE_Grupos bit)

	declare @infoE varchar(max)= (select 
	concat(
		',',
		(case idCategoria
			when 1 then 'iif(diasCapitalMora > 0,'
			when 2 then 'iif(seguimiento = 1,'
			when 3 then 'iif(desertado = 1,'
			when 4 then 'iif(renovacion = 1,'
			else ','
		end),
		('concat(''alias!valor'','+dbo.fStuff((select concat(','';',descripcion,'!'',',iif(formato is not null,concat('format(',codigo,',''',formato,''',',@CI_CRED,')'),concat('rtrim(concat(''',simboloInicial,''',',codigo,',''',simboloFinal,'''))'))) from infoExtendida where idCategoria = c.idCategoria and emergente = 0 and tipo = 1 and estado = 1 order by _index for xml path('')))+')')
	)
	from categoriasInfoExtendida c
	order by _index
	for xml path(''))

	declare @popup varchar(max) = (
	select 
		concat(
		',',
		(case idCategoria
			when 1 then 'iif(diasCapitalMora > 0,'
			when 2 then 'iif(seguimiento = 1,'
			when 3 then 'iif(desertado = 1,'
			when 4 then 'iif(renovacion = 1,'
			else ','
		end),
		iif(idCategoria != 5,concat('(select *from(select ''',categoria,''' as Actividad,(select *from(',replace(dbo.fStuff((select concat('!select ''',descripcion,''' as [name],',iif(formato is not null,concat('format(',codigo,',''',formato,''',',@CI_CRED,')'),concat('rtrim(concat(''',simboloInicial,''',',codigo,',''',simboloFinal,'''))')),' as [value] ') from infoExtendida where idCategoria = c.idCategoria and emergente = 1 and tipo = 1 and estado = 1 for xml path(''))),'!',' union '),')as dt for json path) as params)as ds for json path, without_array_wrapper)'),'null)'))
	from categoriasInfoExtendida c 
	order by _index for xml path(''))

	declare @sql nvarchar(max) = 'update t set t.infoE = s.infoE, t.emergentes = s.popup from creditos t inner join('
	set @sql +=concat( 'select idCredito,',replace(replace(dbo.fStuff(@infoE),',,',','),'&gt;','>'),')))) as infoE,',replace(replace(dbo.fStuff(@popup),',,',','),'&gt;','>'),'))) as popup',' from infoExtendidaC_v')
	set @sql +=')s on s.idCredito = t.idCredito'
		
	exec sp_executesql @sql
	if(coalesce(@infoEGrupos,0)=0)return

	--grupos
	set @infoE = (select 
	concat(
		',',
		(case idCategoria
			when 1 then 'iif(totalMora > 0,'
			when 2 then 'iif(totalVenceHoy = 1,'
			when 4 then 'iif(totalrenovacion = 1,'
			else ','
		end),
		('concat(''alias!valor'','+dbo.fStuff((select concat(','';',descripcion,'!'',',iif(formato is not null,concat('format(',codigo,',''',formato,''',''',@cultureInfo,''')'),concat('rtrim(concat(''',simboloInicial,''',',codigo,',''',simboloFinal,'''))'))) from infoExtendida where idCategoria = c.idCategoria and emergente = 0 and tipo = 2 and estado = 1 for xml path('')))+')')
	)
	from categoriasInfoExtendida c where idCategoria not in(3)
	order by _index
	for xml path(''))

	set @popup = (select 
		concat(
		',',
		(case idCategoria
			when 1 then 'iif(totalMora > 0,'
			when 4 then 'iif(totalrenovacion = 1,'
			else ','
		end),
		concat('(select *from(select ''',categoria,''' as Actividad,(select *from(',replace(dbo.fStuff((select concat('!select ''',descripcion,''' as [name],',iif(formato is not null,concat('format(',codigo,',''',formato,''',''',@cultureInfo,''')'),concat('rtrim(concat(''',simboloInicial,''',',codigo,',''',simboloFinal,'''))')),' as [value] ') from infoExtendida where idCategoria = c.idCategoria and emergente = 1 and tipo = 2 and estado = 1 for xml path(''))),'!',' union '),')as dt for json path) as params)as ds for json path, without_array_wrapper)'))
	from categoriasInfoExtendida c where idCategoria not in(2,3)
	order by _index for xml path(''))

	set @sql = 'update t set t.infoE = s.infoE, t.emergentes = s.popup from gruposAdesco t inner join('
	set @sql +=concat( 'select idGrupoAdesco,',replace(replace(dbo.fStuff(@infoE),',,',','),'&gt;','>'),'))) as infoE,',replace(replace(dbo.fStuff(@popup),',,',','),'&gt;','>'),')) as popup',' from infoExtendidaG_v')
	set @sql +=')s on s.idGrupoAdesco = t.idGrupoAdesco'

	--select @sql
	exec sp_executesql @sql
end
