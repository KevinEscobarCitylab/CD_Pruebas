CREATE TABLE [dbo].[usuarios] (
    [idUsuario]             INT           IDENTITY (1, 1) NOT NULL,
    [idGestor]              INT           NULL,
    [usuario]               VARCHAR (50)  NULL,
    [clave]                 VARCHAR (150) NULL,
    [sessionid]             VARCHAR (150) NULL,
    [sesionActiva]          INT           NULL,
    [pin]                   INT           NULL,
    [idGrupo]               INT           NULL,
    [ip]                    VARCHAR (50)  NULL,
    [fechaCierre]           DATE          NULL,
    [fechaCambioClave]      DATE          NULL,
    [verificador]           INT           NULL,
    [diasDesdeCambioClave]  INT           NULL,
    [fechaSesion]           DATETIME      NULL,
    [intentosFallidos]      INT           NULL,
    [codigoDesbloqueo]      VARCHAR (50)  NULL,
    [UID]                   VARCHAR (150) NULL,
    [sesionUnica]           INT           NULL,
    [multiplesDispositivos] INT           NULL,
    [fechaBloqueo]          DATETIME      NULL,
    [aes]                   INT           NULL,
    [autoEnvio]             INT           NULL,
    [fechaIngreso]          DATETIME      NULL,
    [token]                 VARCHAR (150) NULL,
    [data]                  NVARCHAR(MAX) NULL, 
    [totalLogin]            INT           NULL, 
    CONSTRAINT [PK_usuarios] PRIMARY KEY CLUSTERED ([idUsuario] ASC),
    CONSTRAINT [FK_usuarios_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_usuarios_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_usuarios_idGrupo] ON [dbo].[usuarios] ([idGrupo])

GO

CREATE INDEX [IX_usuarios_idGestor] ON [dbo].[usuarios] ([idGestor])
