SELECT gast_id, tmov_id, gast_desc, gast_monto, gast_fecha
  FROM public.gastos;

SELECT caja_id, tcaja_id, tmov_id, caja_fecha, caja_monto, caja_desc, 
       caja_es
  FROM public.cajas;


SELECT cajas.caja_id, cajas.tcaja_id, cajas.tmov_id, cajas.caja_fecha,
 cajas.caja_monto, cajas.caja_desc, 
       cajas.caja_es, movtipo.tmov_desc, movtipo.tmov_es
  FROM cajas 
	inner join movtipo on movtipo.tmov_id=cajas.tmov_id	
  ;
SELECT gastos.gast_id, gastos.tmov_id, gastos.gast_desc, gastos.gast_monto, 
gastos.gast_fecha, movtipo.tmov_desc, movtipo.tmov_es
  FROM gastos
	inner join movtipo on movtipo.tmov_id=gastos.tmov_id;

===========
(SELECT cajas.caja_id as nro, cajas.tmov_id  as tmov_id, cajas.caja_fecha as fecha,
  cajas.caja_desc as desc, cajas.caja_monto as monto,
      movtipo.tmov_desc, movtipo.tmov_es, 'CAJA'
  FROM cajas 
	inner join movtipo on movtipo.tmov_id=cajas.tmov_id
  where cajas.tcaja_id=1 )			
UNION 
(SELECT gastos.gast_id as nro, gastos.tmov_id as tmov_id, gastos.gast_fecha as fecha,
gastos.gast_desc  as desc, gastos.gast_monto as monto, 
 movtipo.tmov_desc, movtipo.tmov_es, 'GASTOS'
  FROM gastos
	inner join movtipo on movtipo.tmov_id=gastos.tmov_id)
==========
INSERT INTO public.tcajas(
            tcaja_desc)
    VALUES ( 'PRINCIPAL');

INSERT INTO public.movtipo(tmov_desc, tmov_es)    VALUES ('COMPRAS', '-1');
INSERT INTO public.movtipo(tmov_desc, tmov_es)    VALUES ('VENTAS', '1');
INSERT INTO public.movtipo(tmov_desc, tmov_es)    VALUES ('SERVICIOS', '-1');
INSERT INTO public.movtipo(tmov_desc, tmov_es)    VALUES ('ALQUILERES', '-1');
INSERT INTO public.movtipo(tmov_desc, tmov_es)    VALUES ('COMBUSTIBLE', '-1');

INSERT INTO public.cajas(
             tcaja_id, tmov_id, caja_fecha, caja_monto, caja_desc, 
            caja_es)
    VALUES (1, 2, current_date, 100000, 'venta cliente 1', 1);
INSERT INTO public.cajas(
             tcaja_id, tmov_id, caja_fecha, caja_monto, caja_desc, 
            caja_es)
    VALUES (1, 2, current_date, 50000, 'venta cliente 2', 1); 
INSERT INTO public.cajas(
             tcaja_id, tmov_id, caja_fecha, caja_monto, caja_desc, 
            caja_es)
    VALUES (1, 2, current_date, 35000, 'venta cliente 3', 1);    

INSERT INTO public.gastos(
             tmov_id, gast_desc, gast_monto, gast_fecha)
    VALUES (3, 'PAGO ANDE NOVIEMBRE', 350000, current_date);
INSERT INTO public.gastos(
             tmov_id, gast_desc, gast_monto, gast_fecha)
    VALUES (3, 'PAGO COPACO NOVIEMBRE', 50000, current_date); 
INSERT INTO public.gastos(
             tmov_id, gast_desc, gast_monto, gast_fecha)
    VALUES (4, 'COMBUSTIBLE PARA REPARTO', 80000, current_date);    


======================

create view vw_arque as 
(SELECT cajas.caja_id as nro, cajas.tmov_id  as tmov_id, cajas.caja_fecha as fecha,
  cajas.caja_desc as desc, cajas.caja_monto as monto,
      movtipo.tmov_desc, movtipo.tmov_es, 'CAJA' as ORIGEN
  FROM cajas 
	inner join movtipo on movtipo.tmov_id=cajas.tmov_id
  where cajas.tcaja_id=1 )			
UNION 
(SELECT gastos.gast_id as nro, gastos.tmov_id as tmov_id, gastos.gast_fecha as fecha,
gastos.gast_desc  as desc, gastos.gast_monto as monto, 
 movtipo.tmov_desc, movtipo.tmov_es, 'GASTOS' as DESTINO
  FROM gastos
	inner join movtipo on movtipo.tmov_id=gastos.tmov_id);

========
CREATE FUNCTION public.vent_total(IN id integer) RETURNS numeric AS
$BODY$
DECLARE 
	total numeric;
 BEGIN
	select sum(vdet_precio*vdet_cant) into total from ventasdet where vent_id =$1;
 return total;
 END;$BODY$
LANGUAGE plpgsql STABLE NOT LEAKPROOF;
