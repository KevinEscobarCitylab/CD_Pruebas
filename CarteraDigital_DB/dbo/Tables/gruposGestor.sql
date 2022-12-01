CREATE TABLE [dbo].[gruposGestor] (
    [idGrupoG]     INT  IDENTITY (1, 1) NOT NULL,
    [idAsesor]     INT  NULL,
    [idGestor]     INT  NULL,
    [fechaIncicio] DATE NULL,
    [fechaLimite]  DATE NULL,
    [estado]       INT  NULL,
    CONSTRAINT [PK_gruposGestor] PRIMARY KEY CLUSTERED ([idGrupoG] ASC),
    CONSTRAINT [FK_gruposGestor_idAsesor] FOREIGN KEY ([idAsesor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_gruposGestor_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_gruposGestor_estado] ON [dbo].[gruposGestor] ([estado])

GO

CREATE INDEX [IX_gruposGestor_idGestor] ON [dbo].[gruposGestor] ([idGestor])

GO

CREATE INDEX [IX_gruposGestor_idAsesor] ON [dbo].[gruposGestor] ([idAsesor])
