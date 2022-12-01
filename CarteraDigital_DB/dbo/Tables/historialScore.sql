CREATE TABLE [dbo].[historialScore]
(
	[idHistorialScore]	INT					IDENTITY (1, 1) NOT NULL,
	[idCliente]			INT					NULL,
	[idGestor]			INT					NULL,
	[idAgencia]			INT					NULL,
	[scoreCliente]		DECIMAL (18, 2)		NULL,
	[scoreGestor]		DECIMAL (18, 2)		NULL,
	[scoreAgencia]		DECIMAL (18, 2)		NULL,
	[scoreCD]			DECIMAL (18, 2)		NULL,
	[fechaSolicitud]	DATETIME			NOT NULL DEFAULT (GETDATE ()),
	CONSTRAINT [PK_historialScore] PRIMARY KEY CLUSTERED ([idHistorialScore] ASC)
)
