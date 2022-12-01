CREATE TABLE [dbo].[criteriosIndicador] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosIndicador] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosIndicador_estado] ON [dbo].[criteriosIndicador] ([estado])
