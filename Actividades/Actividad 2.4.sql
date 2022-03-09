DROP procedure IF EXISTS bd_sample.SP_CREAR_CADENA; 


delimiter //
CREATE procedure bd_sample.SP_CREAR_CADENA (

in p_final int
)

begin 

declare i int default 0;
declare v_id_factura int;
declare v_fecha_emision varchar(20);
declare v_id_subscriptor int;
declare v_numero_random varchar (20);
declare p_inicial varchar(2000);


set v_numero_random = floor( RAND()*(10000-0)+10000 );
set v_fecha_emision = fecha_creacion ;

select fecha_creacion into v_fecha_emision from 
bd_sample.tbl_tickets_promo where v_fecha_emision = fecha_creacion;
        
set p_inicial = " ";

while i < p_final do 
		set i = i+1;
        
        set p_inicial = v_numero_random;
        
select  id_factura , fecha_emision , id_subscriptor  
        into  
        v_id_factura , v_fecha_emision , v_id_subscriptor
		from bd_sample.tbl_facturas_selectas where id_factura = i; 
        
    insert into tbl_tickets_promo (idfactura,numero_random,fecha_creacion)  
select distinct id_factura,ceil(rand()*(10000-0)+1000), now() 
from tbl_facturas_selectas where orden=30;    
	

        
    end while;
    select p_inicial ;

commit;
end;