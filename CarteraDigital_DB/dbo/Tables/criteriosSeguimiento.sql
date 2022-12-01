CREATE TABLE [dbo].[criteriosSeguimiento] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [rango]       INT           NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosSeguimiento]PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosSeguimiento_estado] ON [dbo].[criteriosSeguimiento] ([estado])
