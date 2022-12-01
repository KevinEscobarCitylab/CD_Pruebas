declare @tableName varchar(max) = 'preguntas',@constraint varchar(max) = 'parent',@fk varchar(max),@sql nvarchar(max)
if(COL_LENGTH(@tableName,@constraint)is not null)begin 
	set @fk =(select c.name from sys.objects c left join sys.foreign_key_columns as d on d.constraint_object_id = c.object_id left join sys.columns sc on sc.column_id =d.parent_column_id and sc.object_id = d.parent_object_id where c.parent_object_id = (select object_id from sys.objects where type = 'U' and name = @tableName and sc.name = @constraint))
	if(@fk is not null)begin
		set @sql = concat('alter table preguntas drop constraint ',@fk)
		exec sp_executesql @sql
	end
	alter table preguntas drop column parent
end

set @constraint = 'parentR'
if(COL_LENGTH(@tableName,@constraint)is not null)begin 
	set @fk =(select c.name from sys.objects c left join sys.foreign_key_columns as d on d.constraint_object_id = c.object_id left join sys.columns sc on sc.column_id =d.parent_column_id and sc.object_id = d.parent_object_id where c.parent_object_id = (select object_id from sys.objects where type = 'U' and name = @tableName and sc.name = @constraint))
	if(@fk is not null)begin
		set @sql = concat('alter table preguntas drop constraint ',@fk)
		exec sp_executesql @sql
	end
	alter table preguntas drop column parentR
end
set @constraint = 'valorR'
if(COL_LENGTH(@tableName,@constraint)is not null)begin
	set @fk =(select c.name from sys.objects c left join sys.foreign_key_columns as d on d.constraint_object_id = c.object_id left join sys.columns sc on sc.column_id =d.parent_column_id and sc.object_id = d.parent_object_id where c.parent_object_id = (select object_id from sys.objects where type = 'U' and name = @tableName and sc.name = @constraint))
	if(@fk is not null)begin
		set @sql = concat('alter table preguntas drop constraint ',@fk)
		exec sp_executesql @sql
	end
	alter table preguntas drop column valorR
end

set @constraint = 'idOperador'
if(COL_LENGTH(@tableName,@constraint)is not null)begin
	set @fk =(select c.name from sys.objects c left join sys.foreign_key_columns as d on d.constraint_object_id = c.object_id left join sys.columns sc on sc.column_id =d.parent_column_id and sc.object_id = d.parent_object_id where c.parent_object_id = (select object_id from sys.objects where type = 'U' and name = @tableName and sc.name = @constraint))
	if(@fk is not null)begin
		set @sql = concat('alter table preguntas drop constraint ',@fk)
		exec sp_executesql @sql
	end
	alter table preguntas drop column idOperador
end
set @constraint = 'idUnidad'
if(COL_LENGTH(@tableName,@constraint)is not null)begin
	set @fk =(select c.name from sys.objects c left join sys.foreign_key_columns as d on d.constraint_object_id = c.object_id left join sys.columns sc on sc.column_id =d.parent_column_id and sc.object_id = d.parent_object_id where c.parent_object_id = (select object_id from sys.objects where type = 'U' and name = @tableName and sc.name = @constraint))
	if(@fk is not null)begin
		set @sql = concat('alter table preguntas drop constraint ',@fk)
		exec sp_executesql @sql
	end
	alter table preguntas drop column idUnidad
end