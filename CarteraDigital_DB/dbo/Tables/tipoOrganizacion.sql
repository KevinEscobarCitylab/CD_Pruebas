CREATE TABLE [dbo].[tipoOrganizacion] (
    [idTipoOrganizacion] INT          IDENTITY (1, 1) NOT NULL,
    [tipo]               VARCHAR (50) NULL,
    CONSTRAINT [PK_tipoOrganizacion] PRIMARY KEY CLUSTERED ([idTipoOrganizacion] ASC)
);

