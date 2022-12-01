CREATE   function [dbo].[fParameters](@name varchar(max))returns varchar(max) as
begin
	IF (select count(1) from openjson((select [conf] from parametros)) where [key]=@name) != 0
    begin
        return (select [value] from openjson((select [conf] from parametros)) where [key]=@name)
    end
    return null
end
