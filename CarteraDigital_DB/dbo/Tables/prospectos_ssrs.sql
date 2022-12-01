CREATE TABLE [dbo].[prospectos_ssrs] (
    [idProspectoSSRS] INT            IDENTITY (1, 1) NOT NULL,
    [idProspecto]     INT            NULL,
    [idFormulario]    INT            NULL,
    [data]            NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_prospectos_ssrs] PRIMARY KEY CLUSTERED ([idProspectoSSRS] ASC)
);

