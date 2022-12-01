CREATE TABLE [dbo].[historialCredito] (
    [idCredito]               INT             NULL,
    [fecha]                   DATE            NULL,
    [pagoParaEstarAlDia]      DECIMAL (10, 2) NULL,
    [pagoParaTramo30]         DECIMAL (10, 2) NULL,
    [pagoParaTramo60]         DECIMAL (10, 2) NULL,
    [pagoParaTramo90]         DECIMAL (10, 2) NULL,
    [deudaTotal]              DECIMAL (10, 2) NULL,
    [ultimoPago]              DECIMAL (12, 2) NULL,
    [fechaProximaCuota]       DATE            NULL,
    [montoProximaCuota]       DECIMAL (10, 2) NULL,
    [saldoCapitalVencido]     DECIMAL (10, 2) NULL,
    [saldoCapitalVigente]     DECIMAL (20, 2) NULL,
    [diasCapitalMora]         INT             DEFAULT ((0)) NULL,
    [capitalMora]             DECIMAL (10, 2) NULL,
    [capitalTotalAdeudado]    DECIMAL (10, 2) NULL,
    [ultimaFechaPago]         DATE            NULL,
    [idPrioridad]             INT             NULL,
    [idCriterioSeguimiento]   INT             NULL,
    [desertado]               INT             NULL,
    [capitalTotalPorDesertar] DECIMAL (10, 2) NULL,
    [institucionConsulta]     VARCHAR (100)   NULL,
    [idEstado]                INT             NULL,
    [seguimiento]             INT             DEFAULT ((0)) NULL,
    [prioridad]               INT             DEFAULT ((0)) NULL,
    [prioridadAgencia]        INT             DEFAULT ((0)) NULL,
    [promesas]                INT             DEFAULT ((0)) NULL,
    [renovacion]              INT             DEFAULT ((0)) NULL,
    [mora]                    INT             DEFAULT ((0)) NULL,
    [porDesertar]             INT             DEFAULT ((0)) NULL,
    [cobroPreventivo]         INT             NULL,
    CONSTRAINT [FK_historialCredito_idCriterioSeguimiento] FOREIGN KEY ([idCriterioSeguimiento]) REFERENCES [dbo].[criteriosSeguimiento] ([idCriterio]),
    CONSTRAINT [FK_historialCredito_idEstado] FOREIGN KEY ([idEstado]) REFERENCES [dbo].[estadosCredito] ([idEstado]),
    CONSTRAINT [FK_historialCredito_idPrioridad] FOREIGN KEY ([idPrioridad]) REFERENCES [dbo].[prioridades] ([idPrioridad]),
    CONSTRAINT [FK_historialCredito_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito])
);



GO

CREATE INDEX [IX_historialCredito_idCredito] ON [dbo].[historialCredito] ([idCredito])

GO

CREATE INDEX [IX_historialCredito_idEstado] ON [dbo].[historialCredito] ([idEstado])

GO

CREATE INDEX [IX_historialCredito_idPrioridad] ON [dbo].[historialCredito] ([idPrioridad])

GO

CREATE INDEX [IX_historialCredito_idCriterioSeguimiento] ON [dbo].[historialCredito] ([idCriterioSeguimiento])
