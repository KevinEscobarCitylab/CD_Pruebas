CREATE TABLE [dbo].[menu] (
    [idMenu]     INT           IDENTITY (1, 1) NOT NULL,
    [menu]       VARCHAR (50)  NULL,
    [url]        VARCHAR (MAX) NULL,
    [parent]     INT           NULL,
    [icon]       VARCHAR (50)  NULL,
    [index_menu] INT           NULL,
    [version]    INT           NULL,
    [codigo]     VARCHAR (15)  NULL,
    CONSTRAINT [PK_menu] PRIMARY KEY CLUSTERED ([idMenu] ASC)
);


GO
CREATE TRIGGER [dbo].[gruposMenu_t]   ON [dbo].[menu] AFTER INSERT  AS
begin
	insert grupos_menu
	(idMenu,idGrupo,estado) 
	select 
		s.idMenu,
		1,
		1
	from grupos_menu t
	right outer join inserted s on s.idMenu = t.idMenu
	where t.idGrupoMenu is Null
end
