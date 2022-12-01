CREATE TABLE [dbo].[formularios] (
    [idFormulario] INT            IDENTITY (1, 1) NOT NULL,
    [nombre]       VARCHAR (50)   NULL,
    [idEncuesta]   INT            NULL,
    [_index]       INT            NULL,
    [indexT]       INT            NULL,
    [estado]       INT            NULL,
    [idGrupoE]     INT            NULL,
    [parents]      VARCHAR (100)  NULL,
    [printer]      VARCHAR (MAX)  NULL,
    [conf]         VARCHAR (MAX)  NULL,
    [d1]           NVARCHAR (MAX) NULL,
    [observado]    INT            NULL,
    [web]          INT            NULL,
    [idTipo]       INT            NULL,
    CONSTRAINT [PK_formularios] PRIMARY KEY CLUSTERED ([idFormulario] ASC),
    CONSTRAINT [FK_formularios_idEncuesta] FOREIGN KEY ([idEncuesta]) REFERENCES [dbo].[encuestas] ([idEncuesta]),
    CONSTRAINT [FK_formularios_idGrupoE] FOREIGN KEY ([idGrupoE]) REFERENCES [dbo].[grupoEncuesta] ([idGrupoE]),
    CONSTRAINT [FK_formularios_idTipo] FOREIGN KEY ([idTipo]) REFERENCES [dbo].[tiposFormularios] ([idTipoFormularios])
);


GO

CREATE INDEX [IX_formularios_idEncuesta] ON [dbo].[formularios] ([idEncuesta])

GO

CREATE INDEX [IX_formularios_idGrupoE] ON [dbo].[formularios] ([idGrupoE])
