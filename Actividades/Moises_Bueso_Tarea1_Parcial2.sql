/* Ejercicio #3*/

select * from bd_sample.tbl_facturas;


delimiter //
create procedure bd_sample.SP_guardar_factura(
in p_fecha_emision datetime,
in p_id_subscriptor int,
in p_numero_items int,
in p_isv_total decimal(12,2),
in p_subtotal decimal(12,2),
in p_totapagar decimal(12,2)
)
begin 

insert into bd_sample.tbl_facturas 
values(0,
p_fecha_emision,
p_id_subscriptor,
p_numero_items,
p_isv_total,
p_subtotal,
p_totapagar
);
commit;
END;

/*Inserción de datos*/

CALL bd_sample.SP_guardar_factura('2022-02-23 19:37:00',20,4,6.25,41.40,47.61)



/* Ejercicio #4 */

select * from bd_sample.tbl_items_factura;
select * from bd_sample.tbl_facturas;

delimiter //
create procedure bd_sample.sp_procesar_factura
(
in p_id_factura int, 
in p_id_producto int,
in p_cantidad int
)

begin
/*Declaración de variables*/
declare v_isv decimal(12,2);
declare v_subtotal decimal(12,2);
declare v_total decimal(12,2);
declare v_items int;
declare v_precio decimal(12,2);
declare v_isv_old decimal(12,2);
declare v_subtotal_old decimal(12,2);
declare v_total_old decimal(12,2);
 
 /*Calculos para totales*/
set v_precio = (select precio_venta from tbl_productos where id_producto = p_id_producto);
set v_subtotal = ( v_precio * p_cantidad);
set v_isv = (v_subtotal * 0.18);
set v_total = (v_subtotal + v_isv);

/* Se inserta el detalle de la factura*/
insert into bd_sample.tbl_items_factura
values (
p_id_factura, p_id_producto, p_cantidad
);

/*Se consulta los valores que tenia la factura para acumular los nuevos y no perder información*/
set v_subtotal_old = (select subtotal from bd_sample.tbl_facturas where id_factura=p_id_factura);
set v_isv_old =(select isv_total from bd_sample.tbl_facturas where id_factura=p_id_factura);
set v_total_old = (select totapagar from bd_sample.tbl_facturas where id_factura=p_id_factura);

/*Se actualiza los calulos sumando los anteriores*/
update bd_sample.tbl_facturas
set isv_total = v_isv + v_isv_old,
subtotal = v_subtotal + v_subtotal_old ,
totapagar = v_total + v_total_old
where id_factura = p_id_factura;
 
 /* Contamos los items que se ingresaron para actualizar el campo en la tabla de facturas*/
set v_items = (select sum(cantidad)  from bd_sample.tbl_items_factura where id_factura = p_id_factura);

/*Teniendo el número de items se procede a actualizar en la tabla*/
update  bd_sample.tbl_facturas 
set numero_items = v_items 
where id_factura = p_id_factura;

commit;
END;


call  bd_sample.sp_procesar_factura (29, 6,1)
select * from bd_sample.tbl_items_factura;
select * from bd_sample.tbl_facturas;
