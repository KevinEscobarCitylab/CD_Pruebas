﻿CREATE TABLE [dbo].[campaniaAlDia] (
    [idClienteCampania] INT           NULL,
    [idCampania]        INT           NULL,
    [idCredito]         INT           NULL,
    [idCliente]         INT           NULL,
    [idClienteP]        INT           NULL,
    [referencia]        VARCHAR (50)  NULL,
    [codigoCliente]     VARCHAR (50)  NULL,
    [cliente]           VARCHAR (150) NULL,
    [direccion]         VARCHAR (200) NULL,
    [telefono]          VARCHAR (100) NULL,
    [fechaInicio]       VARCHAR (25)  NULL,
    [fechaFin]          VARCHAR (25)  NULL,
    [diasCampania]      INT           NULL,
    [latitud]           VARCHAR (25)  NULL,
    [longitud]          VARCHAR (25)  NULL,
    [latitudNegocio]    VARCHAR (25)  NULL,
    [longitudNegocio]   VARCHAR (25)  NULL,
    [visita]            INT           NULL,
    [actividadVisita]   VARCHAR (50)  NULL,
    [fechaVisita]       VARCHAR (25)  NULL,
    [diasVisita]        INT           NULL,
    [visitaPopup]       INT           NULL,
    [DUG]               INT           NULL,
    [UD]                VARCHAR (25)  NULL,
    [result]            NVARCHAR(MAX) NULL,
    [popup]             NVARCHAR(MAX) NULL,
    [indexP]            INT           NULL,
    [idGestor]          INT           NULL,
    [gestionado]        INT           NULL
);
