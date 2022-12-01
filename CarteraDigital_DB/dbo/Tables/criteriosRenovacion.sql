CREATE TABLE [dbo].[criteriosRenovacion] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosRenovacion] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosRenovacion_estado] ON [dbo].[criteriosRenovacion] ([estado])
