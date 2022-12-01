CREATE TABLE [dbo].[creditos] (
    [idCredito]                   INT             IDENTITY (1, 1) NOT NULL,
    [idCreditoT]                  VARCHAR (100)   NULL,
    [referencia]                  VARCHAR (100)   NULL,
    [idCliente]                   INT             NULL,
    [pagoParaEstarAlDia]          DECIMAL (10, 2) NULL,
    [pagoParaTramo30]             DECIMAL (10, 2) NULL,
    [pagoParaTramo60]             DECIMAL (10, 2) NULL,
    [pagoParaTramo90]             DECIMAL (10, 2) NULL,
    [valorCuota]                  DECIMAL (10, 2) NULL,
    [diasCapitalMora]             INT             NULL,
    [deudaTotal]                  DECIMAL (10, 2) NULL,
    [gestionesRealizadas]         INT             NULL,
    [gestionado]                  INT             NULL,
    [ultimoPago]                  DECIMAL (12, 2) NULL,
    [fechaOtorgamiento]           DATE            NULL,
    [fechaDesembolso]             DATE            NULL,
    [diasDesembolso]              INT             NULL,
    [fechaVencimiento]            DATE            NULL,
    [fechaCancelacion]            DATE            NULL,
    [diasTranscurridos]           INT             NULL,
    [diasRestantesPlazo]          INT             NULL,
    [diasUltimoSeguimiento]       INT             NULL,
    [totalGestionesSeguimiento]   INT             NULL,
    [fechaSeguimiento]            DATE            NULL,
    [etapaSeguimiento]            INT             NULL,
    [rangoEtapaSeguimiento]       INT             NULL,
    [seguimiento]                 INT             NULL,
    [fechaProximaCuota]           DATE            NULL,
    [saldoCapitalVencido]         DECIMAL (10, 2) NULL,
    [saldoCapitalVigente]         DECIMAL (10, 2) NULL,
    [montoOtorgado]               DECIMAL (10, 2) NULL,
    [montoReserva]                DECIMAL (10, 2) NULL,
    [montoCanceladoPorcentual]    DECIMAL (10, 2) NULL,
    [montoProximaCuota]           DECIMAL (10, 2) NULL,
    [capitalMora]                 DECIMAL (10, 2) NULL,
    [capitalTotalAdeudado]        DECIMAL (10, 2) NULL,
    [ultimaFechaPago]             DATE            NULL,
    [plazo]                       INT             NULL,
    [frecuencia]                  VARCHAR (50)    NULL,
    [cantidadCuotas]              INT             NULL,
    [plazoTranscurridoPorcentual] DECIMAL (10, 2) NULL,
    [porVencer]                   INT             NULL,
    [idLineaCredito]              INT             NULL,
    [fechaAperturaLinea]          DATE            NULL,
    [fechaVencimientoLinea]       DATE            NULL,
    [estadoLineaU]                VARCHAR (20)    NULL,
    [estadoLineaM]                VARCHAR (20)    NULL,
    [tasaInteresNominal]          DECIMAL (10, 2) NULL,
    [diasMoraMaximoEnCuota]       INT             NULL,
    [cupoMaximoAutorizado]        DECIMAL (10, 2) NULL,
    [idGrupo]                     INT             NULL,
    [idAgencia]                   INT             NULL,
    [idPrioridad]                 INT             NULL,
    [prioridad]                   INT             NULL,
    [diasPrioridad]               INT             NULL,
    [prioridadAgencia]            INT             NULL,
    [diasPrioridadAgencia]        INT             NULL,
    [fechaPrioridad]              DATE            NULL,
    [promesas]                    INT             NULL,
    [diasPromesa]                 INT             NULL,
    [desertado]                   INT             NULL,
    [diasDesertado]               INT             NULL,
    [totalGestionesDesertado]     INT             NULL,
    [porDesertar]                 INT             NULL,
    [diasPorDesertar]             INT             NULL,
    [diasCampania]                INT             NULL,
    [renovacion]                  INT             NULL,
    [diasRenovacion]              INT             NULL,
    [refinanciado]                INT             NULL,
    [refinanciamiento]            INT             NULL,
    [idEstado]                    INT             NULL,
    [totalGestionesCobro]         INT             NULL,
    [fechaPorDesertar]            DATE            NULL,
    [institucionConsulta]         VARCHAR (150)   NULL,
    [totalGestionesPorDesertar]   INT             NULL,
    [idCriterioSeguimiento]       INT             NULL,
    [totalGestionesRenovacion]    INT             NULL,
    [cierre]                      INT             NULL,
    [calificacionCliente]         VARCHAR (10)    NULL,
    [notaCliente]                 VARCHAR (25)    NULL,
    [idOrganizacion]              INT             NULL,
    [cuotaVenceHoy]               INT             NULL,
    [desembolso]                  INT             NULL,
    [idProspecto]                 INT             NULL,
    [diasUltimaGMora]             INT             NULL,
    [diasUltimaGSeguimiento]      INT             NULL,
    [diasUltimaGRenovacion]       INT             NULL,
    [diasUltimaGDesertado]        INT             NULL,
    [DUG]                         INT             NULL,
    [UG]                          VARCHAR (50)    NULL,
    [ampliacion]                  INT             NULL,
    [atrasoMaximo]                INT             NULL,
    [cuotasPagadas]               INT             NULL,
    [cuotasNoPagadas]             INT             NULL,
    [ciclo]                       INT             NULL,
    [interes]                     DECIMAL (15, 2) NULL,
    [seguro]                      DECIMAL (15, 2) NULL,
    [recargo]                     DECIMAL (15, 2) NULL,
    [clasificacion]               VARCHAR (200)   NULL,
    [asesorColocador]             VARCHAR (200)   NULL,
    [asesorAnterior]              VARCHAR (200)   NULL,
    [fechaCambioAsesor]           DATE            NULL,
    [atrasoPromedio]              INT             NULL,
    [montoRecuperado]             DECIMAL (15, 2) NULL,
    [diasProximaCuota]            INT             NULL,
    [cobroPreventivo]             INT             NULL,
    [titular]                     INT             NULL,
    [d1]                          NVARCHAR(MAX)   NULL,
    [enMora]                      INT             NULL,
    [vencimiento]                 INT             NULL,
    [infoE]                       NVARCHAR (MAX)  NULL,
    [idCriterio]                  INT             NULL,
    [emergentes]                  NVARCHAR (MAX)  NULL,
    [diasVisitaReprogramada]      INT             NULL,
    [inactivo]                    INT             NULL,
    [tipoMoneda]                  VARCHAR (MAX)   NULL,
    [idPtemp]                     INT             NULL,
    [table_ext]                   NVARCHAR(MAX)   NULL,
    [tipo]                        INT             NULL,
    [tarjeta]                     INT             NULL,
    [cultureInfo]                 VARCHAR(10)     NULL, 
    [f1]                          INT             DEFAULT ((0)) NULL, 
    CONSTRAINT [PK_creditos] PRIMARY KEY CLUSTERED ([idCredito] ASC),
    CONSTRAINT [FK_creditos_idAgencia] FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_creditos_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente]),
    CONSTRAINT [FK_creditos_idCriterioSeguimiento] FOREIGN KEY ([idCriterioSeguimiento]) REFERENCES [dbo].[criteriosSeguimiento] ([idCriterio]),
    CONSTRAINT [FK_creditos_idEstado] FOREIGN KEY ([idEstado]) REFERENCES [dbo].[estadosCredito] ([idEstado]),
    CONSTRAINT [FK_creditos_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_creditos_idLineaCredito] FOREIGN KEY ([idLineaCredito]) REFERENCES [dbo].[lineasCredito] ([idLineaCredito]),
    CONSTRAINT [FK_creditos_idOrganizacion] FOREIGN KEY ([idOrganizacion]) REFERENCES [dbo].[organizacionesLocales] ([idOrganizacion]),
    CONSTRAINT [FK_creditos_idPrioridad] FOREIGN KEY ([idPrioridad]) REFERENCES [dbo].[prioridades] ([idPrioridad]),
    CONSTRAINT [FK_creditos_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos] ([idProspecto])
);


GO

CREATE INDEX [IX_creditos_idAgencia] ON [dbo].[creditos] ([idAgencia])

GO

CREATE INDEX [IX_creditos_idCliente] ON [dbo].[creditos] ([idCliente])

GO

CREATE INDEX [IX_creditos_idCriterioSeguimiento] ON [dbo].[creditos] ([idCriterioSeguimiento])

GO

CREATE INDEX [IX_creditos_idEstado] ON [dbo].[creditos] ([idEstado])

GO

CREATE INDEX [IX_creditos_idGrupo] ON [dbo].[creditos] ([idGrupo])

GO

CREATE INDEX [IX_creditos_idLineaCredito] ON [dbo].[creditos] ([idLineaCredito])

GO

CREATE INDEX [IX_creditos_idOrganizacion] ON [dbo].[creditos] ([idOrganizacion])

GO

CREATE INDEX [IX_creditos_idPrioridad] ON [dbo].[creditos] ([idPrioridad])

GO

CREATE INDEX [IX_creditos_idProspecto] ON [dbo].[creditos] ([idProspecto])

GO

CREATE INDEX [IX_creditos_gestionado] ON [dbo].[creditos] ([gestionado])

GO

CREATE INDEX [IX_creditos_seguimiento] ON [dbo].[creditos] ([seguimiento])

GO

CREATE INDEX [IX_creditos_porVencer] ON [dbo].[creditos] ([porVencer])

GO

CREATE INDEX [IX_creditos_prioridad] ON [dbo].[creditos] ([prioridad])

GO

CREATE INDEX [IX_creditos_desertado] ON [dbo].[creditos] ([desertado])

GO

CREATE INDEX [IX_creditos_renovacion] ON [dbo].[creditos] ([renovacion])

GO

CREATE INDEX [IX_creditos_cuotaVenceHoy] ON [dbo].[creditos] ([cuotaVenceHoy])

GO

CREATE INDEX [IX_creditos_desembolso] ON [dbo].[creditos] ([desembolso])

GO

CREATE INDEX [IX_creditos_enMora] ON [dbo].[creditos] ([enMora])

GO

CREATE INDEX [IX_creditos_vencimiento] ON [dbo].[creditos] ([vencimiento])
