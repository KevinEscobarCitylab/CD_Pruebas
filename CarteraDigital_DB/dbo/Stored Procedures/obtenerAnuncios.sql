	create procedure [dbo].[obtenerAnuncios]  as
	begin
		declare @count int =(select count(1) from anuncios where estado = 1 and GETDATE() between fechaIn and fechaOut)
		if(@count > 0)begin
			select(
				select
					0 as error,
					'Verificado' as message,
					(select json_query(cast((
						select
							idAnuncio,titulo,descripcion,sticky,
							FORMAT(fechaIn,'dd/MM/yyyy','ES') as fechaIn,urlImagen,urlLink
						from anuncios where estado = 1 and GETDATE() between fechaIn and fechaOut for JSON PATH
					)as nvarchar(max)))as ds)as data
				for JSON PATH, WITHOUT_ARRAY_WRAPPER
			)as data
		end
		else begin select (select 404 as error, 'No se encontraron resultados' as message for JSON PATH, WITHOUT_ARRAY_WRAPPER)as data end
	end
