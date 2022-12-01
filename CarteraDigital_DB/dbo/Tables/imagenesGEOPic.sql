CREATE TABLE [dbo].[imagenesGEOPic] (
    [idImagen]  INT           IDENTITY (1, 1) NOT NULL,
    [url]       VARCHAR (150) NULL,
    [idCliente] INT           NULL,
    [idFiador]  INT           NULL,
    [idGrupo]   INT           NULL,
    [casa]      INT           NULL,
    [interior]  INT           NULL,
    [fecha]     DATETIME      NULL,
    CONSTRAINT [PK_imagenesGEOPic] PRIMARY KEY CLUSTERED ([idImagen] ASC),
    CONSTRAINT [FK_imagenesGEOPic_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente]),
    CONSTRAINT [FK_imagenesGEOPic_idFiador] FOREIGN KEY ([idFiador]) REFERENCES [dbo].[fiadores] ([idFiador]),
    CONSTRAINT [FK_imagenesGEOPic_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco])
);


GO

CREATE INDEX [IX_imagenesGEOPic_idCliente] ON [dbo].[imagenesGEOPic] ([idCliente])

GO

CREATE INDEX [IX_imagenesGEOPic_idFiador] ON [dbo].[imagenesGEOPic] ([idFiador])

GO

CREATE INDEX [IX_imagenesGEOPic_idGrupo] ON [dbo].[imagenesGEOPic] ([idGrupo])
