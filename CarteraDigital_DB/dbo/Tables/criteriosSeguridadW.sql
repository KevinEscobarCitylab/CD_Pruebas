CREATE TABLE [dbo].[criteriosSeguridadW] (
    [idCriterio]  INT  IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR(MAX) NULL,
    [condicion]   VARCHAR(MAX) NULL,
    [inverso]     INT  NULL,
    [estado]      INT  NULL,
   CONSTRAINT [PK_criteriosSeguridadW] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosSeguridadW_estado] ON [dbo].[criteriosSeguridadW] ([estado])
