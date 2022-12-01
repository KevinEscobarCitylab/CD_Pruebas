CREATE TABLE [dbo].[etapasAprobadasProspecto] (
    [idEtapaAP]     INT           IDENTITY (1, 1) NOT NULL,
    [idProspecto]   INT           NULL,
    [idEtapa]       BIGINT        NULL,
    [idGrupo]       INT           NULL,
    [idUsuarioAd]   INT           NULL,
    [fecha]         DATETIME      NULL,
    [estado]        INT           NULL,
    [idGestor]      INT           NULL,
    [idAprobacionT] VARCHAR (MAX) NULL,
    [orden]         INT           NULL,
    CONSTRAINT [PK_etapasAprobadasProspecto] PRIMARY KEY CLUSTERED ([idEtapaAP] ASC),
    CONSTRAINT [FK_etapasAprobadasProspecto_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_etapasAprobadasProspecto_idUsuarioAd] FOREIGN KEY ([idUsuarioAd]) REFERENCES [dbo].[usuariosSistema] ([idUsuario]),
    CONSTRAINT [FK_etapasAprobadasProspecto_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos] ([idProspecto]),
    CONSTRAINT [FK_etapasAprobadasProspecto_idEtapa] FOREIGN KEY ([idEtapa]) REFERENCES [dbo].[etapasProspecto] ([idEtapa]),
    CONSTRAINT [FK_etapasAprobadasProspecto_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);

GO

CREATE INDEX [IX_etapasAprobadasProspecto_idGrupo] ON [dbo].[etapasAprobadasProspecto] ([idGrupo])

GO

CREATE INDEX [IX_etapasAprobadasProspecto_idUsuarioAd] ON [dbo].[etapasAprobadasProspecto] ([idUsuarioAd])

GO

CREATE INDEX [IX_etapasAprobadasProspecto_idProspecto] ON [dbo].[etapasAprobadasProspecto] ([idProspecto])

GO

CREATE INDEX [IX_etapasAprobadasProspecto_idEtapa] ON [dbo].[etapasAprobadasProspecto] ([idEtapa])

GO

CREATE INDEX [IX_etapasAprobadasProspecto_idGestor] ON [dbo].[etapasAprobadasProspecto] ([idGestor])

GO

CREATE INDEX [IX_etapasAprobadasProspecto_estado] ON [dbo].[etapasAprobadasProspecto] ([estado])
