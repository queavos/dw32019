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


select empleados.emple_nombre, clientes.cliente_nombre, clientes.cliente_ruc, 
ventas.vent_fecha, ventas.vent_nro,ventas.vent_estado, ventas.vent_tipo 
FROM ventas 
inner join empleados on ventas.emple_id= empleados.emple_id 
inner join clientes on ventas.cliente_id= clientes.cliente_id



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

=====
INSERT INTO public.clientes(
            cliente_nombre, cliente_ruc, cliente_telef, cliente_direc, 
            cliente_mail)
    VALUES ('walter piris', '32432423','423424', '234324234', '242342');
INSERT INTO public.clientes(
            cliente_nombre, cliente_ruc, cliente_telef, cliente_direc, 
            cliente_mail)
    VALUES ('mario segovia', '2566564556','423424', '234324234', '987654');
INSERT INTO public.clientes(
            cliente_nombre, cliente_ruc, cliente_telef, cliente_direc, 
            cliente_mail)
    VALUES ('francisco alcaraz', '932928923','423424', '234324234', '6790358');

=================

INSERT INTO public.empleados(
          emple_nombre, emple_ruc, emple_telef, emple_direc, 
            emple_mail)
    VALUES ('tamara gonzalez' , '4349071', '0975 633417', 'nva esperanza',' tamaragonzalezrg4@gmail.com' );


INSERT INTO public.empleados(
          emple_nombre, emple_ruc, emple_telef, emple_direc, 
            emple_mail)
    VALUES (' enzo dure' , '5511127', '0991 967000', 'quiteria,'enzodure25@gmail.com' );


============
INSERT INTO public.ventas(
            cliente_id, emple_id, vent_fecha, vent_nro, vent_estado, 
            vent_tipo)
    VALUES (1, 1, '2018-02-19', 234, 1,1);
INSERT INTO public.ventas(
            cliente_id, emple_id, vent_fecha, vent_nro, vent_estado, 
            vent_tipo)
    VALUES (2, 2, '2018-02-19', 234, 1,1);
    INSERT INTO public.ventas(
            cliente_id, emple_id, vent_fecha, vent_nro, vent_estado, 
            vent_tipo)
    VALUES (1, 1, '2018-02-19', 234, 1,1);
INSERT INTO public.ventas(
            cliente_id, emple_id, vent_fecha, vent_nro, vent_estado, 
            vent_tipo)
    VALUES (3, 2, '2018-02-19', 234, 1,1);

======
INSERT INTO public.ventasdet(
             lote_id, vent_id, vdet_cant, vdet_precio, vdet_iva)
    VALUES ( 1, 1, 3, 50000, 5);
INSERT INTO public.ventasdet(
             lote_id, vent_id, vdet_cant, vdet_precio, vdet_iva)
    VALUES ( 2, 1, 2, 10000, 5);

INSERT INTO public.ventasdet(
             lote_id, vent_id, vdet_cant, vdet_precio, vdet_iva)
    VALUES ( 3, 2, 13, 4000, 5);
INSERT INTO public.ventasdet(
             lote_id, vent_id, vdet_cant, vdet_precio, vdet_iva)
    VALUES ( 2, 2, 20, 8000, 5);
