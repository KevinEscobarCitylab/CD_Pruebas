CREATE TABLE [dbo].[opcionesImprimibles] (
    [idOpcion] INT          IDENTITY (1, 1) NOT NULL,
    [opcion]   VARCHAR (50) NULL,
    [_class]   VARCHAR (50) NULL,
    CONSTRAINT [PK_opcionesImprimibles] PRIMARY KEY CLUSTERED ([idOpcion] ASC)
);

