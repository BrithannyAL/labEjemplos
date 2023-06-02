select * from usuarios

insert into usuarios VALUES
('100000001','A','','',''),
('100000002','A','','','');


select * from administrativos

insert into administrativos VALUEs
('100000001',1);


select * from estudiantes

insert into estudiantes VALUES
('100000001',1,'',1,'2023-01-01',1,1);

delete from estudiantes where cedula='100000001';

go
drop PROCEDURE ins_estudiantes;
go
create PROCEDURE ins_estudiantes 
(
    @cedula int, 
    @h tinyint,
    @dd varchar(20),
    @d tinyint,
    @f date,
    @c tinyint, 
    @s tinyint)
as
BEGIN
    DECLARE
        @cantidad tinyint
    set @cantidad=(select count(*) from administrativos where cedula=@cedula)
    if @cantidad=0
    begin
        insert into estudiantes VALUES
        (@cedula,@h,@dd,@d,@f,@c,@s);
    END
    else
        PRINT 'Este usuario ya es administrativo'
END;

execute ins_estudiantes '100000002',1,'',1,'2023-01-01',1,1

go
create or alter PROCEDURE ins_estudiantes_RB
(
    @cedula int, 
    @h tinyint,
    @dd varchar(20),
    @d tinyint,
    @f date,
    @c tinyint, 
    @s tinyint)
as
BEGIN
    begin TRAN
    
        insert into estudiantes VALUES
        (@cedula,@h,@dd,@d,@f,@c,@s);

        DECLARE
            @cantidad tinyint

        set @cantidad=(select count(*) from administrativos where cedula=@cedula)
        if @cantidad>0
        begin
            PRINT 'Este usuario ya es administrativo';

            ROLLBACK TRAN
        END;
        ELSE
        BEGIN
            COMMIT TRAN
        END
    return 0
END;

delete from estudiantes where cedula=100000001
select * from estudiantes
execute ins_estudiantes_RB '100000001',1,'',1,'2023-01-01',1,1

go
create or alter trigger tg_ins_estudiantes
on estudiantes
after insert
as
BEGIN
    DECLARE
        @cantidad tinyint

    set @cantidad=(select count(*) from administrativos where cedula=(select cedula from inserted))
    if @cantidad>0
    begin
        PRINT 'Este usuario ya es administrativo';
        ROLLBACK TRAN
    END;
END;


select * from estudiantes

insert into estudiantes VALUES
('100000001',1,'',1,'2023-01-01',1,1);

