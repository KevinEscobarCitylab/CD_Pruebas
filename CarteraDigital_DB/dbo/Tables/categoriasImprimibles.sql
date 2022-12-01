CREATE TABLE [dbo].[categoriasImprimibles] (
    [idCategoria] INT          IDENTITY (1, 1) NOT NULL,
    [_class]      VARCHAR (50) NULL,
    [codigo]      VARCHAR (25) NULL,
    [categoria]   VARCHAR (75) NULL,
    [_default]    INT          NULL,
    CONSTRAINT [PK_categoriasImprimibles] PRIMARY KEY CLUSTERED ([idCategoria] ASC)
);

