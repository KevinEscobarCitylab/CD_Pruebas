create function [dbo].[fEncabezados]()returns varchar(max) as
begin
    return (
        select
            et.idET,
            et.alias,
            ee.idPregunta,
            idEncuesta,
            valid = iif(i.column_name is null,0,1)
        from encabezadoEncuesta ee
        inner join encabezadoTipo et on et.idET = ee.idET
        left join (select column_name from ..information_schema.columns where TABLE_NAME = 'prospectos') i on i.column_name = et.alias and ee.estado = 1
        order by ee._index for json path
    )
end
