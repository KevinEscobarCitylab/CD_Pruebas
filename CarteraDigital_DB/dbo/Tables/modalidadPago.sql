CREATE TABLE [dbo].[modalidadPago] (
    [idModalidad] INT           IDENTITY (1, 1) NOT NULL,
    [modalidad]   VARCHAR (100) NULL,
    [valor]       VARCHAR (100) NULL,
   CONSTRAINT [PK_modalidadPago] PRIMARY KEY CLUSTERED ([idModalidad] ASC)
);

