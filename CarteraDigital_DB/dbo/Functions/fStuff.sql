create function fStuff(@xml varchar(max))returns varchar(max)
as begin
	return coalesce(stuff(@xml,1,1,''),'')
end
