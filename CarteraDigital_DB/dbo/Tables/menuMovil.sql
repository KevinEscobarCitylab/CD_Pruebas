CREATE TABLE [dbo].[menuMovil] (
    [idMenu]      INT           IDENTITY (1, 1) NOT NULL,
    [menu]        VARCHAR (100) NULL,
    [codigo]      VARCHAR (5)   NULL,
    [descripcion] VARCHAR(MAX)          NULL,
    [categoria]   INT           NULL,
    [estado]      INT           NULL,
    [_index]      INT           NULL,
    CONSTRAINT [PK_menuMovil] PRIMARY KEY CLUSTERED ([idMenu] ASC),
    CONSTRAINT [PK_menuMovil_nonClustered] UNIQUE NONCLUSTERED ([codigo] ASC)
);



GO

CREATE INDEX [IX_menuMovil_estado] ON [dbo].[menuMovil] ([estado])
