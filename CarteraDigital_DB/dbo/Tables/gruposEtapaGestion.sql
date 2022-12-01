CREATE TABLE [dbo].[gruposEtapaGestion] (
    [idGrupoE] INT IDENTITY (1, 1) NOT NULL,
    [idGrupo]  INT NULL,
    [idEtapaG] INT NULL,
    [estado]   INT NULL,
    CONSTRAINT [PK_gruposEtapaGestion] PRIMARY KEY CLUSTERED ([idGrupoE] ASC),
    CONSTRAINT [FK_gruposEtapaGestion_idEtapaG] FOREIGN KEY ([idEtapaG]) REFERENCES [dbo].[etapasGestionProspecto] ([idEtapaG]),
    CONSTRAINT [FK_gruposEtapaGestion_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo])
);


GO

CREATE INDEX [IX_gruposEtapaGestion_estado] ON [dbo].[gruposEtapaGestion] ([estado])

GO

CREATE INDEX [IX_gruposEtapaGestion_idEtapaG] ON [dbo].[gruposEtapaGestion] ([idEtapaG])

GO

CREATE INDEX [IX_gruposEtapaGestion_idGrupo] ON [dbo].[gruposEtapaGestion] ([idGrupo])
