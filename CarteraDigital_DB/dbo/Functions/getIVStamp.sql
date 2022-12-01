create function [dbo].[getIVStamp](@IV varchar(max), @textE varchar(max))returns varchar(max)
begin
	declare @rs varchar(max) = (
		select IV from(
			select
				dbo.getIV(@IV,ID) as IV,
				dbo.wsp(concat('compare/',dbo.b64(( select dbo.getIV(@IV,ID) as IV, @textE as code for json path, without_array_wrapper))),null) as req
			from(
				select -1 as ID union
				select 0 as ID
			) as dt
		)as ds
		where req != 'keyError'
	)
	return @rs
end
