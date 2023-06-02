
select * from usuario
go


--Se declara el cursor (se crea)
declare cursor1 cursor
	for select * from usuario
go

--Primero se debe abrir el cursos para navegarlo y la terminar se debe cerrar
open cursor1
go
fetch next from cursor1
go
close cursor1
go
deallocate cursor1 --Sacarlo de la memoria (el cursor es como una variable temporal)
go

--Ejemplo para usar cursores


create table mascota (
	id int identity(1,1) primary key,
	nombre varchar(10) not null,
	animal varchar(10) not null 
)
go

select * from mascota
go

create procedure sp_insertar_mascota
	@nombre varchar(10),
	@animal varchar(10)
as
begin
	insert into mascota(nombre, animal)
	values (@nombre, @animal)
end
go

exec sp_insertar_mascota 'tommy', 'gato'
exec sp_insertar_mascota 'baloo', 'perro'
exec sp_insertar_mascota 'max', 'perro'
exec sp_insertar_mascota 'tito', 'gato'
go

declare --Las variables en las que vamos a guardar los datos en donde está el cursor
	@nombre varchar(10),
	@animal varchar(10)
declare cmascota cursor --se declara el cursor
	for select nombre, animal from mascota
open cmascota
fetch cmascota into @nombre, @animal --le pedimos a lcursor que guarde los datos de donde él está
while (@@FETCH_STATUS=0) --Devuelve 0 si todo se ejecutó correctamente
begin
	print @nombre + ' ' + @animal --se imprimen los resultados que va recorriendo
	fetch cmascota into @nombre, @animal --le decimos que vata navegando por el cursor
end
close cmascota
deallocate cmascota
go

--NOTAS
--puedo usar 'cursor global'
--si queremos navegar no solo hacia delante, debemos usar la palabra scroll

--Ejemplos

declare cursorEjemplo cursor scroll
	for select * from mascota
go
open cursorEjemplo
go

--otras instrucciones
fetch next from cursorEjemplo --avanza a la siguiente linea en el cursor
go

fetch prior from cursorEjemplo --regresar a la linea anterior
go

fetch last from cursorEjemplo --ultimo dato del cursor
go

fetch first from cursorEjemplo --primer dato del cursor
go

close cursorEjemplo
go
deallocate cursorEjemplo
go


--Ejemplo para modificar datos con cursores

declare --Las variables en las que vamos a guardar los datos en donde está el cursor
	@nombre varchar(10),
	@animal varchar(10)
declare cmascota cursor --se declara el cursor
	for select nombre, animal from mascota
	for update --para modificar 
open cmascota
fetch cmascota into @nombre, @animal --le pedimos a lcursor que guarde los datos de donde él está
while (@@FETCH_STATUS=0) --Devuelve 0 si todo se ejecutó correctamente
begin
	update mascota
		set animal = 'nuevo'
	fetch cmascota into @nombre, @animal --le decimos que vata navegando por el cursor
end
close cmascota
deallocate cmascota
go


