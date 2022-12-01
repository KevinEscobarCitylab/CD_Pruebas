CREATE TABLE [dbo].[categoriasAgencia] (
    [idCategoria] INT             IDENTITY (1, 1) NOT NULL,
    [categoria]   VARCHAR (25)    NULL,
    [monto]       DECIMAL (10, 2) NULL,
    [montoUS]     DECIMAL (10, 2) NULL,
    [idGrupo]     INT             NULL,
    CONSTRAINT [PK_categoriasAgencia] PRIMARY KEY CLUSTERED ([idCategoria] ASC),
    CONSTRAINT [FK_categoriasAgencia_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo])
);


GO

CREATE INDEX [IX_categoriasAgencia_idGrupo] ON [dbo].[categoriasAgencia] ([idGrupo])
