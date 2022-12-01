CREATE TABLE [dbo].[imagenesActividad] (
    [idImagen]            INT           IDENTITY (1, 1) NOT NULL,
    [url]                 VARCHAR (150) NULL,
    [nombre]              VARCHAR (100) NULL,
    [idRegistroActividad] INT           NULL,
    [estado]              INT           NULL,
    [ID]                  INT           NULL,
    [fecha]               DATETIME      NULL,
    CONSTRAINT [PK_imagenesActvididad] PRIMARY KEY CLUSTERED ([idImagen] ASC),
    CONSTRAINT [FK_imagenesActividad_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_imagenesActividad_idRegistroActividad] ON [dbo].[imagenesActividad] ([idRegistroActividad])

GO

CREATE INDEX [IX_imagenesActividad_estado] ON [dbo].[imagenesActividad] ([estado])
