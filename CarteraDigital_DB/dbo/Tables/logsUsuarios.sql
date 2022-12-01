CREATE TABLE [dbo].[logsUsuarios] (
    [id]         INT      IDENTITY (1, 1) NOT NULL,
    [message]    NVARCHAR(MAX) NULL,
    [stackTrace] NVARCHAR(MAX) NULL,
    [contenido]  VARCHAR(MAX) NULL,
    [idGestor]   INT      NULL,
    [idUsuario]  INT      NULL,
    [fecha]      DATETIME NULL,
    [data]       NVARCHAR(MAX)     NULL,
    CONSTRAINT [PK_logsUsuarios] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_logsUsuarios_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);

GO

CREATE INDEX [IX_logsUsuarios_idGestor] ON [dbo].[logsUsuarios] ([idGestor])