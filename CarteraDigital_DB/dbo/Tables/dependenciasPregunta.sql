CREATE TABLE [dbo].[dependenciasPregunta] (
    [idDependencia] INT             IDENTITY (1, 1) NOT NULL,
    [idPregunta]    INT             NULL,
    [parent]        INT             NULL,
    [parentR]       INT             NULL,
    [valorR]        DECIMAL (10, 2) NULL,
    [idOperador]    INT             NULL,
    [idUnidad]      INT             NULL,
    [estado]        INT             NULL,
    [valorT]        VARCHAR (50)    NULL,
    [indexG]        INT             NULL,
    [fieldD1]       VARCHAR (50)    NULL,
    CONSTRAINT [PK_dependenciasPregunta] PRIMARY KEY CLUSTERED ([idDependencia] ASC),
    CONSTRAINT [FK_dependenciasPregunta_idOperador] FOREIGN KEY ([idOperador]) REFERENCES [dbo].[condicionesComparacion] ([idCondicion]),
    CONSTRAINT [FK_dependenciasPregunta_idUnidad] FOREIGN KEY ([idUnidad]) REFERENCES [dbo].[unidades] ([idUnidad]),
    CONSTRAINT [FK_dependenciasPregunta_idPregunta] FOREIGN KEY ([idPregunta]) REFERENCES [dbo].[preguntas] ([idPregunta]),
    CONSTRAINT [FK_dependenciasPregunta_parent] FOREIGN KEY ([parent]) REFERENCES [dbo].[preguntas] ([idPregunta]),
    CONSTRAINT [FK_dependenciasPregunta_parentR] FOREIGN KEY ([parentR]) REFERENCES [dbo].[respuestas] ([idRespuesta])
);


GO

CREATE INDEX [IX_dependenciasPregunta_idOperador] ON [dbo].[dependenciasPregunta] ([idOperador])

GO

CREATE INDEX [IX_dependenciasPregunta_idUnidad] ON [dbo].[dependenciasPregunta] ([idUnidad])

GO

CREATE INDEX [IX_dependenciasPregunta_idPregunta] ON [dbo].[dependenciasPregunta] ([idPregunta])

GO

CREATE INDEX [IX_dependenciasPregunta_parent] ON [dbo].[dependenciasPregunta] ([parent])

GO

CREATE INDEX [IX_dependenciasPregunta_parentR] ON [dbo].[dependenciasPregunta] ([parentR])

GO

CREATE INDEX [IX_dependenciasPregunta_estado] ON [dbo].[dependenciasPregunta] ([estado])
