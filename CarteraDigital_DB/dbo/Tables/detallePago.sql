CREATE TABLE [dbo].[detallePago] (
    [idDetalleP]          INT             IDENTITY (1, 1) NOT NULL,
    [montoPorCobrar]      DECIMAL (14, 2) NULL,
    [montoReal]           DECIMAL (10, 2) NULL,
    [numeroComprobante]   VARCHAR (50)    NULL,
    [fechaPago]           DATE            NULL,
    [fechaGestion]        DATE            NULL,
    [idCredito]           INT             NULL,
    [idGestor]            INT             NULL,
    [idRegistroActividad] INT             NULL,
    [idGrupoAdesco]       INT             NULL,
    CONSTRAINT [PK_detallePago]PRIMARY KEY CLUSTERED ([idDetalleP] ASC),
    CONSTRAINT [FK_detallePago_idGrupoAdesco]FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_detallePago_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_detallePago_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_detallePago_idResgistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_detallePago_idGrupoAdesco] ON [dbo].[detallePago] ([idGrupoAdesco])

GO

CREATE INDEX [IX_detallePago_idCredito] ON [dbo].[detallePago] ([idCredito])

GO

CREATE INDEX [IX_detallePago_idGestor] ON [dbo].[detallePago] ([idGestor])

GO

CREATE INDEX [IX_detallePago_idRegistroActividad] ON [dbo].[detallePago] ([idRegistroActividad])
