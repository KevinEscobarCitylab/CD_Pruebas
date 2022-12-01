CREATE TABLE [dbo].[criteriosVencimiento] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosVencimiento]PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosVencimiento_estado] ON [dbo].[criteriosVencimiento] ([estado])
