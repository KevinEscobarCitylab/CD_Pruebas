CREATE TABLE [dbo].[opcionesImprimiblesGrupo] (
    [idOpcionG]    INT IDENTITY (1, 1) NOT NULL,
    [idOpcion]     INT NULL,
    [idGrupo]      INT NULL,
    [idImprimible] INT NULL,
    [idCategoria]  INT NULL,
    [estado]       INT NULL,
    CONSTRAINT [PK_opcionesImprimiblesGrupo] PRIMARY KEY CLUSTERED ([idOpcionG] ASC),
    CONSTRAINT [FK_opcionesImprimiblesGrupo_idCategoria] FOREIGN KEY ([idCategoria]) REFERENCES [dbo].[categoriasImprimibles] ([idCategoria]),
    CONSTRAINT [FK_opcionesImprimiblesGrupo_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_opcionesImprimiblesGrupo_idImprimible] FOREIGN KEY ([idImprimible]) REFERENCES [dbo].[imprimibles] ([idImprimible]),
    CONSTRAINT [FK_opcionesImprimiblesGrupo_idOpcion] FOREIGN KEY ([idOpcion]) REFERENCES [dbo].[opcionesImprimibles] ([idOpcion])
);
GO

CREATE INDEX [IX_opcionesImprimiblesGrupo_idCategoria] ON [dbo].[opcionesImprimiblesGrupo] ([idCategoria])

GO

CREATE INDEX [IX_opcionesImprimiblesGrupo_idGrupo] ON [dbo].[opcionesImprimiblesGrupo] ([idGrupo])

GO

CREATE INDEX [IX_opcionesImprimiblesGrupo_idImprimible] ON [dbo].[opcionesImprimiblesGrupo] ([idImprimible])

GO

CREATE INDEX [IX_opcionesImprimiblesGrupo_idOpcion] ON [dbo].[opcionesImprimiblesGrupo] ([idOpcion])

GO

CREATE INDEX [IX_opcionesImprimiblesGrupo_estado] ON [dbo].[opcionesImprimiblesGrupo] ([estado])
