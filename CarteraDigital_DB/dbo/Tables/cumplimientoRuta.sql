CREATE TABLE [dbo].[cumplimientoRuta] (
    [idGestor] INT        NULL,
    [meta]     INT        NULL,
    [valor]    FLOAT (53) NULL,
    [fecha]    DATE       NULL,
    CONSTRAINT [FK_cumplimientoRuta_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_cumplimientoRuta_idGestor] ON [dbo].[cumplimientoRuta] ([idGestor])
