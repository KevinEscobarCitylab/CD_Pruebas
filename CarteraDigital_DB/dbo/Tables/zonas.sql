CREATE TABLE [dbo].[zonas] (
    [idZona]       INT             IDENTITY (1, 1) NOT NULL,
    [idZonaT]      VARCHAR (50)    NULL,
    [zona]         VARCHAR (50)    NULL,
    [estado]       INT             NULL,
    [saldoCartera] DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_zonas] PRIMARY KEY CLUSTERED ([idZona] ASC)
);


GO

CREATE INDEX [IX_zonas_estado] ON [dbo].[zonas] ([estado])
