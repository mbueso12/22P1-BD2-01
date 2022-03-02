select * from bd_sample.tbl_subscriptores;

DROP PROCEDURE if exists`sp_guardar_subscriptor`;
delimiter //
create procedure sp_guardar_subscriptor(
in s_id_subscriptor int,
in s_codigosubscriptor int,
in s_nombres varchar(20),
in s_apellidos varchar(20)
)
begin
        declare v_id_subscriptor int;
	declare  v_codigosubscriptor int; 
	declare  v_nombres varchar(20); 
	declare  v_apellidos varchar(20);
	
    set v_id_subscriptor          = s_id_subscriptor;
	set v_codigosubscriptor      = s_codigosubscriptor;
	set v_nombres                = s_nombres;
	set v_apellidos              = s_apellidos;

UPDATE bd_sample.tbl_subscriptores 
SET 
   nombres = v_nombres ,
   apellidos = v_apellidos 
WHERE
    id_subscriptor = v_id_subscriptor;
commit;
END;

describe bd_sample.tbl_subscriptores 
CALL sp_guardar_subscriptor (
'0'                     # s_id_subscriptor
'202100477'            # s_codigo_subscriptor   
'Favio Saul'           # s_nombre
'Valladares'           # s_apellido
);

*******************************************************
select codigo_subscriptor into v_codigo_subscriptor
from bd_sample.tbl_subscriptores 
where codigo_subscriptor = v_codigo_subscriptor;


if v_codigo_subscriptor is null then 
insert into tbl_subscriptores (
id_subscriptor, codigo_subscriptor, s_nombre,  s_apellidos,
) values (
s_nombre, s_apellido
);
else 
    CALL sp_crear_subscriptor (
    '0'                     # s_id_subscriptor
   '202100308'            # s_codigo_subscriptor   
   'Roxana'            # s_nombre
   'velasquez'           # s_apellido
    );
end if 
commit;
end;