CREATE TABLE [dbo].[imagenesGPS] (
    [idImagen]  INT           IDENTITY (1, 1) NOT NULL,
    [url]       VARCHAR (150) NULL,
    [nombre]    VARCHAR (50)  NULL,
    [latitud]   VARCHAR (50)  NULL,
    [longitud]  VARCHAR (50)  NULL,
    [idCliente] INT           NULL,
    [idFiador]  INT           NULL,
    [casa]      INT           NULL,
    [idGrupo]   INT           NULL,
    [idGestor]  INT           NULL,
    [fecha]     DATETIME      NULL,
    [estado]    INT           NULL,
    [interior]  INT           NULL,
    [ID]        INT           NULL,
    CONSTRAINT [PK_imagenesGPS] PRIMARY KEY CLUSTERED ([idImagen] ASC),
    CONSTRAINT [FK_imagenesGPS_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente]),
    CONSTRAINT [FK_imagenesGPS_idFiador] FOREIGN KEY ([idFiador]) REFERENCES [dbo].[fiadores] ([idFiador]),
    CONSTRAINT [FK_imagenesGPS_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_imagenesGPS_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco])
);


GO

CREATE INDEX [IX_imagenesGPS_idCliente] ON [dbo].[imagenesGPS] ([idCliente])

GO

CREATE INDEX [IX_imagenesGPS_idFiador] ON [dbo].[imagenesGPS] ([idFiador])

GO

CREATE INDEX [IX_imagenesGPS_idGestor] ON [dbo].[imagenesGPS] ([idGestor])

GO

CREATE INDEX [IX_imagenesGPS_idGrupo] ON [dbo].[imagenesGPS] ([idGrupo])

GO

CREATE INDEX [IX_imagenesGPS_estado] ON [dbo].[imagenesGPS] ([estado])
