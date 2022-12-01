CREATE TABLE [dbo].[tablasCore] (
    [idTabla] INT          IDENTITY (1, 1) NOT NULL,
    [nombre]  VARCHAR (50) NULL,
    CONSTRAINT [PK_tablasCore] PRIMARY KEY CLUSTERED ([idTabla] ASC)
);

