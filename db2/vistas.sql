select laboratorio.lab_id, laboratorio.lab_desc, productos.prod_id,
	productos.prod_desc,productos.prod_precio, prod_farma.pfar_cant,
	farmacos.farma_id, farmacos.farma_desc
from laboratorio, farmacos, prod_farma, productos
where
laboratorio.lab_id= productos.lab_id and
productos.prod_id= prod_farma.prod_id and
prod_farma.farma_id=farmacos.farma_id and
laboratorio.lab_id=1
====================================
Select lab.lab_id , lab.lab_desc, prod.prod_desc, prod.prod_id, prod.prod_precio, stk.lote_id, 
stk.lote_cantidad, stk.lote_venc, stk.lote_desc, alm.alma_id, alm.alma_desc
from 
productos prod  
 inner join laboratorio lab on prod.lab_id= lab.lab_id 
 inner join stock stk on prod.prod_id= stk.prod_id 
 inner join almacenes alm on stk.alma_id= alm.alma_id
  ===================
select prod_id, lote_desc, sum(lote_cantidad) as suma
from stock
group by prod_id, lote_desc
============================
select  trans.*, orig.alma_desc as "origen", dest.alma_desc as "destino" , 
trdet.transdet_cant, trdet.lote_id,  stk.lote_desc, stk.lote_venc, 
	stk.prod_id, prods.prod_desc, prods.lab_id, labs.lab_desc
from 
transferencias trans 
inner join transdetalle trdet on trdet.transf_id=trans.transf_id
inner join almacenes orig on orig.alma_id=trans.trans_origen 
inner join almacenes dest on dest.alma_id=trans.trans_dest
inner join stock stk on  trdet.lote_id=stk.lote_id 
inner join productos prods on stk.prod_id=prods.prod_id
inner join laboratorio labs on prods.lab_id=labs.lab_id
======================================
create or replace view vw_ventacab as
select empleados.emple_nombre,ventas.emple_id, clientes.cliente_id, clientes.cliente_nombre, clientes.cliente_ruc,
ventas.vent_fecha, ventas.vent_nro,
ventas.vent_estado, ventas.vent_tipo,ventas.vent_id, "ventasTot"(ventas.vent_id)
from ventas
inner join empleados on ventas.emple_id=empleados.emple_id
inner join clientes on ventas.cliente_id=clientes.cliente_id