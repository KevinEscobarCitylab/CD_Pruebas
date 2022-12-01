CREATE   function [dbo].[fConf]()returns XML
begin
	return CAST((
			select *from(
			select 
				(select *from reaccionTipo for json path ) as reaccionTipo,
				(select *from accionesEtapa for json path )as accionesEtapa,
				(select *from actividades where estado = 1 for json path )as actividades,
				(select *from coloresIndicador for json path)as coloresIndicador,
				(select *from formatos for json path) as formatos,
				(select *from encabezadoTipo for json path) as encabezadoTipo,
				(select *from etapasGestionProspecto for json path) as etapasGestionProspecto,
				(select *from menuMovil where estado = 1 for json path)as menuMovil,
				(select *from opcionesImprimibles for json path)as opcionesImprimibles,
				(select *from tiposEncuesta for json path)as tiposEncuesta,
				(select *from tiposPregunta for json path) as tiposPregunta
		)dt for json path
	)as XML)
end