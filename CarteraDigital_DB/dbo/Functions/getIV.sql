create function [dbo].[getIV](@apiKey varchar(max),@inc int)returns varchar(max)
begin
	declare @key varchar(max) = concat(@apiKey,format(DATEADD(minute,-@inc,current_timestamp),'yyyyMMddHHmm'))
	declare @l int = len(@key)
	declare @index int= @l
	while @index < 32 begin
		set @key = @key + substring(@key,@index - @l+1,1)
		set @index = @index + 1
	end
	return @key
end
