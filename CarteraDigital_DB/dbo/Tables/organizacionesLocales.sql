CREATE TABLE [dbo].[organizacionesLocales] (
    [idOrganizacion]  INT        IDENTITY (1, 1) NOT NULL,
    [idOrganizacionT] NCHAR (15) NULL,
    [nombre]          VARCHAR(MAX)       NULL,
    [totalMora]       INT        NULL,
    [totalDesembolso] INT        NULL,
    [totalVenceHoy]   INT        NULL,
    [totalRenovacion] INT        NULL,
    [totalPrioridad]  INT        NULL,
    CONSTRAINT [PK_organizacionesLocales] PRIMARY KEY CLUSTERED ([idOrganizacion] ASC)
);