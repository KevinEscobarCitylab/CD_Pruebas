CREATE TABLE [dbo].[usuariosSistema] (
    [idUsuario]            INT           IDENTITY (1, 1) NOT NULL,
    [usuario]              VARCHAR (50)  NULL,
    [clave]                VARCHAR (150) NULL,
    [sessionid]            VARCHAR (150) NULL,
    [idGrupo]              INT           NULL,
    [idGestor]             INT           NULL,
    [idAgencia]            INT           NULL,
    [estado]               INT           NULL,
    [fechaCambioClave]     DATE          NULL,
    [verificador]          INT           NULL,
    [diasDesdeCambioClave] INT           NULL,
    [aes]                  INT           NULL,
    [idZona]               INT           NULL,
    [nombre]               VARCHAR (75)  NULL,
    [intentosFallidos]     INT           NULL,
    [fechaBloqueo]         DATETIME      NULL,
    [codigoDesbloqueo]     VARCHAR(MAX)          NULL,
    [fechaSesion]          DATE          NULL,
    [sesionActiva]         INT           NULL,
    [activeDirec]          INT           NULL,
    [fechaIngreso]         DATETIME      NULL,
    [direccion]            VARCHAR(MAX)          NULL,
    CONSTRAINT [PK_usuariosSistema]PRIMARY KEY CLUSTERED ([idUsuario] ASC),
    CONSTRAINT [FK_usuariosSistema_idAgencia]FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_usuariosSistema_idGrupo]FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_usuariosSistema_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_usuariosSistema_idZona] FOREIGN KEY ([idZona]) REFERENCES [dbo].[zonas] ([idZona])
);


GO

CREATE INDEX [IX_usuariosSistema_idAgencia] ON [dbo].[usuariosSistema] ([idAgencia])

GO

CREATE INDEX [IX_usuariosSistema_idGrupo] ON [dbo].[usuariosSistema] ([idGrupo])

GO

CREATE INDEX [IX_usuariosSistema_idGestor] ON [dbo].[usuariosSistema] ([idGestor])

GO

CREATE INDEX [IX_usuariosSistema_idZona] ON [dbo].[usuariosSistema] ([idZona])

GO

CREATE INDEX [IX_usuariosSistema_estado] ON [dbo].[usuariosSistema] ([estado])
