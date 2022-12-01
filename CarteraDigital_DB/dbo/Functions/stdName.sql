create function [dbo].[stdName](@text nvarchar(max))returns nvarchar(max) as
begin
	return dbo.fStuff((select concat(' ',substring(upper([value]),1,1),lower(substring([value],2,len([value])))) from string_split(@text,' ') for xml path('')))
end
