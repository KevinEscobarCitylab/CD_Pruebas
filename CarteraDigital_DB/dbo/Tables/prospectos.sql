CREATE TABLE [dbo].[prospectos] (
    [idProspecto]           INT             IDENTITY (1, 1) NOT NULL,
    [idGestor]              INT             NULL,
    [etapa]                 INT             NULL,
    [fecha]                 DATETIME        NULL,
    [latitud]               VARCHAR (25)    NULL,
    [longitud]              VARCHAR (25)    NULL,
    [puntosPrecalificacion] DECIMAL (10, 2) NULL,
    [idGrupoAdesco]         INT             NULL,
    [d1]                    NVARCHAR(MAX)            NULL,
    [latitudNegocio]        VARCHAR (75)    NULL,
    [longitudNegocio]       VARCHAR (75)    NULL,
    [idCredito]             INT             NULL,
    [renovado]              INT             NULL,
    [encabezado]            VARCHAR(MAX)            NULL,
    [edad]                  VARCHAR(MAX)            NULL,
    [extra]                 VARCHAR(MAX)            NULL,
    [enProceso]             INT             NULL,
    [actualizado]           INT             NULL,
    [d2]                    NVARCHAR(MAX)            NULL,
    [monto]                 DECIMAL (20, 2) NULL,
    [nombreC]               VARCHAR (150)   NULL,
    [direccion]             VARCHAR (300)   NULL,
    [nDoc]                  VARCHAR (50)    NULL,
    [lineaC]                VARCHAR (150)   NULL,
    [telefono]              VARCHAR (150)   NULL,
    [idCliente]             INT             NULL,
    [fechaGPSCasa]          DATETIME        NULL,
    [fechaGPSNegocio]       DATETIME        NULL,
    [d3]                    NVARCHAR(MAX)            NULL,
    [rechazado]             INT             NULL,
    [ID]                    INT             NULL,
    [tipoCliente]           VARCHAR (200)   NULL,
    [idPT]                  INT             NULL,
    [idUsuario]             INT             NULL,
    [respuestas]            VARCHAR (MAX)   NULL,
    [idEncuesta]            INT             NULL,
    [d4]                    NVARCHAR(MAX)            NULL,
    [ciclo]                 VARCHAR (25)    NULL,
    [idUsuarioR]            INT             NULL,
    [correo]                VARCHAR (150)   NULL,
    [asignarA]              VARCHAR (150)   NULL,
    [enviado]               INT             NULL,
    [eventos]               VARCHAR(MAX)            NULL,
    [isNew]                 BIT              NOT NULL DEFAULT ((0)),
    [observado]             INT             NULL,
    [fechaObservacion]      DATETIME        NULL,
    [formularios]           VARCHAR(150)    NULL,
    CONSTRAINT [PK_prospectos] PRIMARY KEY CLUSTERED ([idProspecto] ASC),
    CONSTRAINT [FK_prospectos_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente]),
    CONSTRAINT [FK_prospectos_idEncuesta] FOREIGN KEY ([idEncuesta]) REFERENCES [dbo].[encuestas] ([idEncuesta]),
    CONSTRAINT [FK_prospectos_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_prospectos_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_prospectos_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco])
);


GO

CREATE INDEX [IX_prospectos_idCliente] ON [dbo].[prospectos] ([idCliente])

GO

CREATE INDEX [IX_prospectos_idEncuesta] ON [dbo].[prospectos] ([idEncuesta])

GO

CREATE INDEX [IX_prospectos_idGestor] ON [dbo].[prospectos] ([idGestor])

GO

CREATE INDEX [IX_prospectos_idCredito] ON [dbo].[prospectos] ([idCredito])

GO

CREATE INDEX [IX_prospectos_idGrupoAdesco] ON [dbo].[prospectos] ([idGrupoAdesco])

GO

CREATE INDEX [IX_prospectos_etapa] ON [dbo].[prospectos] ([etapa])

GO

CREATE INDEX [IX_prospectos_observado]ON [dbo].[prospectos] ([observado])
