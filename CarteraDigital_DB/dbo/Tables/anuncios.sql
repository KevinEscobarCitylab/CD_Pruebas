CREATE TABLE [dbo].[anuncios] (
    [idAnuncio]   INT           IDENTITY (1, 1) NOT NULL,
    [titulo]      VARCHAR (55)  NULL,
    [descripcion] VARCHAR (624) NULL,
    [urlImagen]   VARCHAR (150) NULL,
    [urlLink]     VARCHAR (150) NULL,
    [idUsuario]   INT           NULL,
    [sticky]      INT           NULL,
    [fechaIn]     DATE          NULL,
    [fechaOut]    DATE          NULL,
    [fechaCarga]  DATETIME      NULL,
    [estado]      INT           NULL,
    [idUsuarioS]  INT           NULL,
    CONSTRAINT [PK_anuncios] PRIMARY KEY CLUSTERED ([idAnuncio] ASC)
);


GO

CREATE INDEX [IX_anuncios_estado] ON [dbo].[anuncios] ([estado])
