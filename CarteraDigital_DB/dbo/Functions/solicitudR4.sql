CREATE FUNCTION [dbo].[solicitudR4](@idProspecto int)returns @returntable table
(
	[idFormulario] [int] NOT NULL,
	[formulario] [varchar](50) NULL,
	[indexF] [bigint] NULL,
	[fechaCreacion] [datetime] NULL,
	[indexP] [bigint] NULL,
	[idPregunta] [int] NOT NULL,
	[pregunta] [varchar](max) NULL,
	[respuesta] [varchar](max) NULL,
	[path] [varchar](64) NOT NULL,
	[idRespuesta] [int] NULL,
	[idRespuestaT] [varchar](50) NULL,
	[observacion] [nvarchar](max) NULL,
	[observacion2] [nvarchar](max) NULL,
	[api] [nvarchar](max) NULL,
	[idRM] [varchar](max) NULL,
	[g] [varchar](max) NULL,
	[p] [varchar](max) NULL,
	[d1] [varchar](max) NOT NULL,
	[idRS] [varchar](max) NULL,
	[IDT] [nvarchar](max) NULL,
	[readOnly] [int] NULL
) as
begin
	insert @returntable
	select
		ds.idFormulario,
		ds.formulario,
		f.indexF,
		f.fechaCreacion,
		indexP = row_number() over(partition by f.indexF order by (select 1))-1,
		ds.idPregunta,
		ds.pregunta,
		respuesta = cast(ds.respuesta as varchar(max)),
		path = concat('$[',f.indexF,'].respuestas[',row_number() over(partition by f.indexF order by (select 1))-1,']'),
		ds.idRespuesta,
		ds.idRespuestaT,
		ds.observacion,
		ds.observacion2,
		ds.api,
		ds.idRM,
		ds.g,
		ds.p,
		ds.d1,
		ds.idRS,
		ds.IDT,
		ds.[readOnly]
	from (
		select
			f.idFormulario,
			f.nombre as formulario,
			p.idPregunta,
			p.pregunta,
			respuesta = coalesce(r.respuesta,s.observacion),
			s.idRespuesta,
			s.idRespuestaT,
			observacion = iif(ft.tipo = 'list',concat('[',s.observacion,']'),s.observacion),
			s.observacion2,
			s.api,
			s.idRM,
			s.g,
			s.p,
			d1 = concat('[', s.d1, ']'),
			s.IDT,
			s.idRS,
			s.[readOnly]
		from openjson(concat('[',dbo.fStuff((select concat(',',replace(replace(respuestas,'[',''),']','')) from openjson(((select respuestas from prospectos where idProspecto = @idProspecto)))with(respuestas nvarchar(max) as json) where respuestas is not null for xml path(''))),']'))with(idPregunta int, idRespuesta int, idRespuestaT varchar(50), observacion nvarchar(max), observacion2 nvarchar(max), api nvarchar(max),idRM varchar(max),g varchar(max),p varchar(max),d1 varchar(max),idRS varchar(max),IDT nvarchar(max), [readOnly] int) s
		inner join preguntas p on p.idPregunta = s.idPregunta
		inner join formatos ft on ft.idFormato = p.idFormato
		left join respuestas r on r.idRespuesta = s.idRespuesta
		inner join formularios f on f.idFormulario = p.idFormulario 
		where s.g != 0
	)ds
	inner join (select indexF = row_number() over(order by (select 1))-1,idFormulario,fechaCreacion from openjson((select respuestas from prospectos where idProspecto = @idProspecto))with(idFormulario int, fechaCreacion datetime)) f on f.idFormulario = ds.idFormulario
	
	RETURN
end
