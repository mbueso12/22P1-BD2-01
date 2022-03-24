select * from bd_platvideo.tbl_catalogo;
select * from bd_platvideo.tbl_cartera;
select * from bd_platvideo.tbl_cat_prods;
select * from bd_platvideo.tbl_ciclos_facturacion;
select * from bd_platvideo.tbl_fact_cargos;
select * from bd_platvideo.tbl_fact_detalle;
select * from bd_platvideo.tbl_fact_resumen;
select * from bd_platvideo.tbl_suscriptores;
select * from bd_platvideo.tbl_productos;
select * from bd_platvideo.tbl_tarifas;

drop function bd_platvideo.fn_Valor_Real;

delimiter // 
create function bd_platvideo.fn_get_Valor_Real (
p_valor_real decimal(12,2)
) returns decimal(12,2) deterministic 

begin 
case 
 p_valor_real
 when 1 then return 15.00;
 when 2 then return 10.00;
 when 3 then return 25.00;
 when 4 then return 20.00;
  else return 00;

end case;
end //
delimiter ; 

select bd_platvideo.fn_get_Valor_Real ( 2 ) Valor_real;

delimiter //
create procedure sp_generar_factura(in dia_calendario int)
begin
    INSERT INTO tbl_fact_resumen (fecha_emision,fecha_vencimiento,total_unidades,subtotal_pagar,isv_total,total_pagar,idorden)
SELECT NOW(),now(),count(d.id_producto),b.precio_venta,0,b.precio_venta, a.idorden
FROM
tbl_cartera A
INNER JOIN
TBL_catalogo B ON A.ID_cat = b.id_Cat
INNER JOIN
TBL_cat_prods c on b.id_cat = c.iid_Cat
INNER JOIN
TBL_productos d on c.id_producto = d.id_producto
inner join
tbl_suscriptores e on a.id_suscriptor = e.id_suscriptor
inner join
tbl_ciclos_facturacion f on e.idciclo = f.idciclo
where f.dia_calendario = dia_calendario;
   

INSERT INTO tbl_fact_detalle
SELECT distinct
g.id_factura,FLOOR(1 + RAND() * 5),1,b.titulo,c.precio_venta,c.precio_venta,0,0,NOW()
FROM
tbl_cartera A
INNER JOIN
TBL_catalogo B ON A.ID_cat = b.id_Cat
INNER JOIN
TBL_cat_prods c on b.id_cat = c.iid_Cat
INNER JOIN
TBL_productos d on c.id_producto = d.id_producto
inner join
tbl_suscriptores e on a.id_suscriptor = e.id_suscriptor
inner join
tbl_ciclos_facturacion f on e.idciclo = f.idciclo
inner join
tbl_fact_resumen g on a.idorden = g.idorden
where
f.dia_calendario = dia_calendario;

commit;
END;


/*
==== Acciones =====:
 1 = Agregar Catálago
 2 = Actualizar Catálogo
 3 = Desactivar Catálago
 4 = Agregar producto a catalogo
 5 = Desactivar Producto de catalogo
*/
select * from bd_platvideo.tbl_catalogo;
/*Ejemplos*/
/*Ingresar Catálago*/
call sp_catalago ('Headset', 'Audifonos gamers con RGB', 1500.00, 2000.00, '2022-03-23 01:00','2022-03-25 01:00', null, null, null,null, null, 1 )

/* Actualizar Catálogo*/
call sp_catalago ('Headset', 'Audifonos gamers', 1500.00, 2000.00, '2022-03-23 01:00','2022-03-25 01:00', null, 1, null,null, null, 2 )

/* Desactivar Catálogo*/
call sp_catalago ('Headset', 'Audifonos gamers', 1500.00, 2000.00, '2022-03-23 01:00','2022-03-22 01:00', null, 1, null,null, null, 3 )

/* Agregar a Catálogo*/
call sp_catalago ('', '', 0, 0, null,null, 1, null, 1,27.00, 1, 4 ); select * from bd_platvideo.tbl_cat_prods;

/* Desactivar Producto de catalogo*/
call sp_catalago ('', '', 0, 0, null,null, 1, null, 1,0, 1, 5 ); select * from bd_platvideo.tbl_cat_prods;

delimiter //
create procedure sp_catalago (
in p_titulo varchar(45), 
in p_descripcion varchar(45),
 in p_costo decimal(12,2), 
 in p_precio_venta decimal(12,2),
 in p_fecha_inicio datetime ,
 in p_fecha_fin datetime,
 in p_id_producto int,
 in p_id_cat int,
 in p_iid_cat int ,
 in p_precio_venta2 decimal(12,2),
 in p_estado varchar(45),
 in accion int
)
begin
	case
		when accion=1 then 
			insert into tbl_catalogo  values (0,p_titulo,p_descripcion,p_costo,p_precio_venta,p_fecha_inicio,p_fecha_fin);
            
        when accion=2 then 
			update tbl_catalogo set titulo=p_titulo , descripcion=p_descripcion,costo=p_costo,precio_venta=p_precio_venta,fecha_inicio=p_fecha_inicio,fecha_fin=p_fecha_fin where id_cat=p_id_cat;
            
        when accion=3 then 
			update  tbl_catalogo set fecha_fin=p_fecha_fin where id_cat=p_id_cat;

       when accion = 4 then
			insert into tbl_cat_prods values(p_id_producto,p_iid_cat,p_precio_venta2,p_estado);
       
       when accion=5 then
			update tbl_cat_prods set estado=0 where id_producto=p_id_producto and iid_cat=p_iid_cat;
       
     end case;   
commit;
end;

		



