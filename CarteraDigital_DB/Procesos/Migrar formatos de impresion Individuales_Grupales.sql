-- Reaccion migracion de formatos --
DECLARE @myJSON NVARCHAR(MAX);
DECLARE @ticketInvidual NVARCHAR(MAX);
DECLARE @ticketGrupo NVARCHAR(MAX);

SET @myJSON = (select app from parametros);
SET @ticketInvidual = (SELECT  JSON_VALUE(@myJSON, '$.printer.ticket'));
SET @ticketGrupo = (SELECT  JSON_VALUE(@myJSON, '$.printer.ticketG'));

UPDATE reacciones
SET formatPrint = @ticketInvidual, formatPrintG = @ticketGrupo
WHERE idRT = 6;