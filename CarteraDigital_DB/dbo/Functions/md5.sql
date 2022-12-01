CREATE function [dbo].[md5](@text varchar(150))
returns varchar(150)
as begin
	return CONVERT(varchar(200),HASHBYTES('MD5',@text),2)
end
