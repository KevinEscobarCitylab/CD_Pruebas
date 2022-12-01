CREATE TABLE [dbo].[historialUltimosPagos] (
    [idHistorial]         INT             IDENTITY (1, 1) NOT NULL,
    [idCredito]           INT             NULL,
    [referencia]          VARCHAR (100)   NULL,
    [fechaPago]           DATE            NULL,
    [monto]               DECIMAL (10, 2) NULL,
    [comprobante]         VARCHAR (150)   NULL,
    [idGrupoAdesco]       INT             NULL,
    [idOrganizacionLocal] INT             NULL,
    CONSTRAINT [PK_historialUltimosPagos] PRIMARY KEY CLUSTERED ([idHistorial] ASC),
    CONSTRAINT [FK_historialUltimosPagos_idOrganizacionLocal] FOREIGN KEY ([idOrganizacionLocal]) REFERENCES [dbo].[organizacionesLocales] ([idOrganizacion]),
    CONSTRAINT [FK_historialUltimosPagos_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_historialUltimosPagos_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco])
);


GO

CREATE INDEX [IX_historialUltimosPagos_idOrganizacionLocal] ON [dbo].[historialUltimosPagos] ([idOrganizacionLocal])

GO

CREATE INDEX [IX_historialUltimosPagos_idCredito] ON [dbo].[historialUltimosPagos] ([idCredito])

GO

CREATE INDEX [IX_historialUltimosPagos_idGrupoAdesco] ON [dbo].[historialUltimosPagos] ([idGrupoAdesco])
