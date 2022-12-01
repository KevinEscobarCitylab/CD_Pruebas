CREATE TABLE [dbo].[reacciones] (
    [idReaccion]  INT  IDENTITY (1, 1) NOT NULL,
    [reaccion]    VARCHAR(MAX) NULL,
    [idDetalle]   INT  NULL,
    [idActividad] INT  NULL,
    [estado]      INT  NULL,
    [idRT]        INT  NULL,
    [idReaccionM] INT  NULL,
    [formatPrint] varchar(MAX)  NULL,
    [formatPrintG] varchar(MAX)  NULL,
    CONSTRAINT [PK_reacciones] PRIMARY KEY CLUSTERED ([idReaccion] ASC),
    CONSTRAINT [FK_reacciones_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_reacciones_idDetalle] FOREIGN KEY ([idDetalle]) REFERENCES [dbo].[detalleActividades] ([idDetalle]),
    CONSTRAINT [FK_reacciones_idRT] FOREIGN KEY ([idRT]) REFERENCES [dbo].[reaccionTipo] ([idRT])
);


GO

CREATE INDEX [IX_reacciones_idActividad] ON [dbo].[reacciones] ([idActividad])

GO

CREATE INDEX [IX_reacciones_idDetalle] ON [dbo].[reacciones] ([idDetalle])

GO

CREATE INDEX [IX_reacciones_idRT] ON [dbo].[reacciones] ([idRT])

GO

CREATE INDEX [IX_reacciones_estado] ON [dbo].[reacciones] ([estado])
