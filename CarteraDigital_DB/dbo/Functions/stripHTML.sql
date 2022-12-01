create function [dbo].[stripHTML]( @text varchar(max) ) returns varchar(max) as 
begin 
    declare @textXML xml 
    declare @result varchar(max) 
    set @textXML = @text; 
    with doc(contents) as 
    ( 
        select chunks.chunk.query('.') from @textXML.nodes('/') as chunks(chunk) 
    ) 
    select @result = contents.value('.', 'varchar(max)') from doc 
    return @result 
end 
