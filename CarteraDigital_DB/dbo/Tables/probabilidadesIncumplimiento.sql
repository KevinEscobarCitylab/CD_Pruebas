CREATE TABLE [dbo].[probabilidadesIncumplimiento] (
    [idProbabilidad]  INT          IDENTITY (1, 1) NOT NULL,
    [idProbabilidadT] INT          NULL,
    [codigo]          VARCHAR (25) NULL,
    [valor]           INT          NULL,
    CONSTRAINT [PK_probabilidadesIncumplimiento] PRIMARY KEY CLUSTERED ([idProbabilidad] ASC)
);

