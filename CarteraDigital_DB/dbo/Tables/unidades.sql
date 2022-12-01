CREATE TABLE [dbo].[unidades] (
    [idUnidad]  INT          IDENTITY (1, 1) NOT NULL,
    [unidad]    VARCHAR (50) NULL,
    [alias]     VARCHAR (50) NULL,
    [idFormato] INT          NULL,
    CONSTRAINT [PK_unidades] PRIMARY KEY CLUSTERED ([idUnidad] ASC),
    CONSTRAINT [FK_unidades_idFormato] FOREIGN KEY ([idFormato]) REFERENCES [dbo].[formatos] ([idFormato])
);


GO

CREATE INDEX [IX_unidades_idFormato] ON [dbo].[unidades] ([idFormato])
