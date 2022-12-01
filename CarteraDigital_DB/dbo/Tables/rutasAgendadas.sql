CREATE TABLE [dbo].[rutasAgendadas] (
    [idRutaAgendada]    INT  IDENTITY (1, 1) NOT NULL,
    [fecha]             DATE NULL,
    [idCredito]         INT  NULL,
    [idClienteCampania] INT  NULL,
    [idProspecto]       INT  NULL,
    [idActividad]       INT  NULL,
    [idGrupoAdesco]     INT  NULL,
    [idGestor]          INT  NULL,
    [casa]              INT  NULL,
    [recomendacion]     INT  NULL,
    [acumulado]         INT  NULL,
    [agendado]          INT  NULL,
    [estado]            INT  NULL,
    CONSTRAINT [PK_rutasAgendadas] PRIMARY KEY CLUSTERED ([idRutaAgendada] ASC),
    CONSTRAINT [FK_rutasAgendadas_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_rutasAgendadas_idClienteCampania] FOREIGN KEY ([idClienteCampania]) REFERENCES [dbo].[clientesCampania] ([idClienteCampania]),
    CONSTRAINT [FK_rutasAgendadas_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_rutasAgendadas_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_rutasAgendadas_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_rutasAgendadas_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos] ([idProspecto])
);


GO

CREATE INDEX [IX_rutasAgendadas_idActividad] ON [dbo].[rutasAgendadas] ([idActividad])

GO

CREATE INDEX [IX_rutasAgendadas_idClienteCampania] ON [dbo].[rutasAgendadas] ([idClienteCampania])

GO

CREATE INDEX [IX_rutasAgendadas_idCredito] ON [dbo].[rutasAgendadas] ([idCredito])

GO

CREATE INDEX [IX_rutasAgendadas_idGestor] ON [dbo].[rutasAgendadas] ([idGestor])

GO

CREATE INDEX [IX_rutasAgendadas_idGrupoAdesco] ON [dbo].[rutasAgendadas] ([idGrupoAdesco])

GO

CREATE INDEX [IX_rutasAgendadas_idProspecto] ON [dbo].[rutasAgendadas] ([idProspecto])

GO

CREATE INDEX [IX_rutasAgendadas_estado] ON [dbo].[rutasAgendadas] ([estado])
