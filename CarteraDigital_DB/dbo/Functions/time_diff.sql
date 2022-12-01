create function time_diff(@key varchar(max),@time1 time, @time2 time)returns int
begin
	set @key = UPPER(@key)
	declare @fecha1 varchar(max) = concat('0001-01-01 ',cast(@time1 as varchar(max)))
	declare @fecha2 varchar(max) = concat('0001-01-01 ',cast(@time2 as varchar(max)))
	if(@key = 'HOUR')return DATEDIFF(HOUR,@fecha1,@fecha2);
	else if(@key = 'MINUNTE')return DATEDIFF(MINUTE,@fecha1,@fecha2);
	else if(@key = 'SECOND')return DATEDIFF(SECOND,@fecha1,@fecha2);
	return DATEDIFF(MILLISECOND,@fecha1,@fecha2);
end