
---borra rutas agendas repetidas
	if(object_id('ra')is not null) drop table ra
	if(col_length('rutasAgendadas','valid')is null) alter table rutasAgendadas add valid int;
	go
	with ds as
	(
	  select
	      row_number() over(partition by idCredito,idGestor,fecha order by idCredito,idGestor,fecha ) as #,
	      idCredito,idGestor,fecha,valid
	  FROM rutasAgendadas
	)

	update ds set valid =  1 where #=1

	select *into ra from rutasAgendadas where valid = 1
	truncate table rutasAgendadas

	insert rutasAgendadas select 
		fecha,idCredito,idClienteCampania,idProspecto,idActividad,idGrupoAdesco,idGestor,casa,recomendacion,acumulado,agendado,estado,valid 
	from ra