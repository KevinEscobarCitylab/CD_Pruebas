CREATE TABLE [dbo].[agencias] (
    [idAgencia]        INT             IDENTITY (1, 1) NOT NULL,
    [idAgenciaT]       VARCHAR (25)    NULL,
    [agencia]          VARCHAR (100)   NULL,
    [idZona]           INT             NULL,
    [totalRuta]        INT             NULL,
    [estado]           INT             NULL,
    [idRegion]         INT             NULL,
    [rango]            DECIMAL (10, 2) NULL,
    [diferencia]       DECIMAL (10, 2) NULL,
    [limite]           DECIMAL (10, 2) NULL,
    [minimoBusqueda]   INT             NULL,
    [idCategoria]      INT             NULL,
    [notaCD]           DECIMAL (10, 2) NULL DEFAULT 0,
    [porceMora]        DECIMAL (10, 2) NULL,
    [diasMora]         DECIMAL (10, 2) NULL,
    [promedioGestion]  DECIMAL (10, 2) NULL DEFAULT 0,
    [saldoCartera]     DECIMAL (18, 2) NULL,
    [porceMontoMora30] DECIMAL (10, 2) NULL,
    CONSTRAINT [PK_agencias] PRIMARY KEY CLUSTERED ([idAgencia] ASC),
    CONSTRAINT [FK_agencias_idZona] FOREIGN KEY ([idZona]) REFERENCES [dbo].[zonas] ([idZona])
);


GO

CREATE INDEX [IX_agencias_idZona] ON [dbo].[agencias] ([idZona])

GO

CREATE INDEX [IX_agencias_estado] ON [dbo].[agencias] ([estado])
