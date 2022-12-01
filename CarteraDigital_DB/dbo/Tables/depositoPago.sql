CREATE TABLE [dbo].[depositoPago] (
    [idDeposito]          INT             IDENTITY (1, 1) NOT NULL,
    [montoDepositoo]      DECIMAL (15, 2) NULL,
    [fechaDeposito]       DATE            NULL,
    [idCredito]           INT             NULL,
    [idGestor]            INT             NULL,
    [idRegistroActividad] INT             NULL,
    [idGrupoAdesco]       INT             NULL,
    CONSTRAINT [PK_depositoPago] PRIMARY KEY CLUSTERED ([idDeposito] ASC),
    CONSTRAINT [FK_depositoPago_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_depositoPago_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_depositoPago_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco]),
    CONSTRAINT [FK_depositoPago_idRegistroActividad] FOREIGN KEY ([idRegistroActividad]) REFERENCES [dbo].[registroActividades] ([idRegistroActividad])
);


GO

CREATE INDEX [IX_depositoPago_idCredito] ON [dbo].[depositoPago] ([idCredito])

GO

CREATE INDEX [IX_depositoPago_idGestor] ON [dbo].[depositoPago] ([idGestor])

GO

CREATE INDEX [IX_depositoPago_idGrupoAdesco] ON [dbo].[depositoPago] ([idGrupoAdesco])

GO

CREATE INDEX [IX_depositoPago_idRegistroActividad] ON [dbo].[depositoPago] ([idRegistroActividad])
