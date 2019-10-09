insert into laboratorio (lab_desc, lab_active) 
	values ('Lasca', 1);
insert into laboratorio (lab_desc, lab_active) 
	values ('Indufar', 1);
insert into laboratorio (lab_desc, lab_active) 
	values ('Bago', 1);	
insert into laboratorio (lab_desc, lab_active) 
	values ('Quimfa', 0);		

insert into rubros (rubro_desc, rubro_iva) values ('medicamentos',5);
insert into rubros (rubro_desc, rubro_iva) values ('perfumes',10);


insert into 
productos (lab_id, rubro_id, prod_desc, prod_precio, prod_activo,prod_bcode) 
values ( 1, 1, 'kitadol forte', 10000,1,'kfc100');
insert into 
productos (lab_id, rubro_id, prod_desc, prod_precio, prod_activo,prod_bcode) 
values ( 2, 1, 'hexacol', 30000,1,'hexa1223423');
insert into 
productos (lab_id, rubro_id, prod_desc, prod_precio, prod_activo,prod_bcode) 
values ( 4, 2, 'One Million', 340000,1,'omillionasdda');

insert into farmacos (farma_desc) values ('ibuprofeno');
insert into farmacos (farma_desc) values ('BETAMETASONA');
insert into farmacos (farma_desc) values ('GENTAMICINA');
insert into farmacos (farma_desc) values ('MICONAZOL');

insert into prod_farma  (prod_id, farma_id, pfar_cant) values (1, 1,400 );
insert into prod_farma  (prod_id, farma_id, pfar_cant) values (2, 2,10 );
insert into prod_farma  (prod_id, farma_id, pfar_cant) values (2, 3,4 );
insert into prod_farma  (prod_id, farma_id, pfar_cant) values (2, 4,8 );

insert into almacenes (alma_desc) values ('Deposito');
insert into almacenes (alma_desc) values ('Local Centro');

INSERT INTO public.stock(
            prod_id, alma_id, lote_cantidad, lote_desc, lote_venc, 
            lote_bcode)
    VALUES (1, 1, 50, '2244-333','2018-12-15' , 'asdsdafsdafasdfdasf');
INSERT INTO public.stock(
            prod_id, alma_id, lote_cantidad, lote_desc, lote_venc, 
            lote_bcode)
    VALUES (1, 2, 8, '2244-333','2019-12-30' , 'asdsdafsdafasdfdasf');
INSERT INTO public.stock(
            prod_id, alma_id, lote_cantidad, lote_desc, lote_venc, 
            lote_bcode)
    VALUES (1, 1, 250, '3212-111','2020-12-15' , 'asdsad2123213123');  




