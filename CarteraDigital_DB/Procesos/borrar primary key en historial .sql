
declare @pkv nvarchar(max)
SELECT @pkv=name  
FROM sys.key_constraints  
WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'historialCreditosAsignados';  
IF @pkv is not null 
begin
declare @query nvarchar(max)='ALTER TABLE historialCreditosAsignados DROP CONSTRAINT '+@pkv
EXECUTE sp_executesql @query;

end

if(col_length('historialCreditosAsignados','idHistorialCreditoA')is not null)alter table historialCreditosAsignados drop column idHistorialCreditoA



declare @pkvg nvarchar(max)
SELECT @pkvg=name  
FROM sys.key_constraints  
WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'historialGestores';  
IF @pkvg is not null 
begin
declare @query nvarchar(max)='ALTER TABLE historialGestores DROP CONSTRAINT '+@pkvg
EXECUTE sp_executesql @query;

end

if(col_length('historialGestores','idHistorialGestor')is not null)alter table historialGestores drop column idHistorialGestor



declare @pkvc nvarchar(max)
SELECT @pkvc=name  
FROM sys.key_constraints  
WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'historialCredito';  
IF @pkvc is not null 
begin
declare @query nvarchar(max)='ALTER TABLE historialCredito DROP CONSTRAINT '+@pkvc
EXECUTE sp_executesql @query;

end

if(col_length('historialCredito','idHistorialC')is not null)alter table historialCredito drop column idHistorialC