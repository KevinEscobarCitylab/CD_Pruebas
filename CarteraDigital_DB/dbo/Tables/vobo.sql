CREATE TABLE [dbo].[vobo] (
    [idVobo]              INT             IDENTITY (1, 1) NOT NULL,
    [monto]               DECIMAL (18, 2) NULL,
    [integrantes]         INT             NULL,
    [idTipoDispersion]    INT             NULL,
    [fecha]               DATE            NULL,
    [hora]                TIME (7)        NULL,
    [idRegistroActividad] INT             NULL,
    [idActividad]         INT             NULL,
    [idCredito]           INT             NULL,
    [idGrupoAdesco]       INT             NULL,
    CONSTRAINT [PK_vobo] PRIMARY KEY CLUSTERED ([idVobo] ASC),
    CONSTRAINT [FK_vobo_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_vobo_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_vobo_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_vobo_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_vobo_idActividad] ON [dbo].[vobo] ([idActividad])

GO

CREATE INDEX [IX_vobo_idCredito] ON [dbo].[vobo] ([idCredito])

GO

CREATE INDEX [IX_vobo_idGrupoAdesco] ON [dbo].[vobo] ([idGrupoAdesco])

GO

CREATE INDEX [IX_vobo_idRegistroActividad] ON [dbo].[vobo] ([idRegistroActividad])
