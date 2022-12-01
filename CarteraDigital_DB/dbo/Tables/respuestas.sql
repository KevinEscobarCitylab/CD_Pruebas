CREATE TABLE [dbo].[respuestas] (
    [idRespuesta] INT             IDENTITY (1, 1) NOT NULL,
    [respuesta]   VARCHAR(MAX)            NULL,
    [idPregunta]  INT             NULL,
    [valor]       DECIMAL (10, 2) NULL,
    [estado]      INT             NULL,
    [_index]      INT             NULL,
    [alias]       VARCHAR (50)    NULL,
    [ID]          VARCHAR (50)    NULL,
    [d1]          NVARCHAR(MAX)            NULL,
    CONSTRAINT [PK_respuestas] PRIMARY KEY CLUSTERED ([idRespuesta] ASC),
    CONSTRAINT [FK_respuestas_idPregunta] FOREIGN KEY ([idPregunta]) REFERENCES [dbo].[preguntas] ([idPregunta])
);


GO

CREATE INDEX [IX_respuestas_idPregunta] ON [dbo].[respuestas] ([idPregunta])

GO

CREATE INDEX [IX_respuestas_estado] ON [dbo].[respuestas] ([estado])
