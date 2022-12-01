CREATE TABLE [dbo].[informacionCampanias] (
    [idInformacion]     INT           IDENTITY (1, 1) NOT NULL,
    [idCampania]        INT           NULL,
    [idClienteCampania] INT           NULL,
    [campo]             VARCHAR (100) NULL,
    [valor]             VARCHAR(MAX)          NULL,
    CONSTRAINT [PK_informacionCampanias] PRIMARY KEY CLUSTERED ([idInformacion] ASC),
    CONSTRAINT [FK_informacionCampanias_idCampania] FOREIGN KEY ([idCampania]) REFERENCES [dbo].[campanias] ([idCampania]),
    CONSTRAINT [FK_informacionCampanias_idClienteCampania] FOREIGN KEY ([idClienteCampania]) REFERENCES [dbo].[clientesCampania] ([idClienteCampania])
);


GO

CREATE INDEX [IX_informacionCampanias_idCampania] ON [dbo].[informacionCampanias] ([idCampania])

GO

CREATE INDEX [IX_informacionCampanias_idClienteCampania] ON [dbo].[informacionCampanias] ([idClienteCampania])
