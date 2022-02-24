/* Ejercicio #2*/
drop procedure if exists SP_guardar_producto;

delimiter //
create procedure bd_sample.SP_guardar_producto(
in p_id_producto int,
in p_nombre varchar(25),
in p_descripcion varchar(25),
in p_precio_costo decimal(12,2),
in p_v_precio_venta decimal(12,2)
)
BEGIN
declare v_id_producto int; 
declare v_nombre varchar(25);
declare v_descripcion varchar(25);
declare v_precio_costo decimal(12,2);
declare v_precio_venta decimal(12,2);

set v_id_producto = p_id_producto;
set v_nombre = p_nombre;
set v_descripcion = p_descripcion;
set v_precio_costo = p_precio_costo;
set v_precio_venta = p_v_precio_venta;

insert into bd_sample.tbl_productos(
id_producto, nombre, descripcion, precio_costo, precio_venta
) values (
v_id_producto, v_nombre, v_descripcion, v_precio_costo, v_precio_venta
);
commit;
END;

select * from bd_sample.tbl_productos;


call  bd_sample.SP_guardar_producto(
0,                # p_id_producto
'Plan Diamond',          #p_nombre
'Plan Diamond',                #p_descripcion
 14.00,                    #p_precio_costo
(14.00 * 1.25)           #p_v_precio_venta
);