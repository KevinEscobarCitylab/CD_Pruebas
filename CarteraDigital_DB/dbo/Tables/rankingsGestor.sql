CREATE TABLE [dbo].[rankingsGestor] (
    [idRanking]      INT           NULL,
    [idAgencia]      INT           NULL,
    [idGestor]       INT           NULL,
    [rankingAgencia] INT           NULL,
    [ranking]        INT           NULL,
    [tituloRanking]  VARCHAR (100) NULL,
    [iconoRanking]   INT           NULL,
    [colorEmpresa]   VARCHAR (7)   NULL,
    [colorAgencia]   VARCHAR (7)   NULL,
    CONSTRAINT [FK_rankingsGestor_idAgencia] FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_rankingsGestor_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_rankingsGestor_idRanking] FOREIGN KEY ([idRanking]) REFERENCES [dbo].[rankings] ([idRanking])
);


GO

CREATE INDEX [IX_rankingsGestor_idAgencias] ON [dbo].[rankingsGestor] ([idAgencia])

GO

CREATE INDEX [IX_rankingsGestor_idGestor] ON [dbo].[rankingsGestor] ([idGestor])

GO

CREATE INDEX [IX_rankingsGestor_idRanking] ON [dbo].[rankingsGestor] ([idRanking])
