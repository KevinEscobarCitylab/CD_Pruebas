CREATE TABLE [dbo].[grupos] (
    [idGrupo]   INT           IDENTITY (1, 1) NOT NULL,
    [codigo]    VARCHAR (10)  NULL,
    [grupo]     VARCHAR (100) NULL,
    [asignable] INT           DEFAULT ((0)) NULL,
    [estado]    INT           NULL,
    [idGrupoT]  VARCHAR(10)   NULL,
    CONSTRAINT [PK_grupos] PRIMARY KEY CLUSTERED ([idGrupo] ASC)
);


GO

CREATE INDEX [IX_grupos_estado] ON [dbo].[grupos] ([estado])
