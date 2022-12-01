CREATE TABLE [dbo].[criteriosCredito] (
    [idCriterio]      INT IDENTITY (1, 1) NOT NULL,
    [idCredito]       INT NULL,
    [prioridad]       INT NULL,
    [renovacion]      INT NULL,
    [seguimiento]     INT NULL,
    [cobroPreventivo] INT NULL,
    [desertado]       INT NULL,
    CONSTRAINT [PK_criteriosCredito] PRIMARY KEY CLUSTERED ([idCriterio] ASC),
    CONSTRAINT [FK_criteriosCredito_cobroPreventivo] FOREIGN KEY ([cobroPreventivo]) REFERENCES [dbo].[criteriosCobroPreventivo] ([idCriterio]),
    CONSTRAINT [FK_criteriosCredito_desertado] FOREIGN KEY ([desertado]) REFERENCES [dbo].[criteriosDesertado] ([idCriterio]),
    CONSTRAINT [FK_criteriosCredito_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_criteriosCredito_prioridad] FOREIGN KEY ([prioridad]) REFERENCES [dbo].[criteriosPrioridad] ([idCriterio]),
    CONSTRAINT [FK_criteriosCredito_renovacion] FOREIGN KEY ([renovacion]) REFERENCES [dbo].[criteriosRenovacion] ([idCriterio]),
    CONSTRAINT [FK_criteriosCredito_seguimiento] FOREIGN KEY ([seguimiento]) REFERENCES [dbo].[criteriosSeguimiento] ([idCriterio])
);


GO

CREATE INDEX [IX_criteriosCredito_cobroPreventivo] ON [dbo].[criteriosCredito] ([cobroPreventivo])

GO

CREATE INDEX [IX_criteriosCredito_desertado] ON [dbo].[criteriosCredito] ([desertado])

GO

CREATE INDEX [IX_criteriosCredito_idCredito] ON [dbo].[criteriosCredito] ([idCredito])

GO

CREATE INDEX [IX_criteriosCredito_prioridad] ON [dbo].[criteriosCredito] ([prioridad])

GO

CREATE INDEX [IX_criteriosCredito_renovacion] ON [dbo].[criteriosCredito] ([renovacion])

GO

CREATE INDEX [IX_criteriosCredito_seguimiento] ON [dbo].[criteriosCredito] ([seguimiento])
