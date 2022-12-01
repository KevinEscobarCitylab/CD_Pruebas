CREATE TABLE [dbo].[criteriosAsignacion] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [inverso]     INT           NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosAsignacion] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosAsignacion_estado] ON [dbo].[criteriosAsignacion] ([estado])
