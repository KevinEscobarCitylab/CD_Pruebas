CREATE TABLE [dbo].[gestores] (
    [idGestor]                      INT             IDENTITY (1, 1) NOT NULL,
    [idGestorT]                     VARCHAR (25)    NULL,
    [codigo]                        VARCHAR (18)    NULL,
    [nombre]                        VARCHAR (500)    NULL,
    [idGrupo]                       INT             NULL,
    [idAgencia]                     INT             NULL,
    [idSupervisor]                  INT             NULL,
    [estado]                        INT             NULL,
    [ruta]                          INT             NULL,
    [saldoCartera]                  DECIMAL (15, 2) NULL,
    [totalClientes]                 INT             NULL,
    [totalClientesMora]             INT             NULL,
    [sistema]                       INT             NULL,
    [porcentajeCarteraGPS]          DECIMAL (10, 2) NULL,
    [cargo]                         INT             NULL,
    [correo]                        VARCHAR (150)   NULL,
    [idZona]                        INT             NULL,
    [clasificacion]                 NVARCHAR (MAX)  NULL,
    [clientesPrioridad]             INT             NULL,
    [usuarioWeb]                    INT             NULL,
    [cantProspectosObs]             INT             NULL,
    [ultFechaObservacion]           DATETIME        NULL,
    [acuerdosCumplidos]             DECIMAL (10, 2) NULL DEFAULT 0,
    [promedioGestionesClientesMora] DECIMAL (10, 2) NULL DEFAULT 0,
    [porc_mora]                     DECIMAL (10, 2) NOT NULL DEFAULT 0,
    [porc_monto_mora_30]            DECIMAL (10, 2) NOT NULL DEFAULT 0,
    [porcMora3H]                    DECIMAL (10, 2) NOT NULL DEFAULT 0,
    [AVGDiasMora]                   DECIMAL (10, 2) NOT NULL DEFAULT 0,
    [notaCD]                        DECIMAL (10, 2) NOT NULL DEFAULT 0,
    CONSTRAINT [PK_gestores] PRIMARY KEY CLUSTERED ([idGestor] ASC),
    CONSTRAINT [FK_gestores_idAgencia] FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_gestores_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_gestores_idSupervisor] FOREIGN KEY ([idSupervisor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_gestores_idZona] FOREIGN KEY ([idZona]) REFERENCES [dbo].[zonas] ([idZona])
);


GO

CREATE INDEX [IX_gestores_idAgencia] ON [dbo].[gestores] ([idAgencia])

GO

CREATE INDEX [IX_gestores_idGrupo] ON [dbo].[gestores] ([idGrupo])

GO

CREATE INDEX [IX_gestores_idSupervisor] ON [dbo].[gestores] ([idSupervisor])

GO

CREATE INDEX [IX_gestores_idZona] ON [dbo].[gestores] ([idZona])

GO

CREATE INDEX [IX_gestores_estado] ON [dbo].[gestores] ([estado])

GO

CREATE INDEX [IX_gestores_sistema] ON [dbo].[gestores] ([sistema])
