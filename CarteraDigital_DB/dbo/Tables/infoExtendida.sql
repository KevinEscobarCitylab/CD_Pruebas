CREATE TABLE [dbo].[infoExtendida] (
    [idInfoExtendida] INT           IDENTITY (1, 1) NOT NULL,
    [codigo]          VARCHAR (50)  NULL,
    [descripcion]     VARCHAR (100) NULL,
    [idCategoria]     INT           NULL,
    [formato]         VARCHAR (25)  NULL,
    [simboloInicial]  VARCHAR (10)  NULL,
    [simboloFinal]    VARCHAR (10)  NULL,
    [emergente]       INT           NULL,
    [_index]          INT           NULL,
    [estado]          INT           NULL,
    [tipo]            INT           NULL,
    CONSTRAINT [PK_infoExtendida] PRIMARY KEY CLUSTERED ([idInfoExtendida] ASC),
    CONSTRAINT [FK_infoExtendida_idCategoria] FOREIGN KEY ([idCategoria]) REFERENCES [dbo].[categoriasInfoExtendida] ([idCategoria])
);


GO

CREATE INDEX [IX_infoExtendida_idCategoria] ON [dbo].[infoExtendida] ([idCategoria])

GO

CREATE INDEX [IX_infoExtendida_estado] ON [dbo].[infoExtendida] ([estado])

GO

CREATE INDEX [IX_infoExtendida_emergente] ON [dbo].[infoExtendida] ([emergente])

GO

CREATE INDEX [IX_infoExtendida_tipo] ON [dbo].[infoExtendida] ([tipo])
