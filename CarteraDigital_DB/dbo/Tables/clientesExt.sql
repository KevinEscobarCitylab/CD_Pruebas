CREATE TABLE [dbo].[clientesExt]
(
	[idCliente] INT NOT NULL,
	CONSTRAINT [AK_clientesExt] UNIQUE([idCliente]) ,
	CONSTRAINT [FK_clientesExt_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente])
)

GO

CREATE INDEX [IX_clientesExt_idCliente] ON [dbo].[clientesExt] ([idCliente])
