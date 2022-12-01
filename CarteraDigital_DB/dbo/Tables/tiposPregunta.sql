CREATE TABLE [dbo].[tiposPregunta] (
    [idTipo] INT          IDENTITY (1, 1) NOT NULL,
    [tipo]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tiposPregunta] PRIMARY KEY CLUSTERED ([idTipo] ASC)
);

