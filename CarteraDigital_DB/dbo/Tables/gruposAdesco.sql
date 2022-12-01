CREATE TABLE [dbo].[gruposAdesco] (
    [idGrupoAdesco]       INT             IDENTITY (1, 1) NOT NULL,
    [idGrupoAdescoT]      VARCHAR (75)    NULL,
    [nombre]              VARCHAR (50)    NULL,
    [idOrganizacion]      INT             NULL,
    [idEstado]            INT             NULL,
    [totalMora]           INT             NULL,
    [totalDesembolso]     INT             NULL,
    [totalVenceHoy]       INT             NULL,
    [totalRenovacion]     INT             NULL,
    [totalPrioridad]      INT             NULL,
    [domicilioReunion]    VARCHAR(MAX)            NULL,
    [representante]       VARCHAR (100)   NULL,
    [idEncuestaR]         INT             NULL,
    [idGestor]            INT             NULL,
    [actualizado]         INT             NULL,
    [latitud]             VARCHAR (50)    NULL,
    [longitud]            VARCHAR (50)    NULL,
    [imgReferencia]       VARCHAR (150)   NULL,
    [pendienteReferencia] INT             NULL,
    [totalVencimiento]    INT             NULL,
    [infoE]               VARCHAR(MAX)            NULL,
    [emergentes]          VARCHAR(MAX)            NULL,
    [idAgencia]           INT             NULL,
    [idERtemp]            INT             NULL,
    [montoOtorgado]       DECIMAL (12, 2) NULL,
    [saldoPendiente]      DECIMAL (12, 2) NULL,
    [pagoParaEstarAlDia]  DECIMAL (12, 2) NULL,
    [nCuotaActual]        INT             NULL,
    [idProspecto]         INT             NULL,
    [fecha]               DATETIME        NULL,
    [C1]                  INT             NULL,
    [C2]                  INT             NULL,
    [C3]                  INT             NULL,
    [table_ext]           VARCHAR(MAX)            NULL,
    [C4]                  INT             NULL,
    [gestionado]          INT             NULL,
    CONSTRAINT [PK_gruposAdesco] PRIMARY KEY CLUSTERED ([idGrupoAdesco] ASC),
    CONSTRAINT [FK_gruposAdesco_idEstado] FOREIGN KEY ([idEstado]) REFERENCES [dbo].[estadosGruposAdesco] ([idEstado]),
    CONSTRAINT [FK_gruposAdesco_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_gruposAdesco_idOrganizacion] FOREIGN KEY ([idOrganizacion]) REFERENCES [dbo].[organizacionesLocales] ([idOrganizacion]),
    CONSTRAINT [FK_gruposAdesco_idAgencia] FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_gruposAdesco_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos] ([idProspecto])
);


GO

CREATE INDEX [IX_gruposAdesco_idEstado] ON [dbo].[gruposAdesco] ([idEstado])

GO

CREATE INDEX [IX_gruposAdesco_idGestor] ON [dbo].[gruposAdesco] ([idGestor])

GO

CREATE INDEX [IX_gruposAdesco_idOrganizacion] ON [dbo].[gruposAdesco] ([idOrganizacion])

GO

CREATE INDEX [IX_gruposAdesco_idAgencia] ON [dbo].[gruposAdesco] ([idAgencia])

GO

CREATE INDEX [IX_gruposAdesco_idProspecto] ON [dbo].[gruposAdesco] ([idProspecto])

GO

CREATE INDEX [IX_gruposAdesco_actualizado] ON [dbo].[gruposAdesco] ([actualizado])

GO

CREATE INDEX [IX_gruposAdesco_C1] ON [dbo].[gruposAdesco] ([C1])

GO

CREATE INDEX [IX_gruposAdesco_C2] ON [dbo].[gruposAdesco] ([C2])

GO

CREATE INDEX [IX_gruposAdesco_C3] ON [dbo].[gruposAdesco] ([C3])

GO

CREATE INDEX [IX_gruposAdesco_C4] ON [dbo].[gruposAdesco] ([C4])

GO

CREATE INDEX [IX_gruposAdesco_gestionado] ON [dbo].[gruposAdesco] ([gestionado])
