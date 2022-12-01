CREATE TABLE [dbo].[notificaciones] (
    [idNotificacion] VARCHAR (MAX) NULL,
    [idUsuarioR]     INT           NULL,
    [message]        VARCHAR (MAX) NULL,
    [url]            VARCHAR (300) NULL,
    [estado]         INT           NULL,
    [fecha]          DATETIME      NULL,
    [idGrupo]        INT           NULL
);



GO

CREATE INDEX [IX_notificaciones_estado] ON [dbo].[notificaciones] ([estado])
