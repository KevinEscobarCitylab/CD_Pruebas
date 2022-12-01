CREATE TABLE [dbo].[segmentosCliente] (
    [idSegmento]  INT           IDENTITY (1, 1) NOT NULL,
    [idSegmentoT] INT           NULL,
    [segmento]    VARCHAR (150) NULL,
    CONSTRAINT [PK_segmentosCliente] PRIMARY KEY CLUSTERED ([idSegmento] ASC)
);

