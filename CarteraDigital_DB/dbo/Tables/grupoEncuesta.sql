CREATE TABLE [dbo].[grupoEncuesta] (
    [idGrupoE]   INT          IDENTITY (1, 1) NOT NULL,
    [nombre]     VARCHAR (30) NULL,
    [idEncuesta] INT          NULL,
    [_index]     INT          NULL,
    [estado]     INT          NULL,
    [iconType]   INT          NULL,
    [saveD4]     INT          NULL,
    CONSTRAINT [PK_grupoEncuesta] PRIMARY KEY CLUSTERED ([idGrupoE] ASC),
    CONSTRAINT [FK_grupoEncuesta_idEncuesta] FOREIGN KEY ([idEncuesta]) REFERENCES [dbo].[encuestas] ([idEncuesta])
);


GO

CREATE INDEX [IX_grupoEncuesta_idEncuesta] ON [dbo].[grupoEncuesta] ([idEncuesta])

GO

CREATE INDEX [IX_grupoEncuesta_estado] ON [dbo].[grupoEncuesta] ([estado])
