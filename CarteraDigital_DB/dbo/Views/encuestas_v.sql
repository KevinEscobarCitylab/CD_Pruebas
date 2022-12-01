CREATE view [dbo].[encuestas_v] as
(
	select
		e.idEncuesta,
		e.nombre,
		e.objetivo,
		e.idTipoEncuesta,
		format(e.fechaInicio,'dddd dd MMM yyyy','es-SV')as fecha1,
		format(e.fechaLimite,'dddd dd MMM yyyy','es-SV')as fecha2,
		format(e.fechaInicio,'yyyy-MM-dd','en-US')as f1,
		format(e.fechaLimite,'yyyy-MM-dd','en-US')as f2,
		DATEDIFF(day,GETDATE(),e.fechaInicio)as dias,
		e.privada,
		e.idEmpresa,
		e.etapa,
		e.imagenes,
		e.idEncabezado,
		e.idEdad,
		e.idExtra,
		te.codigo,
		isNull((select 
			pr.idFormulario,
			fr.nombre
			from preguntas pr
			inner join formularios fr on fr.idFormulario = pr.idFormulario
			where pr.idEncuesta = e.idEncuesta
			group by pr.idFormulario,fr.nombre for JSON PATH	),'[]'
		)as formularios,
		(select 
			p.*,
			null as link,
			_fr._index as indexF,
			(select *from respuestas r where r.idPregunta = p.idPregunta and r.estado = 1 order by _index for JSON path)as respuestas,
			(select
				dp.parent as idPregunta,
				dp.valorR,
				dp.idOperador,
				dp.idUnidad,
				dp.parentR
				from dependenciasPregunta dp where dp.idPregunta = p.idPregunta and estado = 1 for JSON path
			) as dependencias
		from preguntas p 
		left join formularios _fr on _fr.idFormulario = p.idFormulario
		where p.idEncuesta = e.idEncuesta and p.estado = 1 order by _fr._index,p._index for JSON path
		)as preguntas
	from encuestas e
	inner join tiposEncuesta te on te.idTipoEncuesta = e.idTipoEncuesta
	where e.estado = 1
)


