create procedure [dbo].[generarColor] as
begin
	declare @color1 varchar(max)
	declare @color2 varchar(max)
	declare @a int = 0

	while @a < 3
	begin
		set @color1 = convert(varchar(8),convert(varbinary(1), cast(round(((1 - 255 -1) * rand() + 255), 0) as int)),2)
		set @color2 = concat(@color1,@color2)
		set @a = @a +1
	end

	select @color2
end
