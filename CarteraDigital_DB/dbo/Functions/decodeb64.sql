	create function [dbo].[decodeb64](@str varchar(max))returns varchar(max) as
    begin
        return (SELECT CAST( CAST( @str as XML ).value('.','varbinary(max)') AS varchar(max) ))
    end
