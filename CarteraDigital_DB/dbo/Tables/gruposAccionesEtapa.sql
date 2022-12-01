CREATE TABLE [dbo].[gruposAccionesEtapa] (
    [idGrupoAE]    INT IDENTITY (1, 1) NOT NULL,
    [idGrupo]      INT NULL,
    [idAccion]     INT NULL,
    [estado]       INT NULL,
    [idEtapa]      INT NULL,
    [idEncuesta]   INT NULL,
    [idFormulario] INT NULL,
    CONSTRAINT [PK_gruposAccionesEtapa] PRIMARY KEY CLUSTERED ([idGrupoAE] ASC),
    CONSTRAINT [FK_gruposAccionesEtapa_idAccion] FOREIGN KEY ([idAccion]) REFERENCES [dbo].[accionesEtapa] ([idAccion]),
    CONSTRAINT [FK_gruposAccionesEtapa_idEtapaG] FOREIGN KEY ([idEtapa]) REFERENCES [dbo].[etapasGestionProspecto] ([idEtapaG]),
    CONSTRAINT [FK_gruposAccionesEtapa_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_gruposAccionesEtapa_idEncuesta] FOREIGN KEY ([idEncuesta]) REFERENCES [dbo].[encuestas] ([idEncuesta]),
    CONSTRAINT [FK_gruposAccionesEtapa_idFormulario] FOREIGN KEY ([idFormulario]) REFERENCES [dbo].[formularios] ([idFormulario])
);


GO

CREATE INDEX [IX_gruposAccionesEtapa_idAccion] ON [dbo].[gruposAccionesEtapa] ([idAccion])

GO

CREATE INDEX [IX_gruposAccionesEtapa_idEtapa] ON [dbo].[gruposAccionesEtapa] ([idEtapa])

GO

CREATE INDEX [IX_gruposAccionesEtapa_idGrupo] ON [dbo].[gruposAccionesEtapa] ([idGrupo])

GO

CREATE INDEX [IX_gruposAccionesEtapa_idEncuesta] ON [dbo].[gruposAccionesEtapa] ([idEncuesta])

GO

CREATE INDEX [IX_gruposAccionesEtapa_idFormulario] ON [dbo].[gruposAccionesEtapa] ([idFormulario])

GO

CREATE INDEX [IX_gruposAccionesEtapa_estado] ON [dbo].[gruposAccionesEtapa] ([estado])

