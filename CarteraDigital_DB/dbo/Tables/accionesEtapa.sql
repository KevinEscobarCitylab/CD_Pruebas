CREATE TABLE [dbo].[accionesEtapa] (
    [idAccion] INT           IDENTITY (1, 1) NOT NULL,
    [accion]   VARCHAR (50)  NULL,
    [_class]   VARCHAR (100) NULL,
    [icon]     VARCHAR (100) NULL,
    [codigo]   VARCHAR (10)  NULL,
    [tipo]     VARCHAR (10)  NULL,
    [idEtapa]  INT           NULL,
  CONSTRAINT [PK_accionesEtapa]  PRIMARY KEY CLUSTERED ([idAccion] ASC)
);

