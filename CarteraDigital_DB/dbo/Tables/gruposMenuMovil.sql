CREATE TABLE [dbo].[gruposMenuMovil] (
    [idMenuM] INT IDENTITY (1, 1) NOT NULL,
    [idMenu]  INT NULL,
    [idGrupo] INT NULL,
    [estado]  INT NULL,
    CONSTRAINT [PK_gruposMenuMovil]PRIMARY KEY CLUSTERED ([idMenuM] ASC),
    CONSTRAINT [FK_gruposMenuMovil_idGrupo]FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_gruposMenuMovil_idMenu]FOREIGN KEY ([idMenu]) REFERENCES [dbo].[menuMovil] ([idMenu])
);


GO

CREATE INDEX [IX_gruposMenuMovil_idGrupo] ON [dbo].[gruposMenuMovil] ([idGrupo])

GO

CREATE INDEX [IX_gruposMenuMovil_idMenu] ON [dbo].[gruposMenuMovil] ([idMenu])
