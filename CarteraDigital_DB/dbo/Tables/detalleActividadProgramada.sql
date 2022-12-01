CREATE TABLE [dbo].[detalleActividadProgramada] (
    [idDetalleAP]         INT IDENTITY (1, 1) NOT NULL,
    [idOrganizacion]      INT NULL,
    [idOrgLocalP]         INT NULL,
    [idRegistroActividad] INT NULL,
    [numeroParticipantes] INT NULL,
    [idGestor]            INT NULL,
    CONSTRAINT [PK_detalleActividadProgramada] PRIMARY KEY CLUSTERED ([idDetalleAP] ASC),
    CONSTRAINT [FK_detalleActividadProgramada_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_detalleActividadProgramada_idOrganizacion] FOREIGN KEY ([idOrganizacion]) REFERENCES [dbo].[organizacionesLocales] ([idOrganizacion]),
    CONSTRAINT [FK_detalleActividadProgramada_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_detalleActividadProgramada_idGestor] ON [dbo].[detalleActividadProgramada] ([idGestor])

GO

CREATE INDEX [IX_detalleActividadProgramada_idOrganizacion] ON [dbo].[detalleActividadProgramada] ([idOrganizacion])

GO

CREATE INDEX [IX_detalleActividadProgramada_Column_2] ON [dbo].[detalleActividadProgramada] ([idRegistroActividad])
