CREATE TABLE [dbo].[fiadoresAsignados] (
    [idFiadorAsignado] INT          IDENTITY (1, 1) NOT NULL,
    [idFiador]         INT          NULL,
    [idCredito]        INT          NULL,
    [idFiadorT]        VARCHAR (75) NULL,
    [referencia]       VARCHAR (75) NULL,
    [estado]           INT          NULL,
    [codeudor]         INT          NULL,
    CONSTRAINT [PK_fiadoresAsignados] PRIMARY KEY CLUSTERED ([idFiadorAsignado] ASC),
    CONSTRAINT [FK_fiadoresAsignados_idFiador] FOREIGN KEY ([idFiador]) REFERENCES [dbo].[fiadores] ([idFiador]),
    CONSTRAINT [FK_fiadoresAsignados_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito])
);


GO

CREATE INDEX [IX_fiadoresAsignados_idFiador] ON [dbo].[fiadoresAsignados] ([idFiador])

GO

CREATE INDEX [IX_fiadoresAsignados_idCredito] ON [dbo].[fiadoresAsignados] ([idCredito])

GO

CREATE INDEX [IX_fiadoresAsignados_estado] ON [dbo].[fiadoresAsignados] ([estado])
