CREATE TABLE [dbo].[actividadesEconomicas] (
    [idActividadE] INT           IDENTITY (1, 1) NOT NULL,
    [idActividadT] INT           NULL,
    [actividad]    VARCHAR (100) NULL,

    CONSTRAINT [PK_actividadesEconomicas] PRIMARY KEY CLUSTERED ([idActividadE] ASC)

    
);

