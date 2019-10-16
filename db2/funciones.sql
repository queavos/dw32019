CREATE OR REPLACE FUNCTION public."ventasTot"(venta double precision )
  RETURNS double precision AS
$BODY$
DECLARE 
	total integer;
 BEGIN
	select sum(vdet_precio*vdet_cant) into total from ventasdet where vent_id =$1;
 return total;
 END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public."ventasTot"(integer)
  OWNER TO postgres;
