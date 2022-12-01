CREATE TABLE [dbo].[historialCambios] (
    [idHistorial] BIGINT   IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR(MAX)     NULL,
    [idUsuario]   INT      NULL,
    [fecha]       DATETIME NULL,
    [origen]      VARCHAR(MAX)     NULL,
    [dispositivo] VARCHAR(MAX)     NULL,
    CONSTRAINT [PK_historialCambios] PRIMARY KEY CLUSTERED ([idHistorial] ASC),
    CONSTRAINT [FK_historialCambios_idUsuario]FOREIGN KEY ([idUsuario]) REFERENCES [dbo].[usuariosSistema] ([idUsuario])
);


GO

CREATE INDEX [IX_historialCambios_idUsuario] ON [dbo].[historialCambios] ([idUsuario])
