update parametros set pclToken = getdate()
go
update t
    set t.app = format(getdate(), 'MMM dd yyyy HH:mmtt'),
        t.formatos = format(getdate(), 'MMM dd yyyy HH:mmtt'),
        t.encuestas = format(getdate(), 'MMM dd yyyy HH:mmtt'),
        t.actividades = format(getdate(), 'MMM dd yyyy HH:mmtt'),
        t.detalleActividades = format(getdate(), 'MMM dd yyyy HH:mmtt'),
        t.reacciones = format(getdate(), 'MMM dd yyyy HH:mmtt'),
        t.motivoActividades = format(getdate(), 'MMM dd yyyy HH:mmtt'),
		t.campanias =format(getdate(), 'MMM dd yyyy HH:mmtt')
from inicioSesionJS t
where ID = 3
go
exec precargaParcial
go