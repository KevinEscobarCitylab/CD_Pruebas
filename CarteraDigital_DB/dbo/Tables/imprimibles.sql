CREATE TABLE [dbo].[imprimibles] (
    [idImprimible] INT          IDENTITY (1, 1) NOT NULL,
    [idCategoria]  INT          NULL,
    [url]          NVARCHAR(MAX)         NULL,
    [_class]       VARCHAR (50) NULL,
    [nombre]       VARCHAR (50) NULL,
    [d1]           NVARCHAR(MAX)         NULL,
    [estado]       INT          NULL,
    [idEncuesta]   INT          NULL,
    CONSTRAINT [PK_imprimibles] PRIMARY KEY CLUSTERED ([idImprimible] ASC),
    CONSTRAINT [FK_imprimibles_idCategoria] FOREIGN KEY ([idCategoria]) REFERENCES [dbo].[categoriasImprimibles] ([idCategoria]),
    CONSTRAINT [FK_imprimibles_idEncuesta] FOREIGN KEY ([idEncuesta]) REFERENCES [dbo].[encuestas] ([idEncuesta])
);


GO
create TRIGGER [dbo].[imprimiblesGrupo_t] ON imprimibles AFTER INSERT AS
begin
	insert into imprimiblesGrupo
	(idImprimible,idGrupo,estado) 
	select 
		s.idImprimible,
		1,
		1
	from imprimiblesGrupo t
	right outer join inserted s on s.idImprimible = t.idImprimibleG
	where t.idImprimibleG is Null
end

GO
create trigger [dbo].[imprimibles_t] on imprimibles after insert as
begin
	insert opcionesImprimiblesGrupo
	(idOpcion,idGrupo,idImprimible,estado)
	select 
		4,
		1,
		s.idImprimible,
		1
	from opcionesImprimiblesGrupo t
	right outer join inserted s on s.idImprimible = t.idImprimible
	where t.idImprimible is null 
end

GO

CREATE INDEX [IX_imprimibles_idCategoria] ON [dbo].[imprimibles] ([idCategoria])

GO

CREATE INDEX [IX_imprimibles_idEncuesta] ON [dbo].[imprimibles] ([idEncuesta])

GO

CREATE INDEX [IX_imprimibles_estado] ON [dbo].[imprimibles] ([estado])
