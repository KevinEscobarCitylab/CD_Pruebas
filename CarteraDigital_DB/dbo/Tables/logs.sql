CREATE TABLE [dbo].[logs] (
    [id]         INT      IDENTITY (1, 1) NOT NULL,
    [message]    VARCHAR(MAX)     NULL,
    [stackTrace] VARCHAR(MAX)     NULL,
    [contenido]  VARCHAR(MAX)     NULL,
    [idGestor]   INT      NULL,
    [idUsuario]  INT      NULL,
    [fecha]      DATETIME NULL,
    [data]       VARCHAR(MAX)     NULL,
    CONSTRAINT [PK_logs] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_logs_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_logs_idUsuario] FOREIGN KEY ([idUsuario]) REFERENCES [dbo].[usuariosSistema] ([idUsuario])
);


GO

CREATE INDEX [IX_logs_idGestor] ON [dbo].[logs] ([idGestor])

GO

CREATE INDEX [IX_logs_idUsuario] ON [dbo].[logs] ([idUsuario])
