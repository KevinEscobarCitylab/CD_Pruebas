CREATE TABLE [dbo].[registroActividades] (
    [idRegistroActividad]     INT             IDENTITY (1, 1) NOT NULL,
    [idReaccion]              INT             NULL,
    [idDetalle]               INT             NULL,
    [idActividad]             INT             NULL,
    [idCredito]               INT             NULL,
    [idCliente]               INT             NULL,
    [idClienteP]              INT             NULL,
    [idMotivo]                INT             NULL,
    [idCampania]              INT             NULL,
    [fecha]                   DATETIME        NULL,
    [idGestor]                INT             NULL,
    [observacion]             VARCHAR(MAX)    NULL,
    [latitud]                 VARCHAR (100)   NULL,
    [longitud]                VARCHAR (100)   NULL,
    [horaGPS]                 DATETIME        NULL,
    [etapa]                   INT             NULL,
    [telefono]                VARCHAR (25)    NULL,
    [fechaVisitaReprogramada] DATETIME        NULL,
    [idGrupo]                 INT             NULL,
    [idProspecto]             INT             NULL,
    [idPrioridad]             INT             NULL,
    [diasPrioridad]           INT             NULL,
    [diasGestion]             INT             NULL,
    [participantes]           INT             NULL,
    [idOrganizacion]          INT             NULL,
    [valid]                   INT             NULL,
    [idEncuestaR]             INT             NULL,
    [enviado]                 INT             NULL,
    [ID]                      INT             NULL,
    [fechaRegistro]           DATETIME        NULL,
    [idERtemp]                INT             NULL,
    [idPtemp]                 INT             NULL,
    [solicitudNueva]          INT             NULL,
    [idUsuario]               INT             NULL,
    [idFiador]                INT             NULL,
    [idClienteCampania]       INT             NULL,
    [whatsapp]                INT             NULL,
    [distancia]               DECIMAL (10, 2) NULL,
    [registroComparado]       INT             NULL,
    [gestionWeb]              INT             NULL,
    [idAgenciaGestion]        INT             NULL,
    CONSTRAINT [PK_registroActividades] PRIMARY KEY CLUSTERED ([idRegistroActividad] ASC),
    CONSTRAINT [FK_registroActividades_idClienteCampania] FOREIGN KEY ([idClienteCampania]) REFERENCES [dbo].[clientesCampania] ([idClienteCampania]),
    CONSTRAINT [FK_registroActividades_idFiador] FOREIGN KEY ([idFiador]) REFERENCES [dbo].[fiadores] ([idFiador]),
    CONSTRAINT [FK_registroActividades_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos] ([idProspecto]),
    CONSTRAINT [FK_registroActividades_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_registroActividades_idCampania] FOREIGN KEY ([idCampania]) REFERENCES [dbo].[campanias] ([idCampania]),
    CONSTRAINT [FK_registroActividades_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente]),
    CONSTRAINT [FK_registroActividades_idClienteP] FOREIGN KEY ([idClienteP]) REFERENCES [dbo].[clientesPotenciales] ([idClienteP]),
    CONSTRAINT [FK_registroActividades_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_registroActividades_idDetalle] FOREIGN KEY ([idDetalle]) REFERENCES [dbo].[detalleActividades] ([idDetalle]),
    CONSTRAINT [FK_registroActividades_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_registroActividades_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_registroActividades_idMotivo] FOREIGN KEY ([idMotivo]) REFERENCES [dbo].[motivoActividades] ([idMotivo]),
    CONSTRAINT [FK_registroActividades_idReaccion] FOREIGN KEY ([idReaccion]) REFERENCES [dbo].[reacciones] ([idReaccion])
);


GO

CREATE INDEX [IX_registroActividades_idClienteCampania] ON [dbo].[registroActividades] ([idClienteCampania])

GO

CREATE INDEX [IX_registroActividades_idFiador] ON [dbo].[registroActividades] ([idFiador])

GO

CREATE INDEX [IX_registroActividades_idProspecto] ON [dbo].[registroActividades] ([idProspecto])

GO

CREATE INDEX [IX_registroActividades_idActividad] ON [dbo].[registroActividades] ([idActividad])

GO

CREATE INDEX [IX_registroActividades_idCampania] ON [dbo].[registroActividades] ([idCampania])

GO

CREATE INDEX [IX_registroActividades_idCliente] ON [dbo].[registroActividades] ([idCliente])

GO

CREATE INDEX [IX_registroActividades_idClienteP] ON [dbo].[registroActividades] ([idClienteP])

GO

CREATE INDEX [IX_registroActividades_idCredito] ON [dbo].[registroActividades] ([idCredito])

GO

CREATE INDEX [IX_registroActividades_idDetalle] ON [dbo].[registroActividades] ([idDetalle])

GO

CREATE INDEX [IX_registroActividades_idGestor] ON [dbo].[registroActividades] ([idGestor])

GO

CREATE INDEX [IX_registroActividades_idGrupo] ON [dbo].[registroActividades] ([idGrupo])

GO

CREATE INDEX [IX_registroActividades_idMotivo] ON [dbo].[registroActividades] ([idMotivo])

GO

CREATE INDEX [IX_registroActividades_idReaccion] ON [dbo].[registroActividades] ([idReaccion])
