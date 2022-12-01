	create   procedure EnvioProspectoCore(@idProspecto int,@error int out,@message varchar(max) out) as begin
		select @error = 0,@message = 'Solicitud modificada'
	end
