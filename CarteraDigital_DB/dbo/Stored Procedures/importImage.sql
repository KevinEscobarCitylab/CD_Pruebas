create   procedure dbo.importImage (@picName nvarchar (100), @imageFolderPath nvarchar (1000), @filename nvarchar (1000))
as
begin
   declare @Path2OutFile nvarchar (2000);
   declare @tsql nvarchar (2000);
   set nocount on
   set @Path2OutFile = concat (@imageFolderPath,'\', @filename)
   set @tsql = 'insert into pictures (pictureName, picFileName, pictureData) ' +
               ' SELECT ' + '''' + @picName + '''' + ',' + '''' + @filename + '''' + ', * ' + 
               'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
   exec (@tsql)
   set nocount off
end
