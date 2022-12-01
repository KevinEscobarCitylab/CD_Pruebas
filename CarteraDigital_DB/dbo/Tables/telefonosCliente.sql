CREATE TABLE [dbo].[telefonosCliente] (
    [idTelefono] INT          IDENTITY (1, 1) NOT NULL,
    [idCliente]  INT          NULL,
    [telefono]   VARCHAR (25) NULL,
    [fecha]      DATETIME     NULL,
    CONSTRAINT [PK_telefonosCliente] PRIMARY KEY CLUSTERED ([idTelefono] ASC),
    CONSTRAINT [FK_telefonosCliente_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente])
);


GO

CREATE INDEX [IX_telefonosCliente_idCliente] ON [dbo].[telefonosCliente] ([idCliente])
