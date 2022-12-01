CREATE TABLE [dbo].[consultaBuro] (
    [idConsulta]    INT           IDENTITY (1, 1) NOT NULL,
    [codigoCliente] VARCHAR (150) NULL,
    [nombre]        VARCHAR (150) NULL,
    [score]         VARCHAR (50)  NULL,
    [fecha]         DATE          NULL,
    [data]          NVARCHAR(MAX)          NULL,
    [tipo]          VARCHAR (50)  NULL,
    [saved]         INT           DEFAULT ((0)) NULL,
    [codGestor]     VARCHAR (10)  NULL,
    [idClienteT]    VARCHAR (20)  NULL,
    [respuesta]     VARCHAR (500) NULL,
    CONSTRAINT [PK_consultaBuro] PRIMARY KEY CLUSTERED ([idConsulta] ASC)
);

GO
