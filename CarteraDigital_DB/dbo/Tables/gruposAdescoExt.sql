CREATE TABLE [dbo].[gruposAdescoExt]
(
	[idGrupoAdesco] INT NOT NULL,
	CONSTRAINT [AK_gruposAdescoExt] UNIQUE([idGrupoAdesco]) ,
	CONSTRAINT [FK_gruposAdescoExt_idGrupoAdesco] FOREIGN KEY ([idGrupoAdesco]) REFERENCES [dbo].[gruposAdesco] ([idGrupoAdesco])
)

GO
 
CREATE INDEX [IX_gruposAdescoExt_idGrupoAdesco] ON [dbo].[gruposAdescoExt] ([idGrupoAdesco])
