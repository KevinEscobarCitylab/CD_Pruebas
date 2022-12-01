CREATE TABLE [dbo].[criteriosDesertado] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosDesertado] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosDesertado_estado] ON [dbo].[criteriosDesertado] ([estado])
