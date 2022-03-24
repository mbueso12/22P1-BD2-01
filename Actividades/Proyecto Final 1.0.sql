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

end //


