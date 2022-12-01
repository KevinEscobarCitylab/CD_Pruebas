CREATE TABLE [dbo].[informes] (
    [idInforme]   INT             IDENTITY (1, 1) NOT NULL,
    [d1]          NVARCHAR(MAX)            NULL,
    [d2]          NVARCHAR(MAX)            NULL,
    [d3]          INT             NULL,
    [parent]      INT             NULL,
    [codigo]      VARCHAR (25)    NULL,
    [parentCod]   VARCHAR (25)    NULL,
    [version]     DECIMAL (10, 2) NULL,
    [descripcion] VARCHAR (200)   NULL,
    CONSTRAINT [PK_informes] PRIMARY KEY CLUSTERED ([idInforme] ASC)
);

