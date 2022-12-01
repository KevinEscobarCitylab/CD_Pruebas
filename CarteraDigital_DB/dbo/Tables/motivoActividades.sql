CREATE TABLE [dbo].[motivoActividades] (
    [idMotivo]    INT          IDENTITY (1, 1) NOT NULL,
    [motivo]      VARCHAR(MAX)         NULL,
    [idActividad] INT          NULL,
    [estado]      INT          NULL,
    [idMotivoM]   INT          NULL,
    [idMotivoT]   VARCHAR (50) NULL,
    CONSTRAINT [PK_motivoActividades] PRIMARY KEY CLUSTERED ([idMotivo] ASC),
    CONSTRAINT [FK_motivoActividades_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad])
);


GO

CREATE INDEX [IX_motivoActividades_idActividad] ON [dbo].[motivoActividades] ([idActividad])

GO

CREATE INDEX [IX_motivoActividades_estado] ON [dbo].[motivoActividades] ([estado])
