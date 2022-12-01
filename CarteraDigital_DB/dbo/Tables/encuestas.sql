CREATE TABLE [dbo].[encuestas] (
    [idEncuesta]     INT           IDENTITY (1, 1) NOT NULL,
    [nombre]         VARCHAR (150) NULL,
    [objetivo]       VARCHAR (150) NULL,
    [privada]        INT           DEFAULT ((1)) NULL,
    [idEmpresa]      INT           NULL,
    [fechaInicio]    DATE          NULL,
    [fechaLimite]    DATE          NULL,
    [etapa]          INT           NULL,
    [estado]         INT           NULL,
    [imagenes]       INT           NULL,
    [idEncabezado]   INT           NULL,
    [idEdad]         INT           NULL,
    [idExtra]        INT           NULL,
    [idAgencia]      INT           NULL,
    [idTipoEncuesta] INT           NULL,
    [indexT]         INT           NULL,
    CONSTRAINT [PK_encuestas] PRIMARY KEY CLUSTERED ([idEncuesta] ASC),
    CONSTRAINT [FK_encuestas_idAgencia] FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_encuestas_idTipoEncuesta] FOREIGN KEY ([idTipoEncuesta]) REFERENCES [dbo].[tiposEncuesta] ([idTipoEncuesta])
);


GO

CREATE INDEX [IX_encuestas_estado] ON [dbo].[encuestas] ([estado])

GO

CREATE INDEX [IX_encuestas_idAgencia] ON [dbo].[encuestas] ([idAgencia])

GO

CREATE INDEX [IX_encuestas_idTipoEncuesta] ON [dbo].[encuestas] ([idTipoEncuesta])
