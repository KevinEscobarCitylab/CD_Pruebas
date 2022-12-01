CREATE TABLE [dbo].[tiposFormularios] (
    [idTipoFormularios] INT IDENTITY (1, 1) NOT NULL,
    [tipo]   VARCHAR (150)  NULL,
    [codigo]   VARCHAR (50)  NULL,
  CONSTRAINT [PK_tiposFormularios]  PRIMARY KEY CLUSTERED ([idTipoFormularios] ASC)
);
