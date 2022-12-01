CREATE TABLE [dbo].[restriccionFecha] (
    [idRF]    INT          IDENTITY (1, 1) NOT NULL,
    [formato] VARCHAR (50) NULL,
    CONSTRAINT [PK_restriccionFecha] PRIMARY KEY CLUSTERED ([idRF] ASC)
);

