CREATE TABLE [dbo].[campanias] (
    [idCampania]  INT           IDENTITY (1, 1) NOT NULL,
    [titulo]      VARCHAR (250) NULL,
    [proposito]   VARCHAR(MAX)          NULL,
    [fechaInicio] DATE          NULL,
    [fechaFin]    DATE          NULL,
    [estado]      INT           NULL,
    [rsp]         VARCHAR (MAX) NULL,
    [fecha]       DATETIME      NULL,
    CONSTRAINT [PK_campanias] PRIMARY KEY CLUSTERED ([idCampania] ASC)
);


GO

CREATE INDEX [IX_campanias_estado] ON [dbo].[campanias] ([estado])
