CREATE TABLE [dbo].[tiposSolicitudes] (
    [idTipoSolicitud] INT          IDENTITY (1, 1) NOT NULL,
    [idTipoT]         INT          NULL,
    [tipoSolicitud]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tipoSolicitudes] PRIMARY KEY CLUSTERED ([idTipoSolicitud] ASC)
);