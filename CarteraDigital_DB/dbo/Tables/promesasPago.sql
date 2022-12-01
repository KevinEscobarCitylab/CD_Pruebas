CREATE TABLE [dbo].[promesasPago] (
    [idPromesa]           INT             IDENTITY (1, 1) NOT NULL,
    [montoPrometido]      DECIMAL (10, 2) NULL,
    [montoPagado]         DECIMAL (20, 2) NULL,
    [fechaPromesa]        DATE            NULL,
    [fechaGestion]        DATE            NULL,
    [idCredito]           INT             NULL,
    [idGestor]            INT             NULL,
    [idRegistroActividad] INT             NULL,
    [diasPromesa]         INT             NULL,
    [incumplida]          INT             NULL,
    [porVencer]           INT             NULL,
    [venceHoy]            INT             NULL,
    [idGrupoAdesco]       INT             NULL,
    [idUsuario]           INT             NULL,
    CONSTRAINT [PK_promesasPago] PRIMARY KEY CLUSTERED ([idPromesa] ASC),
    CONSTRAINT [FK_promesasPago_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_promesasPago_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_promesasPago_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_promesasPago_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_promesasPago_idGrupoAdesco] ON [dbo].[promesasPago] ([idGrupoAdesco])

GO

CREATE INDEX [IX_promesasPago_idCredito] ON [dbo].[promesasPago] ([idCredito])

GO

CREATE INDEX [IX_promesasPago_idGestor] ON [dbo].[promesasPago] ([idGestor])

GO

CREATE INDEX [IX_promesasPago_idRegistroActividad] ON [dbo].[promesasPago] ([idRegistroActividad])

GO

CREATE INDEX [IX_promesasPago_incumplida] ON [dbo].[promesasPago] ([incumplida])

GO

CREATE INDEX [IX_promesasPago_porVencer] ON [dbo].[promesasPago] ([porVencer])

GO

CREATE INDEX [IX_promesasPago_venceHoy] ON [dbo].[promesasPago] ([venceHoy])
