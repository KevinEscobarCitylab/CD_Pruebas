CREATE TABLE [dbo].[creditosAsignados] (
    [idCreditoAsignado] INT           IDENTITY (1, 1) NOT NULL,
    [idCredito]         INT           NULL,
    [idCreditoT]        VARCHAR (50)  NULL,
    [idGestor]          INT           NULL,
    [asignado]          INT           NULL,
    [asignadoAyer]      INT           DEFAULT ((0)) NOT NULL,
    [idGestorT]         VARCHAR (50)  NULL,
    [sistema]           INT           NULL,
    [referencia]        VARCHAR (100) NULL,
    CONSTRAINT [PK_creditosAsignados]PRIMARY KEY CLUSTERED ([idCreditoAsignado] ASC),
    CONSTRAINT [FK_creditosAsignados_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_creditosAsignados_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_creditosAsignados_idCredito] ON [dbo].[creditosAsignados] ([idCredito])

GO

CREATE INDEX [IX_creditosAsignados_idGestor] ON [dbo].[creditosAsignados] ([idGestor])
