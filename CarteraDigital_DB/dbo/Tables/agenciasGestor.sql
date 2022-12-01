CREATE TABLE [dbo].[agenciasGestor] (
    [idAgenciaGestor] INT IDENTITY (1, 1) NOT NULL,
    [idGestor]        INT ,
    [idAgencia]       INT NULL,
    [estado]          INT NULL,
    CONSTRAINT [PK_agenciasGestor] PRIMARY KEY CLUSTERED ([idAgenciaGestor] ASC),
    CONSTRAINT [FK_agenciasGestor_idAgencia] FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_agenciasGestor_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_agenciasGestor_idAgencia] ON [dbo].[agenciasGestor] ([idAgencia])

GO

CREATE INDEX [IX_agenciasGestor_idGestor] ON [dbo].[agenciasGestor] ([idGestor])

GO

CREATE INDEX [IX_agenciasGestor_estado] ON [dbo].[agenciasGestor] ([estado])
