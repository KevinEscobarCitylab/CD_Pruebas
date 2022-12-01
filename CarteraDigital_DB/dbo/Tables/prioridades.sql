CREATE TABLE [dbo].[prioridades] (
    [idPrioridad] INT          IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (50) NULL,
    [valor]       INT          NULL,
    CONSTRAINT [PK_prioridades] PRIMARY KEY CLUSTERED ([idPrioridad] ASC)
);

