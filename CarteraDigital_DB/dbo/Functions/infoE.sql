    create function infoE(@idCredito int)returns table as return (
        select 
            alias = substring([value],0,patindex('%!%',[value])),
            valor = replace(substring([value],patindex('%!%',[value]),len([value])),'!','')
        from string_split(cast((select infoE from creditos where idCredito = @idCredito) as nvarchar(max)),';')
        where [value] not like 'alias%'
    )
