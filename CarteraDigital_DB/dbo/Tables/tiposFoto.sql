CREATE TABLE [dbo].[tiposFoto] (
    [idTipoPhoto]  INT           IDENTITY (1, 1) NOT NULL,
    [typeGetPhoto] INT           NULL,
    [tipo]         VARCHAR (150) NULL,
    CONSTRAINT [PK_tiposFoto] PRIMARY KEY CLUSTERED ([idTipoPhoto] ASC)
);

