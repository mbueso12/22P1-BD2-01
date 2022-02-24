/* Ejercio  #1*/

select * from bd_sample.tbl_subscriptores;

delimiter //
create procedure sp_guardar_subscriptor(
in codigosubscriptor varchar(45),
in s_nombre varchar(120),
in s_apellido varchar(120)
)
begin
   update bd_sample.tbl_subscriptores 
   set nombres = s_nombre , apellidos = s_apellido
   where codigo_subscriptor = codigosubscriptor; 
commit;
END;

describe bd_sample.tbl_subscriptores 
CALL sp_guardar_subscriptor ('202100477','Favio Saul','Valladares');
      