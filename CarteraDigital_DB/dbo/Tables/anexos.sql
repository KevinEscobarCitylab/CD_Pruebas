CREATE TABLE [dbo].[anexos] (
    [idAnexo]     INT          IDENTITY (1, 1) NOT NULL,
    [nombre]      VARCHAR (75) NULL,
    [url]         NVARCHAR(MAX)         NULL,
    [idProspecto] INT          NULL,
    [idUsuarioAd] INT          NULL
);

