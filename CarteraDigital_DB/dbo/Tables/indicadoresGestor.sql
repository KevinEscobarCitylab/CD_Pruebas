CREATE TABLE [dbo].[indicadoresGestor] (
    [idIndicadorG] INT             IDENTITY (1, 1) NOT NULL,
    [idGestor]     INT             NULL,
    [idIndicador]  INT             NULL,
    [meta]         DECIMAL (31, 2) NULL,
    [valor]        DECIMAL (21, 2) NULL,
    [valorT]       VARCHAR (50)    NULL,
    CONSTRAINT [PK_indicadoresGestor] PRIMARY KEY CLUSTERED ([idIndicadorG] ASC),
    CONSTRAINT [FK_indicadoresGestor_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_indicadoresGestor_idIndicador] FOREIGN KEY ([idIndicador]) REFERENCES [dbo].[indicadores] ([idIndicador])
);


GO

CREATE INDEX [IX_indicadoresGestor_idGestor] ON [dbo].[indicadoresGestor] ([idGestor])

GO

CREATE INDEX [IX_indicadoresGestor_idIndicador] ON [dbo].[indicadoresGestor] ([idIndicador])
