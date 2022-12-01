CREATE TABLE [dbo].[criteriosSolicitud] (
    [idCriterio]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [condicion]   VARCHAR(MAX)  NULL,
    CONSTRAINT [PK_criteriosSolicitud] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
);

