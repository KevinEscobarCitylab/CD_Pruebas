CREATE TABLE [dbo].[tiposGarantia] (
    [idTipoGarantia] INT           IDENTITY (1, 1) NOT NULL,
    [tipoGarantia]   VARCHAR (100) NULL,
    CONSTRAINT [PK_tiposGarantia] PRIMARY KEY CLUSTERED ([idTipoGarantia] ASC)
);

