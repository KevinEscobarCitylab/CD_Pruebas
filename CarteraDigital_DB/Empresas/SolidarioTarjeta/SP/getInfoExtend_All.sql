CREATE PROCEDURE [dbo].[getInfoExtend_All] as
begin
	if(OBJECT_ID('tempdb..#dependiente') is not null)drop table #dependiente
	select p.nombreC nombre,getdate() as fecNac, p.nDoc as cedula,p.telefono as tel, p.direccion email,p.lineaC as codEstablecimiento,p.idGestor
	into #dependiente from prospectos p
	inner join creditosAsignados ca on ca.idCreditoT = p.lineaC and ca.idGestor = p.idGestor
    where p.idEncuesta = 3
		
	update t set 
		t.tabla_ext = concat('[',
		'{"name":"Dependientes","tipo":2,"header":[{"width": 75,"name": "Nombre","colorTH": "#ffffff","colorTC": "#ed9119"},{"width": 75,"name": "Fecha Nac","colorTH": "#ffffff","colorTC": "#ed9119"},{"width": 75,"name": "No cedula","colorTH": "#ffffff","colorTC": "#ed9119"},{"width": 75,"name": "Tel","colorTH": "#ffffff","colorTC": "#ed9119"},{"width": 75,"name": "email","colorTH": "#ffffff","colorTC": "#ed9119"}],"rows":[',
			(select dbo.fStuff((select  CONCAT(',{"columns":[',
			'{"value":"',ac.nombre,'"},',
			'{"value":"',cast(ac.fecNac as date),'"},',
			'{"value":"',ac.cedula,'"},',
			'{"value":"',ac.tel,'"},',
			'{"value":"',ac.email,'"}',
			']}') 
			from #dependiente ac where codEstablecimiento = t.idCreditoT FOR XML PATH(''))))
		,']}',
	']')
	from creditos t
	where t.idEstado = 1 
end
