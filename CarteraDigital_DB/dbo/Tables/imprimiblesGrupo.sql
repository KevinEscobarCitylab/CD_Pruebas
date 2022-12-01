CREATE TABLE [dbo].[imprimiblesGrupo] (
    [idImprimibleG] INT IDENTITY (1, 1) NOT NULL,
    [idImprimible]  INT NULL,
    [idGrupo]       INT NULL,
    [estado]        INT NULL,
    CONSTRAINT [PK_imprimiblesGrupo] PRIMARY KEY CLUSTERED ([idImprimibleG] ASC),
    CONSTRAINT [FK_imprimiblesGrupo_idImprimible] FOREIGN KEY ([idImprimible]) REFERENCES [dbo].[imprimibles] ([idImprimible])
);


GO

CREATE INDEX [IX_imprimiblesGrupo_estado] ON [dbo].[imprimiblesGrupo] ([estado])

GO

CREATE INDEX [IX_imprimiblesGrupo_idImprimible] ON [dbo].[imprimiblesGrupo] ([idImprimible])
