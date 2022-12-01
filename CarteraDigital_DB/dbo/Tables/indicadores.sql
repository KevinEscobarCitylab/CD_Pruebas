CREATE TABLE [dbo].[indicadores] (
    [idIndicador] INT             IDENTITY (1, 1) NOT NULL,
    [nombre]      VARCHAR (50)    NULL,
    [valorA]      DECIMAL (10, 2) NULL,
    [valorM]      DECIMAL (10, 2) NULL,
    [idColorA]    INT             NULL,
    [idColorM]    INT             NULL,
    [idColorR]    INT             NULL,
    [inverso]     INT             NULL,
    [idGrupo]     INT             NULL,
    [codigo]      VARCHAR (5)     NULL,
    CONSTRAINT [PK_indicadores] PRIMARY KEY CLUSTERED ([idIndicador] ASC),
    CONSTRAINT [FK_indicadores_idColorA] FOREIGN KEY ([idColorA]) REFERENCES [dbo].[coloresIndicador] ([idColor]),
    CONSTRAINT [FK_clientes_idColorM] FOREIGN KEY ([idColorM]) REFERENCES [dbo].[coloresIndicador] ([idColor]),
    CONSTRAINT [FK_clientes_idColorR] FOREIGN KEY ([idColorR]) REFERENCES [dbo].[coloresIndicador] ([idColor]),
    CONSTRAINT [FK_clientes_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo])
);


GO

CREATE INDEX [IX_indicadores_idColorA] ON [dbo].[indicadores] ([idColorA])

GO

CREATE INDEX [IX_indicadores_idColorR] ON [dbo].[indicadores] ([idColorR])

GO

CREATE INDEX [IX_indicadores_idGrupo] ON [dbo].[indicadores] ([idGrupo])

GO

CREATE INDEX [IX_indicadores_idColorM] ON [dbo].[indicadores] ([idColorM])
