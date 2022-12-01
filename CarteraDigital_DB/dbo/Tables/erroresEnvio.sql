CREATE TABLE [dbo].[erroresEnvio] (
    [idError]   INT          IDENTITY (1, 1) NOT NULL,
    [idGestor]  INT          NULL,
    [sessionid] VARCHAR (50) NULL,
    [data]      NVARCHAR(MAX)         NULL,
    CONSTRAINT [PK_erroresEnvio] PRIMARY KEY CLUSTERED ([idError] ASC),
    CONSTRAINT [FK_erroresEnvio_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_erroresEnvio_idGestor] ON [dbo].[erroresEnvio] ([idGestor])
