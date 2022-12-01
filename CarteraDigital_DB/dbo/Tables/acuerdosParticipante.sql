CREATE TABLE [dbo].[acuerdosParticipante] (
    [idAcuerdo]           INT             IDENTITY (1, 1) NOT NULL,
    [idRegistroActividad] INT             NULL,
    [idCredito]           INT             NULL,
    [asistencia]          INT             DEFAULT ((0)) NULL,
    [renovacion]          INT             DEFAULT ((0)) NULL,
    [idCF]                INT             NULL,
    [cuota]               DECIMAL (15, 2) NULL,
    [ahorro]              DECIMAL (10, 2) DEFAULT ((0)) NULL,
    CONSTRAINT [PK_acuerdosParticipante] PRIMARY KEY CLUSTERED ([idAcuerdo] ASC),
    CONSTRAINT [FK_acuerdosParticipante_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_acuerdosParticipante_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_acuerdosParticipante_idCredito] ON [dbo].[acuerdosParticipante] ([idCredito])

GO

CREATE INDEX [IX_acuerdosParticipante_idRegistroActividad] ON [dbo].[acuerdosParticipante] ([idRegistroActividad])
