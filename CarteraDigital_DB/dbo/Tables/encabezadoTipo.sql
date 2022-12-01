CREATE TABLE [dbo].[encabezadoTipo] (
    [idET]  INT           IDENTITY (1, 1) NOT NULL,
    [tipo]  VARCHAR (100) NULL,
    [alias] VARCHAR (50)  NULL,
    CONSTRAINT [PK_encabezadoTipo] PRIMARY KEY CLUSTERED ([idET] ASC)
);

