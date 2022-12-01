CREATE TABLE [dbo].[capacitaciones] (
    [idCapacitacion]      INT             IDENTITY (1, 1) NOT NULL,
    [monto]               DECIMAL (18, 2) NULL,
    [integrantes]         INT             NULL,
    [fecha]               DATE            NULL,
    [fechaDesembolso]     DATE            NULL,
    [hora]                TIME (7)        NULL,
    [idRegistroActividad] INT             NULL,
    [idActividad]         INT             NULL,
    [idCredito]           INT             NULL,
    [idGrupoAdesco]       INT             NULL,
    CONSTRAINT [PK_capacitaciones] PRIMARY KEY CLUSTERED ([idCapacitacion] ASC),
    CONSTRAINT [FK_capacitaciones_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_capacitaciones_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_capacitaciones_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_capacitaciones_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_capacitaciones_idActividad] ON [dbo].[capacitaciones] ([idActividad])

GO

CREATE INDEX [IX_capacitaciones_idCredito] ON [dbo].[capacitaciones] ([idCredito])

GO

CREATE INDEX [IX_capacitaciones_idGrupoAdesco] ON [dbo].[capacitaciones] ([idGrupoAdesco])

GO

CREATE INDEX [IX_capacitaciones_idRegistroActividad] ON [dbo].[capacitaciones] ([idRegistroActividad])
