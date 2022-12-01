CREATE function [dbo].[solicitudR1](@idProspecto int)returns @returntable table
(
    [#] [bigint] NULL,
	[idFormulario] [int] NULL,
	[formulario] [varchar](50) NULL,
	[idTipo] [int] NULL,
	[idFormato] [int] NULL,
	[idPregunta] [int] NULL,
	[pregunta] [varchar](max) NULL,
	[respuesta] [varchar](max) NULL,
	[observacion] [varchar](max) NULL,
	[idRespuesta] [int] NULL,
	[IDT] [varchar](max) NULL,
	[idRespuestaT] [varchar](max) NULL,
	[idRM] [varchar](max) NULL,
	[indexF] [int] NULL,
	[indexP] [bigint] NULL,
	[rf] [varchar](50) NULL,
	[rp] [varchar](50) NULL,
	[g] [int] NULL,
	[gp] [int] NULL,
	[p] [int] NULL,
	[lp] [int] NULL,
	[#f] [bigint] NULL
) as
begin
	insert @returntable
    select
        # = ROW_NUMBER() over(order by (select 1)),
        f.idFormulario,
        formulario = f.nombre,
        p.idTipo,
        p.idFormato,
        p.idPregunta,
        p.pregunta,
        respuesta = coalesce(s.observacion, s.idRespuestaT, s.idRM),
        observacion = s.observacion2,
        s.idRespuesta,
        s.IDT,
        s.idRespuestaT,
        s.idRM,
        s.indexF,
        s.indexP,
        rf = l.alias,
        rp = lp.alias,
        s.g,
        s.gp,
        s.p,
        s.lp,
        #f = dense_rank() over(partition by s.idFormulario order by s.indexF)
    from(
        select 
            *,
            indexP = row_number() over(partition by indexF order by (select 1))-1
        from openjson((
            select concat('[',dbo.fStuff((select 
                concat(',',(
                    select 
                        idFormulario,
                        fechaCreacion,
                        indexF,						
                        *
                    from openjson(respuestas)with(
                        idPregunta int, 
                        observacion varchar(max),
                        observacion2 varchar(max),
                        idRespuesta int, 
                        idRespuestaT varchar(max), 
                        IDT varchar(max),
                        idRM varchar(max),
                        g int,
                        gp int,
                        p int,
                        lp int,
                        rf varchar(50)
                    )
                    for json path,without_array_wrapper
                ))
            from (select
					*,
					indexF = row_number() over(order by (select 1))-1
				from openjson((select top 1 iif(substring(respuestas,1,1)='{',respuestas,concat('{"totalCampos":-1,"formularios":',respuestas,'}')) from prospectos with(nolock) where idProspecto = @idProspecto),'$.formularios')with(
					idFormulario int, 
					fechaCreacion varchar(max),
					totalCampos int, 
					respuestas nvarchar(max) as json
				)) ds for xml path(''))),']')
        ))with(
            idPregunta int, 
            idFormulario int, 
            indexF int,
            idRespuesta int, 
            idRespuestaT varchar(max), 
            IDT varchar(max), 
            observacion varchar(max),
            observacion2 varchar(max),
            idRM varchar(max),
            g int,
            gp int,
            p int,
            lp int,
            rf varchar(50)
        )
    )s
    left join preguntas p on p.idPregunta = s.idPregunta
    left join preguntas l on l.idPregunta = s.p
    left join preguntas lp on lp.idPregunta = s.lp
    left join formularios f on f.idFormulario = p.idFormulario

    return
end
