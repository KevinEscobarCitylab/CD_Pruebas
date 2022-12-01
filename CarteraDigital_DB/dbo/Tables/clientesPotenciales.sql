CREATE TABLE [dbo].[clientesPotenciales] (
    [idClienteP]                 INT           IDENTITY (1, 1) NOT NULL,
    [idClienteT]                 VARCHAR (25)  NULL,
    [codigo]                     VARCHAR (50)  NULL,
    [nombre]                     VARCHAR (200) NULL,
    [telefono]                   VARCHAR (50)  NULL,
    [direccion]                  VARCHAR(MAX)          NULL,
    [NIT]                        VARCHAR (50)  NULL,
    [idActividadE]               INT           NULL,
    [probabilidadIncumplimiento] VARCHAR (25)  NULL,
    [tipoCliente]                VARCHAR (50)  NULL,
    [latitud]                    VARCHAR (75)  NULL,
    [longitud]                   VARCHAR (75)  NULL,
    [latitudNegocio]             VARCHAR (75)  NULL,
    [longitudNegocio]            VARCHAR (75)  NULL,
    [idEstado]                   INT           NULL,
    CONSTRAINT [PK_clientesPotenciales] PRIMARY KEY CLUSTERED ([idClienteP] ASC),
    CONSTRAINT [FK_clientesPotenciales_idActividadE] FOREIGN KEY ([idActividadE]) REFERENCES [dbo].[actividadesEconomicas] ([idActividadE]),
    CONSTRAINT [FK_clientesPotenciales_idEstado] FOREIGN KEY ([idEstado]) REFERENCES [dbo].[estadosCliente] ([idEstadoCliente])
);


GO

CREATE INDEX [IX_clientesPotenciales_idActividadE] ON [dbo].[clientesPotenciales] ([idActividadE])

GO

CREATE INDEX [IX_clientesPotenciales_idEstado] ON [dbo].[clientesPotenciales] ([idEstado])
