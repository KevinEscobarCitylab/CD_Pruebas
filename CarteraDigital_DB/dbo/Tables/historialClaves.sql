CREATE TABLE [dbo].[historialClaves] (
    [idHistorial]      INT           IDENTITY (1, 1) NOT NULL,
    [idUsuario]        INT           NULL,
    [idUsuarioSistema] INT           NULL,
    [clave]            VARCHAR (150) NULL,
    CONSTRAINT [PK_historialClaves]PRIMARY KEY CLUSTERED ([idHistorial] ASC),
    CONSTRAINT [FK_historialClaves_idUsuario] FOREIGN KEY ([idUsuario]) REFERENCES [dbo].[usuarios] ([idUsuario]),
    CONSTRAINT [FK_historialClaves_idUsuarioSistema] FOREIGN KEY ([idUsuarioSistema]) REFERENCES [dbo].[usuariosSistema] ([idUsuario])
);


GO

CREATE INDEX [IX_historialClaves_idUsuario] ON [dbo].[historialClaves] ([idUsuario])

GO

CREATE INDEX [IX_historialClaves_idUsuarioSistema] ON [dbo].[historialClaves] ([idUsuarioSistema])
