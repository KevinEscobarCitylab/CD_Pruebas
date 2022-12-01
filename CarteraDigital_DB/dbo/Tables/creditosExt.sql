CREATE TABLE [dbo].[creditosExt]
(
	[idCredito] INT NOT NULL,
	CONSTRAINT [AK_creditosExt] UNIQUE([idCredito]) ,
	CONSTRAINT [FK_creditosExt_idCredito] FOREIGN KEY ([idCredito]) REFERENCES [dbo].[creditos] ([idCredito])
)

GO

CREATE INDEX [IX_creditosExt_idCredito] ON [dbo].[creditosExt] ([idCredito])
