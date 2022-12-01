CREATE TABLE [dbo].[categoriasInfoExtendida] (
    [idCategoria] INT          IDENTITY (1, 1) NOT NULL,
    [categoria]   VARCHAR (50) NULL,
    [_index]      INT          NULL,
    CONSTRAINT [PK_categoriasInfoExtendida] PRIMARY KEY CLUSTERED ([idCategoria] ASC)
);

