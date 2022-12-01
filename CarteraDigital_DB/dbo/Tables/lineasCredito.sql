CREATE TABLE [dbo].[lineasCredito] (
    [idLineaCredito] INT           IDENTITY (1, 1) NOT NULL,
    [idLineaT]       VARCHAR (50)  NULL,
    [lineaCredito]   VARCHAR (100) NULL,
    [lineaCreditoC]  VARCHAR (100) NULL,
    [destino]        VARCHAR (100) NULL,
    [estado]         INT           NULL,
    CONSTRAINT [PK_lineasCredito] PRIMARY KEY CLUSTERED ([idLineaCredito] ASC)
);


GO

CREATE INDEX [IX_lineasCredito_estado] ON [dbo].[lineasCredito] ([estado])
