CREATE TABLE [dbo].[historialGestores] (
    [idGestor]     INT  NULL,
    [fecha]        DATE NULL,
    [idGrupo]      INT  NULL,
    [idAgencia]    INT  NULL,
    [idSupervisor] INT  NULL,
    CONSTRAINT [FK_historialGestores_idAgencia] FOREIGN KEY ([idAgencia]) REFERENCES [dbo].[agencias] ([idAgencia]),
    CONSTRAINT [FK_historialGestores_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_historialGestores_idGrupo] FOREIGN KEY ([idGrupo]) REFERENCES [dbo].[grupos] ([idGrupo]),
    CONSTRAINT [FK_historialGestores_idSupervisor] FOREIGN KEY ([idSupervisor]) REFERENCES [dbo].[gestores] ([idGestor])
);


GO

CREATE INDEX [IX_historialGestores_idAgencia] ON [dbo].[historialGestores] ([idAgencia])

GO

CREATE INDEX [IX_historialGestores_idGestor] ON [dbo].[historialGestores] ([idGestor])

GO

CREATE INDEX [IX_historialGestores_idGrupo] ON [dbo].[historialGestores] ([idGrupo])

GO

CREATE INDEX [IX_historialGestores_idSupervisor] ON [dbo].[historialGestores] ([idSupervisor])

