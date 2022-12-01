CREATE TABLE [dbo].[estadosCliente] (
    [idEstadoCliente] INT          IDENTITY (1, 1) NOT NULL,
    [idEstadoT]       INT          NULL,
    [estado]          VARCHAR (50) NULL,
    CONSTRAINT [PK_estadosCliente] PRIMARY KEY CLUSTERED ([idEstadoCliente] ASC)
);


GO

CREATE INDEX [IX_estadosCliente_estado] ON [dbo].[estadosCliente] ([estado])
