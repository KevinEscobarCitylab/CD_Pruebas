CREATE TABLE [dbo].[GEO] (
    [idGPSGEO]                    INT           IDENTITY (1, 1) NOT NULL,
    [idCliente]                   INT           NULL,
    [idProspecto]                 INT           NULL,
    [idFiador]                    INT           NULL,
    [idGrupoAdesco]               INT           NULL,
    [latitud]                     VARCHAR (50)  NULL,
    [longitud]                    VARCHAR (50)  NULL,
    [casa]                        INT           NULL,
    [address]                     VARCHAR (200) NULL,
    [street_number]               VARCHAR (50)  NULL,
    [route]                       VARCHAR (100) NULL,
    [locality]                    VARCHAR (100) NULL,
    [administrative_area_level_2] VARCHAR (100) NULL,
    [administrative_area_level_1] VARCHAR (100) NULL,
    [country]                     VARCHAR (50)  NULL,
    [postal_code]                 VARCHAR (50)  NULL,
    [fechaGEO]                    DATETIME      NULL,
    [idGestor]                    INT           NULL,
    CONSTRAINT [PK_GEO] PRIMARY KEY CLUSTERED ([idGPSGEO] ASC),
    CONSTRAINT [FK_GEO_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]), 
    CONSTRAINT [FK_GEO_idCliente] FOREIGN KEY ([idCliente]) REFERENCES [dbo].[Clientes]([idCliente]),
    CONSTRAINT [FK_GEO_idProspecto] FOREIGN KEY ([idProspecto]) REFERENCES [dbo].[prospectos]([idProspecto]),
    CONSTRAINT [FK_GEO_idFiador] FOREIGN KEY ([idFiador]) REFERENCES [dbo].[fiadores]([idFiador]),
    CONSTRAINT [FK_GEO_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposadesco]([idGrupoAdesco]) 
);


GO

CREATE INDEX [IX_GEO_idCliente] ON [dbo].[GEO] ([idCliente])

GO

CREATE INDEX [IX_GEO_idGestor] ON [dbo].[GEO] ([idGestor])

GO

CREATE INDEX [IX_GEO_idProspecto] ON [dbo].[GEO] ([idProspecto])

GO

CREATE INDEX [IX_GEO_idFiador] ON [dbo].[GEO] ([idFiador])

GO

CREATE INDEX [IX_GEO_idGrupoAdesco] ON [dbo].[GEO] ([idGrupoAdesco])

GO

CREATE INDEX [IX_GEO_fechaGEO] ON [dbo].[GEO] ([fechaGEO])
