CREATE TABLE [dbo].[H_ConsultaBuro] (
    [fecha]         DATETIME      NULL,
    [codigoCliente] VARCHAR (150) NULL,
    [nombre]        VARCHAR (150) NULL,
    [respuesta]     VARCHAR (500) NULL,
    [data]          NVARCHAR(MAX)          NULL,
    [b64]           NVARCHAR(MAX)          NULL,
    [codGestor]     VARCHAR (30)  NULL,
    [tipo]          VARCHAR (50)  NULL,
    [cost]          INT           NULL,
    [error]         INT           NULL
);

