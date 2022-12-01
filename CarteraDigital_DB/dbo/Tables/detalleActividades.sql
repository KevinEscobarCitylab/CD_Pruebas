CREATE TABLE [dbo].[detalleActividades] (
    [idDetalle]   INT           IDENTITY (1, 1) NOT NULL,
    [idActividad] INT           NULL,
    [codigo]      VARCHAR (10)  NULL,
    [detalle]     VARCHAR (100) NULL,
    [parent]      INT           NULL,
    [contactado]  INT           NULL,
    [estado]      INT           NULL,
    [idDetalleM]  INT           NULL,
    CONSTRAINT [PK_detalleActividades] PRIMARY KEY CLUSTERED ([idDetalle] ASC),
    CONSTRAINT [FK_detalleActividades_idActividad] FOREIGN KEY ([idActividad]) REFERENCES [dbo].[actividades] ([idActividad]),
    CONSTRAINT [FK_detalleActividades_parent] FOREIGN KEY ([parent]) REFERENCES [dbo].[detalleActividades] ([idDetalle])
);


GO

CREATE INDEX [IX_detalleActividades_idActividad]ON [dbo].[detalleActividades] ([idActividad])

GO

CREATE INDEX [IX_detalleActividades_parent] ON [dbo].[detalleActividades] ([parent])

GO

CREATE INDEX [IX_detalleActividades_estado] ON [dbo].[detalleActividades] ([estado])

GO

CREATE INDEX [IX_detalleActividades_contactado] ON [dbo].[detalleActividades] ([contactado])
