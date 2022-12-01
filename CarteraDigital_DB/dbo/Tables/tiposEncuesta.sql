CREATE TABLE [dbo].[tiposEncuesta] (
    [idTipoEncuesta] INT          IDENTITY (1, 1) NOT NULL,
    [codigo]         VARCHAR (5)  NULL,
    [tipo]           VARCHAR (50) NULL,
    [app]            INT DEFAULT NULL,
    CONSTRAINT [PK_TiposEncuesta] PRIMARY KEY CLUSTERED ([idTipoEncuesta] ASC)
);

