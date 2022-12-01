	CREATE function [dbo].[fGetTypeFile]( @cad varchar(max), @tip int ) returns varchar(max) as 
	begin 
		DECLARE @result table(
			Id		INT identity(1,1) primary key clustered,
			result	varchar(max)
		)

		insert into @result (result)
		select value from string_split(@cad,'/')

		insert into @result (result)
		select value from string_split((select result from @result where Id = 4),'.')

		update @result set result = (select value from (select ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS id,value from string_split((select result from @result where Id = 6),'?')) dt where id = 1) where Id = 6

		return (select result from @result where Id = @tip) 
	end
