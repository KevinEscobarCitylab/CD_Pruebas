CREATE TABLE [dbo].[etapasGestionProspecto] (
    [idEtapaG]     INT           IDENTITY (1, 1) NOT NULL,
    [etapa]        VARCHAR (50)  NULL,
    [nivel]        INT           NULL,
    [d1]           VARCHAR (MAX) NULL,
    [notificacion] INT           NULL,
    [asignar]      INT           NULL,
    [_index]       INT           NULL,
    CONSTRAINT [PK_etapasGestionProspecto] PRIMARY KEY CLUSTERED ([idEtapaG] ASC)
);

