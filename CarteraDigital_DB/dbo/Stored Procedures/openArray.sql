create  procedure openarray(@d nvarchar(max),@path nvarchar(max) = null)as
begin
	declare @piv nvarchar(max),@sql nvarchar(max),@bk nvarchar(max) = @d
	declare @tableName varchar(50), @pk varchar(50), @key varchar(50), @value varchar(50)
	set @path = dbo.notEmpty(@path)

	if(substring(@d,1,1) not in('[','{'))begin
		select 
			@key = iif(px = 1,value,@key),
			@tableName = iif(px = 2,value,@tableName),
			@value = iif(px = 3,value,@value),
			@pk = iif(px = 4,value,@pk)
		from(select px = row_number() over(order by(select 1)),value from string_split(@d,','))t
		if(@tableName is not null and @pk is null) set @pk = (select top 1 column_name from INFORMATION_SCHEMA.columns where table_name = @tableName)
		if(@pk is null) return
		
		if(@value is null)set @sql = concat('set @d = (select top 1 ',@key,' from ',@tableName,' order by ',@pk,' desc)')
		else set @sql = concat('set @d = (select ',@key,' from ',@tableName,' where ',@pk, '=''',@value,''')')
		print replace(@sql,'set @d','declare @d nvarchar(max)')
		exec sp_executesql @sql,N'@d nvarchar(max) out',@d out 
		set @bk = @d
	end

	if(@path = '$' or @path = '$.')set @path = null

	if(@path is not null)begin 
		if(@path like '$[[]%')begin
			set @sql = concat('set @d = json_query(@d,''',@path,''')')
			print @sql
			exec sp_executesql @sql,N'@d nvarchar(max) out',@d out 
			set @bk = @d
			set @path = null
		end
		else begin 
			set @sql = concat('set @d = (select *from openjson(@d)with(data nvarchar(max) ''',@path,''' as json))')
			exec sp_executesql @sql,N'@d nvarchar(max) out',@d out
		end
	end

	select 
		@piv = concat(
			@piv,
			iif(lag([key]) over(order by(select 1)) is null,'',','),
			case [key]
				when 'pivot' then '[pivot]'
				when 'index' then '[index]'
				when 'key'   then '[key]'
				else [key]
			end,
			' ', iif(type = 2 and value like '%.%','float',(
				case type
					when 1 then 'varchar(max)'
					when 2 then 'int'
					when 3 then 'bit'
					when 4 then 'nvarchar(max) as json'
					when 5 then 'nvarchar(max) as json'
					else 'varchar(max)'
				end
			))
		)	
	from openjson(@d,'$[0]')
	set @sql = concat('select *from openjson(@d',iif(@path is null,'',concat(',''',@path,'''')),')with(',@piv,')')
	if(@piv is not null)begin 
		print @sql
		set @sql = replace(@sql,'*','[index]=row_number()over(order by(select 1))-1,*') 
		exec sp_executesql @sql,N'@d nvarchar(max)',@bk 
	end
	else begin 
		print replace(@sql,'with()','')
		select *from openjson(@d) 
	end
end