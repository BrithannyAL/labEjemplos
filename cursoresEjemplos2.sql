use Sistema_Bibliotecario
go

select * from usuarios
go

select * from estudiantes
go

select * from telefonos_estudiante
go

--Los cursores se usan para modificar valores o saber sobre la particularidad de un conjnto de valores

create or alter procedure normalizar_cant_telefonos
as
	declare
		@cedula int,
		@carrera tinyint,
		@cant int
	declare cursor_prestamos cursor for
		select * 
		from
			(select cedula as CEDULA, count(t.telefono) AS CANTIDAD_TELEFONOS
			from estudiantes e inner join telefonos_estudiante t on (e.cedula = t.cedula_estudiantes)
			group by cedula) as et
		where CANTIDAD_TELEFONOS > 2
	open cursor_prestamos
	fetch next from cursor_prestamo into @cedula
	while @@FETCH_STATUS=0
	begin
		print 'El estudiante de cédula : '+cast(@cedula as varchar)+' tiene más de dos telefonos'
		delete from telefonos_estudiante where cedula_estudiantes=@cedula
			and telefono=(select top 1 telefono from telefonos_estudiante where cedula_estudiantes=@cedula)
		fetch next from cursor_prestamo into @cedula, @carrera
	end
	close cursor_prestamos
	deallocate cursor_prestamos
go

exec normalizar_cant_telefonos
go
