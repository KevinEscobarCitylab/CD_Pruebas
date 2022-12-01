CREATE TABLE [dbo].[estadosGruposAdesco] (
    [idEstado] INT          IDENTITY (1, 1) NOT NULL,
    [codigo]   VARCHAR (10) NULL,
    [estado]   VARCHAR (25) NULL,
    CONSTRAINT [PK_estadosGruposAdesco]PRIMARY KEY CLUSTERED ([idEstado] ASC)
);

GO

CREATE INDEX [IX_estadosGruposAdesco_estado] ON [dbo].[estadosGruposAdesco] ([estado])
