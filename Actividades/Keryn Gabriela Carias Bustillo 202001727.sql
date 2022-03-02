Drop Procedure if Exists SP_Procesar_Factura;
Delimiter //
Create Procedure SP_Procesar_Factura(
in p_id_factura int,
in p_id_producto int,
in p_cantidad int
 )

Begin

declare v_id_factura int;
declare v_id_producto int;
declare v_cantidad int;
declare v_id_producto int;
declare v_isv_prod decimal(12,2) default 0;
declare v_total_prod   decimal(12,2) default 0;
declare v_subtotal_prod         decimal(12,2) default 0;
declare v_precio_venta decimal(12,2) default 0;
declare v_cantidad        int;

set v_id_factura        = p_id_factura;
set v_id_producto       = p_id_producto;
set v_cantidad          = p_cantidad;

if id_producto = v_id_producto then
Call SP_Guardar_Factura();
   
else

insert into bd_sample.tbl_items_factura(
id_factura, id_producto, cantidad
) values (
v_id_factura, v_id_producto, v_cantidad
);

end if;
   
commit;
End;