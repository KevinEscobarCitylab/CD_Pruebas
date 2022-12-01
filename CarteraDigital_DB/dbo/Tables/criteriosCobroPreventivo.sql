CREATE TABLE [dbo].[criteriosCobroPreventivo] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosCobroPreventivo] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);


GO

CREATE INDEX [IX_criteriosCobroPreventivo_estado] ON [dbo].[criteriosCobroPreventivo] ([estado])
