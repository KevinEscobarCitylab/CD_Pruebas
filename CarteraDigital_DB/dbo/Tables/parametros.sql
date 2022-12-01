CREATE TABLE [dbo].[parametros] (
    [idParametro] INT          IDENTITY (1, 1) NOT NULL,
    [bc]          NVARCHAR(MAX)         NULL,
    [conf]        NVARCHAR(MAX)         NULL,
    [app]         NVARCHAR(MAX)         NULL,
    [PCLToken]    DATETIME     NULL,
    [tmp]         NVARCHAR(MAX)         NULL,
    [rep]         NVARCHAR(MAX)         NULL,
    [d1]          NVARCHAR(MAX)         NULL,
    [CP]          INT          NULL,
    [VersionDB]   VARCHAR (20) NULL,
    CONSTRAINT [PK_parametros] PRIMARY KEY CLUSTERED ([idParametro] ASC)
);

