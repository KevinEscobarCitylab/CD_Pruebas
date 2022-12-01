CREATE TABLE [dbo].[rankings] (
    [idRanking]   INT            IDENTITY (1, 1) NOT NULL,
    [titulo]      VARCHAR (50)   NULL,
    [descripcion] VARCHAR (500)  NULL,
    [niveles]     NVARCHAR (MAX) NULL,
    [d1]          NVARCHAR (MAX) NULL,
    [estado]      INT            NULL,
    CONSTRAINT [PK_rankings] PRIMARY KEY CLUSTERED ([idRanking] ASC)
);


GO

CREATE INDEX [IX_rankings_estado] ON [dbo].[rankings] ([estado])
