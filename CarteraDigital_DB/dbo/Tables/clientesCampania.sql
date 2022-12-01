CREATE TABLE [dbo].[clientesCampania] (
    [idClienteCampania] INT            IDENTITY (1, 1) NOT NULL,
    [idCampania]        INT            NULL,
    [idCredito]         INT            NULL,
    [idCliente]         INT            NULL,
    [idClienteP]        INT            NULL,
    [idGestor]          INT            NULL,
    [estado]            INT            NULL,
    [gestionado]        INT            NULL,
    [DUG]               INT            NULL,
    [UG]                VARCHAR (25)   NULL,
    [ID]                INT            NULL,
    [data]              NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_clientesCampania] PRIMARY KEY CLUSTERED ([idClienteCampania] ASC),
    CONSTRAINT [FK_clientesCampania_idCampania] FOREIGN KEY ([idCampania]) REFERENCES [dbo].[campanias] ([idCampania]),
    CONSTRAINT [FK_clientesCampania_idClienteP] FOREIGN KEY ([idClienteP]) REFERENCES [dbo].[clientesPotenciales] ([idClienteP]),
    CONSTRAINT [FK_clientesCampania_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[clientes] ([idCliente]),
    CONSTRAINT [FK_clientesCampania_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito]),
    CONSTRAINT [FK_clientesCampania_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_clientesCampania_idCampania] ON [dbo].[clientesCampania] ([idCampania])

GO

CREATE INDEX [IX_clientesCampania_idClienteP] ON [dbo].[clientesCampania] ([idClienteP])

GO

CREATE INDEX [IX_clientesCampania_idCliente] ON [dbo].[clientesCampania] ([idCliente])

GO

CREATE INDEX [IX_clientesCampania_idCredito] ON [dbo].[clientesCampania] ([idCredito])

GO

CREATE INDEX [IX_clientesCampania_idGestor] ON [dbo].[clientesCampania] ([idGestor])

GO

CREATE INDEX [IX_clientesCampania_estado] ON [dbo].[clientesCampania] ([estado])

GO

CREATE INDEX [IX_clientesCampania_gestionado] ON [dbo].[clientesCampania] ([gestionado])
