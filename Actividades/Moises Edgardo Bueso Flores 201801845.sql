/*2. Modifique el procedimiento "sp_guardar_producto" añadiendo las instrucciones necesarias para que cumpla con los siguientes requerimientos: 

Agregar el parámetro porcentaje, para calcular el precio venta en base al porcentaje indicado. En caso de que no se indique un porcentaje, realizar el cálculo de acuerdo a las siguientes condiciones:

i.   Si el costo esta entre 0 y 3.99 entonces usar 30%

ii.  Si el costo esta entre 4 y 7.99 entonces usar 50%

iii. Si el costo es mayor a 8 entonces usar 60% */





drop procedure if exists SP_GUARDAR_PRODUCTO;

 Delimiter //

CREATE PROCEDURE SP_GUARDAR_PRODUCTO ( 

in p_id_producto int, 

in p_nombre varchar (45),

in p_descripcion varchar (45),

in p_precio_costo decimal (12,2),

in p_porcentaje decimal (12,2)

)



begin 

declare v_id_producto int;

declare v_nombre varchar( 45);

declare v_descripcion varchar (45);

declare v_precioCosto decimal (12,2);

declare v_precioVenta decimal (12,2);

declare v_porcentaje decimal (12,2);

declare v_Fecha_Insercion datetime;



set v_id_producto =p_productoId;

set v_nombre = p_nombre;

set v_descripcion =p_descripcion;

set v_precioCosto =p_precio_costo ;

set v_porcentaje = p_porcentaje ;

select now () into v_Fecha_Insercion;



case

when v_precioCosto between 0 and 3.99 then set v_porcentaje = 1.3 ;

when v_precioCosto between 4 and 7.99 then set v_porcentaje = 1.5 ;

when v_precioCosto  < 8 then               set v_porcentaje = 1.6 ;  

end case ;

set v_precioVenta= v_precioCosto + (v_precioCosto * v_porcentaje);



  if not exists tbl_productos_hits (select id_producto from tbl_productos = v_id_producto) then

insert into bd_sample.tbl_productos_hits (id_producto, nombre, descripcion, precio_costo, precio_venta, Fecha_Insercion)

values (v_id_producto, v_nombre, v_descripcion, v_precioCosto, v_precioVenta, v_Fecha_Insercion);



 else 

 

update tbl_productos 

set 

nombre = v_nombre,

descripcion= v_descripcion,               

precio_costo= v_precioCosto,               

precio_venta= v_precioVenta  

where id_producto= v_id_producto;

 

 end if;

 commit;

 END;



/3. Modifique el procedimiento "sp_guardar_factura" de manera que identifique según el id da factura, si la misma ya existe, de ser asi, entonces que actualice los datos de la factura, de lo contrario que cree un registro nuevo./



DROP PROCEDURE bd_sample.SP_GUARDAR_FACTURA;

DELIMITER //

CREATE PROCEDURE bd_sample.SP_GUARDAR_FACTURA(

    in p_id_factura          int, 

    in p_fecha_emision      datetime,

    in p_id_subscriptor     int,

    in p_numero_items       int

)

BEGIN

declare v_check             int;

declare v_id_factura          int;

declare v_fecha_emision     datetime;

declare v_id_subscriptor     int;

declare v_numero_items         int;

declare v_isv_total         decimal(12,2);

declare v_subtotal          decimal(12,2);

declare v_totapagar         decimal(12,2);

declare v_precio_prod       decimal(12,2);



 set v_id_factura         = p_id_factura;

    set v_fecha_emision        = p_fecha_emision; 

    set v_id_subscriptor    = p_id_subscriptor;

    set v_numero_items      = p_numero_items;



if v_check is not null then

insert into bd_sample.tbl_facturas (

id_factura, fecha_emision, id_subscriptor, numero_items, isv_total, subtotal, totapagar

)value

(v_id_factura, v_fecha_emision,v_id_subscriptor,v_numero_items,v_isv_total,v_subtotal,v_totapagar);

    

    else

    

update  bd_sample.tbl_facturas

Set numero_items   = v_numero_items,

fecha_emision  = v_fecha_emision,

id_subscriptor = v_id_subscriptor

where id_factura   = v_id_factura;

end if;





 

 commit;

END;



CALL bd_sample.SP_GUARDAR_FACTURA(

  58,                         # p_id_factura

   curdate(),                # p_fecha_emision 

   18,                        # p_id_subscriptor

    5                         # p_numero_items

);

