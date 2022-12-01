CREATE TABLE [dbo].[historialCreditosAsignados] (
    [idCredito] INT  NULL,
    [idGestor]  INT  NULL,
    [fechaIn]   DATE NULL,
    [fechaOut]  DATE NULL,
    [revision]  INT  NULL,
    CONSTRAINT [FK_historialCreditosAsignados_idGestor] FOREIGN KEY ([idGestor]) REFERENCES [dbo].[gestores] ([idGestor]),
    CONSTRAINT [FK_historialCreditosAsignados_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito])
);


GO

CREATE INDEX [IX_historialCreditosAsignados_idGestor] ON [dbo].[historialCreditosAsignados] ([idGestor])

GO

CREATE INDEX [IX_historialCreditosAsignados_idCredito] ON [dbo].[historialCreditosAsignados] ([idCredito])
