CREATE TABLE [dbo].[VisitasReprogramadas] (
    [idVisita]            INT  IDENTITY (1, 1) NOT NULL,
    [fechaGestion]        DATE NULL,
    [fechaVisita]         DATE NULL,
    [idCredito]           INT  NULL,
    [idGestor]            INT  NULL,
    [idRegistroActividad] INT  NULL,
    [diasVisita]          INT  NULL,
    [realizada]           INT  DEFAULT ((0)) NULL,
    [idActividad]         INT  NULL,
    [idCampania]          INT  NULL,
    [idClienteP]          INT  NULL,
    CONSTRAINT [PK_VisitasReprogramadas]PRIMARY KEY CLUSTERED ([idVisita] ASC),
    CONSTRAINT [FK_VisitasReprogramadas_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_VisitasReprogramadas_idCampania] FOREIGN KEY ([idCampania]) REFERENCES [dbo].[campanias] ([idCampania]),
    CONSTRAINT [FK_VisitasReprogramadas_idClienteP] FOREIGN KEY ([idClienteP]) REFERENCES [dbo].[clientesPotenciales] ([idClienteP]),
    CONSTRAINT [FK__VisitasReprogramadasidCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_VisitasReprogramadas_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_VisitasReprogramadas_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_VisitasReprogramadas_idCampania] ON [dbo].[VisitasReprogramadas] ([idCampania])

GO

CREATE INDEX [IX_VisitasReprogramadas_idClienteP] ON [dbo].[VisitasReprogramadas] ([idClienteP])

GO

CREATE INDEX [IX_VisitasReprogramadas_idCredito] ON [dbo].[VisitasReprogramadas] ([idCredito])

GO

CREATE INDEX [IX_VisitasReprogramadas_idGestor] ON [dbo].[VisitasReprogramadas] ([idGestor])

GO

CREATE INDEX [IX_VisitasReprogramadas_idRegistroActividad] ON [dbo].[VisitasReprogramadas] ([idRegistroActividad])

GO

CREATE INDEX [IX_VisitasReprogramadas_idActividad] ON [dbo].[VisitasReprogramadas] ([idActividad])
