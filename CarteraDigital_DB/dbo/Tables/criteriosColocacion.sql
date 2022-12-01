CREATE TABLE [dbo].[criteriosColocacion]
(
	[idCriterio]		INT				IDENTITY(1,1) NOT NULL ,
	[descripcion]		VARCHAR (150)	NULL,
	[condicion]			VARCHAR (max)	NULL,
	[idGrupo]			INT				NULL,
	[estado]			INT				NULL,
    CONSTRAINT [PK_criteriosColocacion] PRIMARY KEY CLUSTERED ([idCriterio] ASC)
)


GO

CREATE INDEX [IX_criteriosColocacion_estado] ON [dbo].[criteriosColocacion] ([estado])
