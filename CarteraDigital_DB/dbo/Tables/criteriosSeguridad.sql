CREATE TABLE [dbo].[criteriosSeguridad] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [inverso]     INT           NULL,
    [sistema]     INT           NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosSeguridad] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosSeguridad_estado] ON [dbo].[criteriosSeguridad] ([estado])
