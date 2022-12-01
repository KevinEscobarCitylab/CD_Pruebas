CREATE function [dbo].[date_diff](@key varchar(max),@fecha1 datetime, @fecha2 datetime)returns int
begin
	set @key = UPPER(@key)
	if(@key = 'YEAR')return DATEDIFF(YEAR, @fecha1, @fecha2)
	else if(@key = 'MONTH')return DATEDIFF(MONTH, @fecha1, @fecha2)
	else if(@key = 'WEEK')return DATEDIFF(WEEK, @fecha1, @fecha2)
	else if(@key = 'DAY')return DATEDIFF(DAY, @fecha1, @fecha2)
	else if(@key = 'HOUR')return DATEDIFF(HOUR, @fecha1, @fecha2)
	else if(@key = 'MINUTE')return DATEDIFF(MINUTE, @fecha1, @fecha2)
	else if(@key = 'SECOND')return DATEDIFF(SECOND, @fecha1, @fecha2)
	return DATEDIFF(MILLISECOND,@fecha1, @fecha2)
end