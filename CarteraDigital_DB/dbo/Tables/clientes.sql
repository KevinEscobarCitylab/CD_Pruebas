CREATE TABLE [dbo].[clientes] (
    [idCliente]                    INT             IDENTITY (1, 1) NOT NULL,
    [idClienteT]                   VARCHAR (25)    NULL,
    [codigo]                       VARCHAR (25)    NULL,
    [nombre]                       VARCHAR (200)   NULL,
    [telefono]                     VARCHAR (150)   NULL,
    [direccion]                    VARCHAR(MAX)            NULL,
    [idActividadE]                 INT             NULL,
    [tipoCliente]                  VARCHAR (5)     NULL,
    [diasDesertado]                INT             NULL,
    [fechaDesertado]               DATE            NULL,
    [porDesertar]                  INT             NULL,
    [diasPorDesertar]              INT             NULL,
    [diasDesembolso]               INT             NULL,
    [fechaPorDesertar]             DATE            NULL,
    [latitud]                      VARCHAR (75)    NULL,
    [longitud]                     VARCHAR (75)    NULL,
    [latitudNegocio]               VARCHAR (75)    NULL,
    [longitudNegocio]              VARCHAR (75)    NULL,
    [idEstado]                     INT             NULL,
    [nDoc]                         VARCHAR (50)    NULL,
    [curp]                         VARCHAR (50)    NULL,
    [desertado]                    INT             NULL,
    [ciclo]                        INT             NULL,
    [imgCasa]                      VARCHAR (150)   NULL,
    [imgNegocio]                   VARCHAR (150)   NULL,
    [pendienteCasa]                INT             NULL,
    [pendienteNegocio]             INT             NULL,
    [fechaGPSCasa]                 DATETIME        NULL,
    [fechaGPSNegocio]              DATETIME        NULL,
    [idProbabilidadIncumplimiento] INT             NULL,
    [idSegmento]                   INT             NULL,
    [idGestorGPSCasa]              INT             NULL,
    [idGestorGPSNegocio]           INT             NULL,
    [tipoCreditos]                 VARCHAR (25)    NULL,
    [promedioGestionAlSalirMora]   DECIMAL (10, 2) NULL,
    [numGestionesCob]              INT             NULL,
    [avgGestionesCob]              DECIMAL (10, 2) NULL,
    [acuerdosCumplidos]            DECIMAL (10, 2) NULL,
    [numFiadores]                  INT             NULL,
    [gestionesPrevSalirMora]       DECIMAL (10, 4) NULL,
    [atraso_Promedio]              DECIMAL (10, 2) NULL,
    [imf]                          INT             NULL,
    [atraso_Maximo]                INT             NULL,
    [monto_Maximo_Atraso]          DECIMAL (10, 2) NULL,
    [AVGDiasGestionSalirMora]      DECIMAL (10, 2) NULL,
    [notaCD]                       DECIMAL (10, 2) NULL,
    CONSTRAINT [PK_clientes] PRIMARY KEY CLUSTERED ([idCliente] ASC),
    CONSTRAINT [FK_clientes_idGestorGPSCasa] FOREIGN KEY ([idGestorGPSCasa]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_clientes_idGestorGPSNegocio] FOREIGN KEY ([idGestorGPSNegocio]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_clientes_idEstado] FOREIGN KEY ([idEstado]) REFERENCES [dbo].[estadosCliente] ([idEstadoCliente])
);


GO

CREATE INDEX [IX_clientes_idEstado] ON [dbo].[clientes] ([idEstado])

GO

CREATE INDEX [IX_clientes_desertado] ON [dbo].[clientes] ([desertado])

GO

CREATE INDEX [IX_clientes_idGestorGPSNegocio] ON [dbo].[clientes] ([idGestorGPSNegocio])

GO

CREATE INDEX [IX_clientes_idGestorGPSCasa] ON [dbo].[clientes] ([idGestorGPSCasa])
