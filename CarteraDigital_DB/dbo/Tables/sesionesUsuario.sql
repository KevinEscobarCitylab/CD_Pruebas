CREATE TABLE [dbo].[sesionesUsuario] (
    [idToken]   INT          IDENTITY (1, 1) NOT NULL,
    [token]     VARCHAR (32) NULL,
    [idUsuario] INT          NULL,
    CONSTRAINT [PK_sesionesUsuario] PRIMARY KEY CLUSTERED ([idToken] ASC),
    CONSTRAINT [FK_sesionesUsuario_idUsuario] FOREIGN KEY ([idUsuario]) REFERENCES [dbo].[usuarios] ([idUsuario])
);


GO

CREATE INDEX [IX_sesionesUsuario_idUsuario] ON [dbo].[sesionesUsuario] ([idUsuario])
