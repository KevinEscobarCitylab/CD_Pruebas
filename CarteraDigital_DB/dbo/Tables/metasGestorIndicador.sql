CREATE TABLE [dbo].[metasGestorIndicador] (
    [idMetaG]     INT             IDENTITY (1, 1) NOT NULL,
    [idIndicador] INT             NULL,
    [idGestor]    INT             NULL,
    [meta]        DECIMAL (18, 2) NULL,
    [valorCierre] DECIMAL (18, 2) NULL,
    [valorActual] DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_metasGestorIndicador] PRIMARY KEY CLUSTERED ([idMetaG] ASC),
    CONSTRAINT [FK_metasGestorIndicador_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_metasGestorIndicador_idIndicador] FOREIGN KEY ([idIndicador]) REFERENCES [dbo].[indicadores] ([idIndicador])
);


GO

CREATE INDEX [IX_metasGestorIndicador_idGestor] ON [dbo].[metasGestorIndicador] ([idGestor])

GO

CREATE INDEX [IX_metasGestorIndicador_idIndicador] ON [dbo].[metasGestorIndicador] ([idIndicador])
