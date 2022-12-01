CREATE TABLE [dbo].[grupos_menu] (
    [idGrupoMenu] INT IDENTITY (1, 1) NOT NULL,
    [idMenu]      INT NULL,
    [idGrupo]     INT NULL,
    [estado]      INT NULL,
    CONSTRAINT [PK_grupos_menu] PRIMARY KEY CLUSTERED ([idGrupoMenu] ASC),
    CONSTRAINT [FK_grupos_menu_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_grupos_menu_idMenu] FOREIGN KEY ([idMenu]) REFERENCES [dbo].[menu] ([idMenu])
);


GO

CREATE INDEX [IX_grupos_menu_idGrupo] ON [dbo].[grupos_menu] ([idGrupo])

GO

CREATE INDEX [IX_grupos_menu_idMenu] ON [dbo].[grupos_menu] ([idMenu])

GO

CREATE INDEX [IX_grupos_menu_estado] ON [dbo].[grupos_menu] ([estado])
