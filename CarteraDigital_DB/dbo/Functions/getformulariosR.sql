CREATE FUNCTION [dbo].[getformulariosR] (@idProspecto int)returns @returntable table
(
	[idFormulario] [int] NULL,
	[fechaCreacion] [datetime] NULL,
	[totalCampos] [int] NULL,
	[observado] [int] NULL
)
AS
BEGIN
	INSERT @returntable
	select 
		* 
	from openjson((select 
			respuestas 
		from prospectos 
		where idProspecto = @idProspecto)
	) with(
		idFormulario int, 
		fechaCreacion datetime,
		totalCampos int, 
		observado int
	)

	RETURN
END
