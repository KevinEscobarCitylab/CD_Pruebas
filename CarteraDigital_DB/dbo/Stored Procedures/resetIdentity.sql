CREATE procedure [dbo].[resetIdentity](@table varchar(50),@n int) as begin
	declare @Expression varchar(300)
	set @Expression = concat('DBCC CHECKIDENT (',@table,',RESEED,',@n,')');
	execute(@Expression)
end

