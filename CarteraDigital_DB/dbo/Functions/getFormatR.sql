CREATE FUNCTION [dbo].[getFormatR](@idTipo int,@tipo varchar(50),@multiple int)returns int as 
begin
	return case @idTipo
	when 1 then ( case @tipo
		when 'string' then 0
		when 'int' then 1
		when 'float' then 2
		when 'date' then 3
		when 'img' then 4
		when 'file' then 5
		when 'math' then 6
		when 'gps' then 7
		when 'caps' then 8
		when 'name' then 9
		when 'geocode' then 10
		else -1
		end
	)
	when 2 then (case @tipo
		when 'autocomplete' then 14
		when 'list' then
			iif(@multiple =1,23,22)
		when 'api' then 16
		when 'b64f' then 17
		when 'datasource' then iif(@multiple =1,24,18)
		when 'script' then 19
		when 'loop' then 20
		when 'int' then (
			case (1)
			when 2 then 13
			when 3 then 14
			else 15
			end
		)
		when 'vmes' then 27
		when 'vsemanal' then 28
		when 'vdiario' then 29
		else -1
		end
	)
	when 3 then (case @tipo
		when 'datasource' then 24
		else 21
		end
	)
	else -1
	end
end
