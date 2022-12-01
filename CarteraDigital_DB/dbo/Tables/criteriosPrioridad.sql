CREATE TABLE [dbo].[criteriosPrioridad] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [idPrioridad] INT           NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)          NULL,
    [estado]      INT           NULL,
    CONSTRAINT [PK_criteriosPrioridad] PRIMARY KEY CLUSTERED ([idCriterio] ASC),
    CONSTRAINT [FK_criteriosPrioridad_idPrioridad] FOREIGN KEY ([idPrioridad]) REFERENCES [dbo].[prioridades] ([idPrioridad])
);


GO

CREATE INDEX [IX_criteriosPrioridad_estado] ON [dbo].[criteriosPrioridad] ([estado])

GO

CREATE INDEX [IX_criteriosPrioridad_idPrioridad] ON [dbo].[criteriosPrioridad] ([idPrioridad])
