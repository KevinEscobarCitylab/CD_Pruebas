--borrar historial de creditos asignados repetidos
	if(object_id('hca')is not null) drop table hca
	if(col_length('historialCreditosAsignados','valid')is null) alter table historialCreditosAsignados add valid int;
	go
	--drop table hca

	with ds as
	(
	  select
	      row_number() over(partition by idCredito,idGestor,fechaIn,fechaOut order by idCredito,idGestor,fechaIn,fechaOut ) as #,
	      idCredito,idGestor,fechaIn,fechaOut,valid
	  FROM historialCreditosAsignados
	)

	update ds set valid =  1 where #=1

	select *into hca from historialCreditosAsignados where valid = 1
	truncate table historialCreditosAsignados
	insert historialCreditosAsignados select *from hca