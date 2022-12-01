CREATE TABLE [dbo].[estadosCredito] (
    [idEstado]  INT          IDENTITY (1, 1) NOT NULL,
    [idEstadoT] INT          NULL,
    [codigo]    VARCHAR (10) NULL,
    [estado]    VARCHAR (50) NULL,
    CONSTRAINT [PK_estadosCredito]PRIMARY KEY CLUSTERED ([idEstado] ASC)
);

GO

CREATE INDEX [IX_estadosCredito_estado] ON [dbo].[estadosCredito] ([estado])

