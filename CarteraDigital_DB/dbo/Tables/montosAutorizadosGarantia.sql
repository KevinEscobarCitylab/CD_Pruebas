CREATE TABLE [dbo].[montosAutorizadosGarantia] (
    [idMonto]        INT             IDENTITY (1, 1) NOT NULL,
    [idTipoGarantia] INT             NULL,
    [monto]          DECIMAL (10, 2) NULL,
    [montoUS]        DECIMAL (10, 2) NULL,
    [clienteNuevo]   INT             NULL,
    [idGrupo]        INT             NULL,
    CONSTRAINT [PK_montosAutorizadosGarantia]PRIMARY KEY CLUSTERED ([idMonto] ASC),
    CONSTRAINT [FK_montosAutorizadosGarantia_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_montosAutorizadosGarantia_idTipoGarantia]FOREIGN KEY ([idTipoGarantia]) REFERENCES [dbo].[tiposGarantia] ([idTipoGarantia])
);


GO

CREATE INDEX [IX_montosAutorizadosGarantia_idGrupo] ON [dbo].[montosAutorizadosGarantia] ([idGrupo])

GO

CREATE INDEX [IX_montosAutorizadosGarantia_idTipoGarantia] ON [dbo].[montosAutorizadosGarantia] ([idTipoGarantia])
