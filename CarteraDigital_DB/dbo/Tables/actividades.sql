CREATE TABLE [dbo].[actividades] (
    [idActividad]            INT           IDENTITY (1, 1) NOT NULL,
    [codigo]                 VARCHAR (5)   NULL,
    [actividad]              VARCHAR (100) NULL,
    [estado]                 INT           NULL,
    [reporte]                INT           NULL,
    [icono]                  VARCHAR (150) NULL,
    [motivoObligatorio]      INT           NULL,
    [fotoObligatorio]        INT           NULL,
    [observacionObligatorio] INT           NULL,
    [wa]                     VARCHAR(1000) NULL,
    CONSTRAINT [PK_actividades] PRIMARY KEY CLUSTERED ([idActividad] ASC)
);

