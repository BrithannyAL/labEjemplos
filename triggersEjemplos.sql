select * from usuarios
select * from estudiantes

select * from telefonos_estudiante


go

create or alter procedure normalizar_cant_telefonos
as
	declare @cedula int, @cant tinyint
	DECLARE cur_est CURSOR FOR
		select cedula,cantidad_telefonos
		from 
			(select cedula,COUNT(t.telefono) as cantidad_telefonos 
			from estudiantes e inner join telefonos_estudiante t on (e.cedula=t.cedula_estudiantes)
			group by cedula) as et
		where cantidad_telefonos>2
	OPEN cur_est;
	FETCH NEXT FROM cur_est INTO @cedula,@cant;
	WHILE @@FETCH_STATUS = 0
    BEGIN
		if @cant>2
			set @cant=@cant-2
		else
			set @cant=0
		print 'El estudiante cedula: '+cast(@cedula as varchar)+' tiene m�s de dos tel�fonos'
		delete from telefonos_estudiante 
		where	cedula_estudiantes=@cedula 
				and telefono in (select top (@cant) telefono from telefonos_estudiante where cedula_estudiantes=@cedula )
		set @cant=@cant-1
		FETCH NEXT FROM cur_est INTO @cedula,@cant;
    END;

    CLOSE cur_est;
    DEALLOCATE cur_est;

begin tran
exec normalizar_cant_telefonos

select cedula,COUNT(t.telefono) as cantidad_telefonos 
			from estudiantes e inner join telefonos_estudiante t on (e.cedula=t.cedula_estudiantes)
			group by cedula
commit tran
rollback tran

go

go
create or alter trigger validar_multas_devoluciones
on devoluciones
after insert
as
	print ('Entra al Trigger')
	declare @prestamo int,@codigo_digital int, @cant int
	select @prestamo=prestamo,@codigo_digital=codigo_digital from inserted

	select @cant=count(*) from prestamos_ejemplares where prestamo=@prestamo and codigo_digital=@codigo_digital

	if @cant=0
	begin
		print ('Este ejemplar no pertenece a este pr�stamo')
		rollback
	end
	else
	begin
		if GETDATE()>(select fecha_final from prestamos where id_prestamo=@prestamo)
		begin
			declare @ejemplar int
			declare cur_ejemplares cursor for
				
				select * from devoluciones
				where prestamo=@prestamo and codigo_digital!=@codigo_digital
					and codigo_digital not in
					(select codigo_digital from prestamos_ejemplares
						where prestamo=@prestamo and codigo_digital=@codigo_digital)

			open cur_ejemplares
			fetch next cur_ejemplares into @ejemplar
			while @@FETCH_STATUS=0
			begin
				print 'Mostrar una nueva multa para el código digital del ejemplar '+cast(@ejemplar as varchar)
				fetch next cur_ejemplar into @ejemplar
			end
			close cur_ejemplar
			deallocate cur_ejemplar
		end
	end




insert into devoluciones values (1,getDate(),1,123456789,321654987,1)
update devoluciones set fecha=getDate()
delete from devoluciones

select * from devoluciones
select * from prestamos
select * from prestamos_ejemplares
insert into prestamos_ejemplares values (1,1)
insert into prestamos_ejemplares values (2,1)
insert into prestamos_ejemplares values (3,1)
select * from administrativos
