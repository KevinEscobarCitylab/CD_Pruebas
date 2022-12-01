CREATE TABLE [dbo].[historialProspectos] (
    [idHistorialProspecto] INT      IDENTITY (1, 1) NOT NULL,
    [idProspecto]          INT      NULL,
    [idGestorOrigen]       INT      NULL,
    [idGestorDestino]      INT      NULL,
    [fecha]                DATETIME NULL,
    [idGrupo]              INT      NULL,
    CONSTRAINT [PK_historialProspectos] PRIMARY KEY CLUSTERED ([idHistorialProspecto] ASC),
    CONSTRAINT [FK_historialProspectos_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos] ([idProspecto])
);


GO

CREATE INDEX [IX_historialProspectos_idProspecto] ON [dbo].[historialProspectos] ([idProspecto])
