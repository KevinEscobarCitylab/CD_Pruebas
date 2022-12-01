CREATE TABLE [dbo].[encabezadoEncuesta] (
    [idEP]       INT IDENTITY (1, 1) NOT NULL,
    [idEncuesta] INT NULL,
    [idPregunta] INT NULL,
    [idET]       INT NULL,
    [_index]     INT NULL,
    [estado]     INT NULL,
    CONSTRAINT [PK_encabezadoEncuesta]PRIMARY KEY CLUSTERED ([idEP] ASC),
    CONSTRAINT [FK_encabezadoEncuesta_idEncuesta]FOREIGN KEY ([idEncuesta]) REFERENCES [dbo].[encuestas] ([idEncuesta]),
    CONSTRAINT [FK_encabezadoEncuesta_idPregunta] FOREIGN KEY ([idPregunta]) REFERENCES [dbo].[preguntas] ([idPregunta])
);


GO

CREATE INDEX [IX_encabezadoEncuesta_estado] ON [dbo].[encabezadoEncuesta] ([estado])

GO

CREATE INDEX [IX_encabezadoEncuesta_idEncuesta] ON [dbo].[encabezadoEncuesta] ([idEncuesta])

GO

CREATE INDEX [IX_encabezadoEncuesta_idPregunta] ON [dbo].[encabezadoEncuesta] ([idPregunta])
