CREATE TABLE [dbo].[condicionesComparacion] (
    [idCondicion] INT          IDENTITY (1, 1) NOT NULL,
    [operador]    VARCHAR (5)  NULL,
    [alias]       VARCHAR (25) NULL,
    CONSTRAINT [PK_condicionesComparacion] PRIMARY KEY CLUSTERED ([idCondicion] ASC)
);

