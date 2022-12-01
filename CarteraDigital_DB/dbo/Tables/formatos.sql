CREATE TABLE [dbo].[formatos] (
    [idFormato] INT          IDENTITY (1, 1) NOT NULL,
    [tipo]      VARCHAR (50) NULL,
    [alias]     VARCHAR (50) NULL,
    [icon]      VARCHAR (50) NULL,
    CONSTRAINT [PK_formatos] PRIMARY KEY CLUSTERED ([idFormato] ASC)
);

