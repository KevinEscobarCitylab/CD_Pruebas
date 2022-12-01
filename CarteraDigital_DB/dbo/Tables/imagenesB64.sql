CREATE TABLE [dbo].[imagenesB64] (
    [idImagen]  INT          IDENTITY (1, 1) NOT NULL,
    [idGestor]  INT          NULL,
    [sessionid] VARCHAR (50) NULL,
    [px]        INT          NULL,
    [longitud]  INT          NULL,
    [b64]       NVARCHAR(50)         NULL,
    CONSTRAINT [PK_imagenesB64]PRIMARY KEY CLUSTERED ([idImagen] ASC),
    CONSTRAINT [FK_imagenesB64_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_imagenesB64_idGestor] ON [dbo].[imagenesB64] ([idGestor])
