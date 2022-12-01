create function [dbo].[b64](@str varchar(max))returns varchar(max) as 
begin
	return (SELECT
		CAST(N'' AS XML).value(
			  'xs:base64Binary(xs:hexBinary(sql:column("bin")))'
			, 'VARCHAR(MAX)'
		)   Base64Encoding
		FROM (
			SELECT CAST(@str AS VARBINARY(MAX)) AS bin
		) AS bin_sql_server_temp)
end