CREATE TABLE [dbo].[inicioSesionJS] (
    [ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [usuario]               NVARCHAR (MAX) NULL,
    [app]                   NVARCHAR (MAX) NULL,
    [formatos]              NVARCHAR (MAX) NULL,
    [encuestas]             NVARCHAR (MAX) NULL,
    [menu]                  NVARCHAR (MAX) NULL,
    [actividades]           NVARCHAR (MAX) NULL,
    [detalleActividades]    NVARCHAR (MAX) NULL,
    [reacciones]            NVARCHAR (MAX) NULL,
    [motivoActividades]     NVARCHAR (MAX) NULL,
    [carteraClientes]       NVARCHAR (MAX) NULL,
    [grupos]                NVARCHAR (MAX) NULL,
    [organizacionesLocales] NVARCHAR (MAX) NULL,
    [promesasPago]          NVARCHAR (MAX) NULL,
    [indicadores]           NVARCHAR (MAX) NULL,
    [solicitudes]           NVARCHAR (MAX) NULL,
    [campanias]             NVARCHAR (MAX) NULL,
    [clientesCampanias]     NVARCHAR (MAX) NULL,
    [ruta]                  NVARCHAR (MAX) NULL,
    [fiadores]              NVARCHAR (MAX) NULL,
    [prospectos]            NVARCHAR (MAX) NULL,
    [historial]             NVARCHAR (MAX) NULL,
    [incidencias]           NVARCHAR (MAX) NULL,
    [encuestasW]            NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_inicioSesionJS] PRIMARY KEY CLUSTERED ([ID] ASC)
);

