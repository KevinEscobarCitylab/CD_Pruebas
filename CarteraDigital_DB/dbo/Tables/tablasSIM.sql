CREATE TABLE [dbo].[tablasSIM] (
    [idTablaSIM]  INT          IDENTITY (1, 1) NOT NULL,
    [nombre]      VARCHAR (50) NULL,
    [descripcion] VARCHAR (75) NULL,
	[estado]      INT NULL,
	[parent]      VARCHAR (50) NULL
    CONSTRAINT [PK_tablasSIM] PRIMARY KEY CLUSTERED ([idTablaSIM] ASC)
);


GO

CREATE INDEX [IX_tablasSIM_estado] ON [dbo].[tablasSIM] ([estado])
