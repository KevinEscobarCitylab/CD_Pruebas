CREATE TABLE [dbo].[criteriosRutaGrupos] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR (500) NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosRutaGrupos]PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosRutaGrupos_estado] ON [dbo].[criteriosRutaGrupos] ([estado])
