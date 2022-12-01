CREATE TABLE [dbo].[etapasProspecto] (
    [idEtapa]      BIGINT   IDENTITY (1, 1) NOT NULL,
    [etapa]        INT      NULL,
    [idProspecto]  INT      NULL,
    [comentario]   VARCHAR(MAX) NULL,
    [fecha]        DATETIME NULL,
    [idFormulario] INT      NULL,
    [idGestor]     INT      NULL,
    [idUsuarioAd]  INT      NULL,
    [idPregunta]   INT      NULL,
    [idPreguntaR]  INT      NULL,
    [totalCampos]  INT      NULL,
    [sistema]      INT      NULL, 
    CONSTRAINT [PK_etapasProspecto] PRIMARY KEY CLUSTERED ([idEtapa]), 
    CONSTRAINT [FK_etapasProspecto_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores]([idGestor]), 
    CONSTRAINT [FK_etapasProspecto_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos]([idProspecto]), 
    CONSTRAINT [FK_etapasProspecto_idPregunta] FOREIGN KEY ([idPregunta]) REFERENCES [dbo].[preguntas]([idPregunta])
);


GO

CREATE INDEX [IX_etapasProspecto_idGestor] ON [dbo].[etapasProspecto] ([idGestor])

GO

CREATE INDEX [IX_etapasProspecto_idProspecto] ON [dbo].[etapasProspecto] ([idProspecto])

GO

CREATE INDEX [IX_etapasProspecto_idFormulario] ON [dbo].[etapasProspecto] ([idFormulario])

GO

CREATE INDEX [IX_etapasProspecto_idPregunta] ON [dbo].[etapasProspecto] ([idPregunta])

GO

CREATE INDEX [IX_etapasProspecto_etapa] ON [dbo].[etapasProspecto] ([etapa])

GO

CREATE INDEX [IX_etapasProspecto_sistema] ON [dbo].[etapasProspecto] ([sistema])
