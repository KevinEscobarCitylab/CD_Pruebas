CREATE TABLE [dbo].[rutas] (
    [idRuta]            INT  IDENTITY (1, 1) NOT NULL,
    [idCredito]         INT  NULL,
    [idClienteCampania] INT  NULL,
    [idProspecto]       INT  NULL,
    [idGestor]          INT  NULL,
    [fecha]             DATE NULL,
    [casa]              INT  NULL,
    [recomendacion]     INT  NULL,
    [estado]            INT  NULL,
    [idActividad]       INT  NULL,
    [idGrupoAdesco]     INT  NULL,
    [idPtemp]           INT  NULL,
    [acumulado]         INT  NULL,
    [agendado]          INT  NULL,
    [gestionado]        INT  NULL,
    [aAcumular]         INT  NULL,
    CONSTRAINT [PK_rutas] PRIMARY KEY CLUSTERED ([idRuta] ASC),
    CONSTRAINT [FK_rutas_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_rutas_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_rutas_idClienteCampania] FOREIGN KEY ([idClienteCampania]) REFERENCES [dbo].[clientesCampania] ([idClienteCampania]),
    CONSTRAINT [FK_rutas_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_rutas_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_rutas_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos] ([idProspecto])
);


GO

CREATE INDEX [IX_rutas_idGrupoAdesco] ON [dbo].[rutas] ([idGrupoAdesco])

GO

CREATE INDEX [IX_rutas_idActividad] ON [dbo].[rutas] ([idActividad])

GO

CREATE INDEX [IX_rutas_idClienteCampania] ON [dbo].[rutas] ([idClienteCampania])

GO

CREATE INDEX [IX_rutas_idCredito] ON [dbo].[rutas] ([idCredito])

GO

CREATE INDEX [IX_rutas_idGestor] ON [dbo].[rutas] ([idGestor])

GO

CREATE INDEX [IX_rutas_idProspecto] ON [dbo].[rutas] ([idProspecto])

GO

CREATE INDEX [IX_rutas_estado] ON [dbo].[rutas] ([estado])