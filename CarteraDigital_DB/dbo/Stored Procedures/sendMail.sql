	create procedure [dbo].[sendMail](@data varchar(max))as
    begin
        update parametros set tmp = @data
        declare @bc varchar(max),
            @email varchar(max),
            @message varchar(max),
            @etapa int,
            @idGestor int,
            @idProspecto int,
            @rsp varchar(max)
    
        select @etapa = etapa, @idGestor = idGestor, @idProspecto = idProspecto from openjson(@data)with(etapa int,idGestor int,idProspecto int)
    
        select @bc = bc from parametros where idParametro = 1
        select @email = email from openjson(@bc)with(email nvarchar(max) '$.email.colocacion'  as json)
        select @message = message from openjson(@email)with(idEtapa int,gestor bit,cliente bit,message varchar(max))where idEtapa = 1
    
        declare @cliente varchar(max), @gestor varchar(max),@etapa2 varchar(max), @sessionid varchar(max)
    
        select @cliente = p.encabezado, @gestor = g.nombre, @etapa2 = e.etapa 
        from prospectos p
        inner join gestores g on g.idGestor = p.idGestor 
        inner join etapasGestionProspecto e on e.idEtapaG = @etapa
        where idProspecto = @idProspecto
        
        select @message = replace(replace(replace(dbo.decodeb64(@message),'${p.cliente}',@cliente),'${p.idNombreGestor}',@gestor),'${p.accion.etapa}',@etapa2)	
    
        select top 1 @sessionid = su.token from sesionesUsuario su
        inner join usuarios u on u.idUsuario = su.idUsuario
        where u.idGestor = @idGestor order by su.idToken desc
        
        declare @json nvarchar(max) = (
            select 		
                'sendMailColocacion' as [action],
                @idGestor as idGestor,
                @sessionid as sessionid,
                @idProspecto as idProspecto,
                1 as idEtapa,
                @message as Message,
                'Notificacion de Solicitud' as Subject
            for json path, without_array_wrapper
        )
        
        update parametros set tmp = @json
        declare @url nvarchar(max) = 'http://192.168.3.42:82/AGC/AGC.ServiceApp.svc/consultaTerceros'
    
        select @rsp = dbo.wsp(@url,@json)   
    end
