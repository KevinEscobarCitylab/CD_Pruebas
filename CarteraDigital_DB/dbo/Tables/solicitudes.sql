CREATE TABLE [dbo].[solicitudes] (
    [idSolicitud]      INT             IDENTITY (1, 1) NOT NULL,
    [idSolicitudT]     BIGINT          NULL,
    [idGestor]         INT             NULL,
    [fecha]            DATE            NULL,
    [idCliente]        INT             NULL,
    [codigo]           VARCHAR (150)   NULL,
    [idLineaCredito]   INT             NULL,
    [montoSolicitado]  DECIMAL (10, 2) NULL,
    [idPrioridad]      INT             NULL,
    [prioridadAgencia] INT             NULL,
    [prioridad]        INT             NULL,
    [diasPrioridad]    INT             NULL,
    [fechaPrioridad]   DATE            NULL,
    [idTipoSolicitud]  INT             NULL,
    [diasSolicitud]    INT             NULL,
    [totalGestiones]   INT             NULL,
    [estado]           INT             NULL,
    CONSTRAINT [PK_solicitudes] PRIMARY KEY CLUSTERED ([idSolicitud] ASC),
    CONSTRAINT [FK_solicitudes_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente]),
    CONSTRAINT [FK_solicitudes_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_solicitudes_idLineaCredito] FOREIGN KEY ([idLineaCredito]) REFERENCES [dbo].[lineasCredito] ([idLineaCredito]),
    CONSTRAINT [FK_solicitudes_idPrioridad] FOREIGN KEY ([idPrioridad]) REFERENCES [dbo].[prioridades] ([idPrioridad]),
    CONSTRAINT [FK_solicitudes_idTipoSolicitud] FOREIGN KEY ([idTipoSolicitud]) REFERENCES [dbo].[tiposSolicitudes] ([idTipoSolicitud])
);


GO

CREATE INDEX [IX_solicitudes_idCliente] ON [dbo].[solicitudes] ([idCliente])

GO

CREATE INDEX [IX_solicitudes_idGestor] ON [dbo].[solicitudes] ([idGestor])

GO

CREATE INDEX [IX_solicitudes_idLineaCredito] ON [dbo].[solicitudes] ([idLineaCredito])

GO

CREATE INDEX [IX_solicitudes_idPrioridad] ON [dbo].[solicitudes] ([idPrioridad])

GO

CREATE INDEX [IX_solicitudes_idTipoSolicitud] ON [dbo].[solicitudes] ([idTipoSolicitud])

GO

CREATE INDEX [IX_solicitudes_estado] ON [dbo].[solicitudes] ([estado])
