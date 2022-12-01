CREATE function [dbo].[fPolicy](@clave varchar(max))returns int as
begin
	return (
	select 
	case when 
		@clave collate Latin1_General_BIN like '%[a-z]%[a-z]%' AND --al menos dos letras minusculas
		@clave collate Latin1_General_BIN like '%[A-Z]%' AND --por lo menos una letra mayúscula
		@clave like '%[0-9]%' and --al menos un número
		@clave like '%[~!@#$^&-_)(=.?+%*¿/]%' and -- por lo menos un caracter especial
		LEN(@clave) >= 8 -- no menos de 8 caracteres
	THEN 1 ELSE 0 END AS Valid
	)
end
