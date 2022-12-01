create function [dbo].[completedForms](@idProspecto int) returns varchar(max) as
begin
    return (select dbo.fStuff( (select concat(',',idFormulario) from openjson((select respuestas from prospectos where idProspecto = @idProspecto))with(idFormulario int,idProspecto int) order by idFormulario for xml path(''))))
end
