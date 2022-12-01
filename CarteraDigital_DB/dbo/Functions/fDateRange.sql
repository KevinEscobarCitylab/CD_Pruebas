	create   function [dbo].[fDateRange](@fecha varchar(max), @part int)returns varchar(max) as
	begin
		declare @fecha3 table(
			id int identity(1,1),
			fecha date
		)
		insert into @fecha3 (fecha)
		select cast(substring(value, 7, 4) + '/' + substring(value, 4, 2) + '/' + substring(value, 1, 2) as date) from STRING_SPLIT(replace(@fecha,' ',''),'-')
		if(@part = 1) begin
			return(select fecha from @fecha3 where id = 1)
		end
		else begin
			return(select fecha from @fecha3 where id = 2)
		end

		return null
	end
