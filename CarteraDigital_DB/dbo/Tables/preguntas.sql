CREATE TABLE [dbo].[preguntas] (
    [idPregunta]     INT           IDENTITY (1, 1) NOT NULL,
    [pregunta]       VARCHAR (MAX) NULL,
    [idTipo]         INT           NULL,
    [idEncuesta]     INT           NULL,
    [idFormato]      INT           NULL,
    [estado]         INT           NULL,
    [_index]         INT           NULL,
    [requerir]       INT           NULL,
    [idFormulario]   INT           NULL,
    [mask]           VARCHAR (150)  NULL,
    [fx]             VARCHAR (MAX) NULL,
    [referenceTable] VARCHAR (50)  NULL,
    [referenceId]    VARCHAR (50)  NULL,
    [referenceValue] VARCHAR (50)  NULL,
    [referenceFk]    VARCHAR (50)  NULL,
    [idPreguntaFk]   INT           NULL,
    [idRF]           INT           NULL,
    [isHidden]       INT           NULL,
    [indexT]         INT           NULL,
    [codigoCore]     VARCHAR (50)  NULL,
    [idTablaCore]    INT           NULL,
    [_pivot]         VARCHAR (50)  NULL,
    [idPreguntaT]    INT           NULL,
    [idTipoPhoto]    INT           NULL,
    [_default]       VARCHAR (100) NULL,
    [indexReference] INT           NULL,
    [saved1]         VARCHAR (50)  NULL,
    [codigoSIM]      VARCHAR (50)  NULL,
    [idTablaSIM]     INT           NULL,
    [grupo]          INT           NULL,
    [codigoAC]       VARCHAR (50)  NULL,
    [soloLecturaAC]  INT           NULL,
    [parents]        VARCHAR (10)  NULL,
    [maxLength]      INT           NULL,
    [multiple]       INT           NULL,
    [alias]          VARCHAR (50)  NULL,
    [header]         VARCHAR (50)  NULL,
    [disable]        INT           NULL,
    [readOnly]       INT           NULL,
    [formatoR]       INT           NULL,
    [forRejection]   INT           NULL,
    [maxDecimal]     INT           NULL,
    [showDecimal]    INT           NULL,
    CONSTRAINT [PK_preguntas] PRIMARY KEY CLUSTERED ([idPregunta] ASC),
    CONSTRAINT [FK_preguntas_idRF] FOREIGN KEY ([idRF]) REFERENCES [dbo].[restriccionFecha] ([idRF]),
    CONSTRAINT [FK_preguntas_idTablaCore] FOREIGN KEY ([idTablaCore]) REFERENCES [dbo].[tablasCore] ([idTabla]),
    CONSTRAINT [FK_preguntas_idTablaSIM] FOREIGN KEY ([idTablaSIM]) REFERENCES [dbo].[tablasSIM] ([idTablaSIM]),
    CONSTRAINT [FK_preguntas_idTipoPhoto] FOREIGN KEY ([idTipoPhoto]) REFERENCES [dbo].[tiposFoto] ([idTipoPhoto]),
    CONSTRAINT [FK_preguntas_idEncuesta] FOREIGN KEY ([idEncuesta]) REFERENCES [dbo].[encuestas] ([idEncuesta]),
    CONSTRAINT [FK_preguntas_idTipo] FOREIGN KEY ([idTipo]) REFERENCES [dbo].[tiposPregunta] ([idTipo]),
    CONSTRAINT [FK_preguntas_idFormato] FOREIGN KEY ([idFormato]) REFERENCES [dbo].[formatos] ([idFormato]),
    CONSTRAINT [FK_preguntas_idFormulario] FOREIGN KEY ([idFormulario]) REFERENCES [dbo].[formularios] ([idFormulario])
);


GO

CREATE INDEX [IX_preguntas_idRF] ON [dbo].[preguntas] ([idRF])

GO

CREATE INDEX [IX_preguntas_idTabla] ON [dbo].[preguntas] ([idTablaCore])

GO

CREATE INDEX [IX_preguntas_idTablaSIM] ON [dbo].[preguntas] ([idTablaSIM])

GO

CREATE INDEX [IX_preguntas_idTipoPhoto] ON [dbo].[preguntas] ([idTipoPhoto])

GO

CREATE INDEX [IX_preguntas_idEncuesta] ON [dbo].[preguntas] ([idEncuesta])

GO

CREATE INDEX [IX_preguntas_idTipo] ON [dbo].[preguntas] ([idTipo])

GO

CREATE INDEX [IX_preguntas_idFormato] ON [dbo].[preguntas] ([idFormato])

GO

CREATE INDEX [IX_preguntas_idFormulario] ON [dbo].[preguntas] ([idFormulario])

GO

CREATE INDEX [IX_preguntas_estado] ON [dbo].[preguntas] ([estado])

GO

CREATE TRIGGER [dbo].[UpdateFormatoR] ON [dbo].[preguntas] FOR INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON; 
	UPDATE p set
        p.formatoR = dbo.getFormatR(p.idTipo,f.tipo,p.multiple)
	from preguntas p 
	inner join formatos f on f.idFormato=p.idFormato
	where idPregunta in(SELECT idPregunta FROM inserted)
    SET NOCOUNT OFF;
END