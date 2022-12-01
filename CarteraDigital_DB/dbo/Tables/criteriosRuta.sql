CREATE TABLE [dbo].[criteriosRuta] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR (500) NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosRuta] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosRuta_estado] ON [dbo].[criteriosRuta] ([estado])
