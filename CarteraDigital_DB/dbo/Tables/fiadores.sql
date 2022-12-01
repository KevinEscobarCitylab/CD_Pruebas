CREATE TABLE [dbo].[fiadores] (
    [idFiador]         INT           IDENTITY (1, 1) NOT NULL,
    [idFiadorT]        VARCHAR (75)  NULL,
    [nombre]           VARCHAR (100) NULL,
    [telefono]         VARCHAR (25)  NULL,
    [direccion]        VARCHAR(MAX)          NULL,
    [latitud]          VARCHAR (100) NULL,
    [longitud]         VARCHAR (100) NULL,
    [latitudNegocio]   VARCHAR (100) NULL,
    [longitudNegocio]  VARCHAR (100) NULL,
    [imgCasa]          VARCHAR (150) NULL,
    [imgNegocio]       VARCHAR (150) NULL,
    [pendienteCasa]    INT           NULL,
    [pendienteNegocio] INT           NULL,
    [fechaGPSCasa]     DATETIME      NULL,
    [fechaGPSNegocio]  DATETIME      NULL,
    CONSTRAINT [PK_fiadores] PRIMARY KEY CLUSTERED ([idFiador] ASC)
);

