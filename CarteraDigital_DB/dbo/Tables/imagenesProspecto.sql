CREATE TABLE [dbo].[imagenesProspecto] (
    [idImagen]     INT      IDENTITY (1, 1) NOT NULL,
    [idProspecto]  INT      NULL,
    [idFormulario] INT      NULL,
    [idPregunta]   INT      NULL,
    [fecha]        DATETIME NULL,
    [estado]       INT      NULL,
    CONSTRAINT [PK_imagenesProspecto] PRIMARY KEY CLUSTERED ([idImagen] ASC)
);

GO
CREATE INDEX [IX_imagenesProspecto_estado] ON [dbo].[imagenesProspecto] ([estado])

