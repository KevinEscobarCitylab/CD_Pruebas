CREATE TABLE [dbo].[coloresIndicador] (
    [idColor]     INT          IDENTITY (1, 1) NOT NULL,
    [color]       VARCHAR (10) NULL,
    [descripcion] VARCHAR (25) NULL,
    CONSTRAINT [PK_coloresIndicador] PRIMARY KEY CLUSTERED ([idColor] ASC)
);

