--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: SumaLote(integer, character varying); Type: FUNCTION; Schema: public; Owner: developer
--

CREATE FUNCTION public."SumaLote"(integer, character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
	total integer;
 BEGIN
	select sum(lote_cantidad) into total from stock where prod_id =$1 and lote_desc= $2;
 return total;
 END;$_$;


ALTER FUNCTION public."SumaLote"(integer, character varying) OWNER TO developer;

--
-- Name: au_compras(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.au_compras() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
lote RECORD;
lotes CURSOR for select lote_id, cdet_cant from comprasdet where comp_id=OLD.comp_id;

BEGIN
IF OLD.comp_estado = 0 AND NEW.comp_estado=1 THEN

	FOR lote in lotes LOOP
		UPDATE stock set lote_cantidad= lote_cantidad+ lote.cdet_cant where lote_id=lote.lote_id and alma_id=1;		
	END LOOP;	

END IF;

RETURN NEW;
END;$$;


ALTER FUNCTION public.au_compras() OWNER TO postgres;

--
-- Name: au_venta_procesar(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.au_venta_procesar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$begin 
IF NEW.vent_estado = 1 and OLD.vent_estado=0 then
	INSERT INTO public.cajas(
             tcaja_id, tmov_id, caja_fecha, caja_monto, caja_desc, 
            caja_es)
    VALUES (1, 2, current_date, vent_total(OLD.vent_id ), 'venta cliente '||old.cliente_id, 1);
END IF;
return NEW;
end;$$;


ALTER FUNCTION public.au_venta_procesar() OWNER TO postgres;

--
-- Name: bi_cliente(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bi_cliente() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN 

NEW.cliente_nombre:=UPPER(NEW.cliente_nombre);
IF NEW.cliente_telef is NULL OR NEW.cliente_telef='' THEN 
	NEW.cliente_telef:='-';
END IF;
IF NEW.cliente_direc is NULL OR NEW.cliente_direc='' THEN 
	NEW.cliente_direc:='-';
END IF;	
RETURN NEW;
END$$;


ALTER FUNCTION public.bi_cliente() OWNER TO postgres;

--
-- Name: inrubro(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.inrubro(descr character varying, iva integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
begin 
	IF descr is NULL OR descr='' THEN  
		RAISE  'la descripcion esta vacia(%)','error';
	END IF; 
	if iva is NULL or iva < 0   then
		RAISE  'el valor del iva debe ser mayor a 0';
	END IF; 
	insert into rubros (rubro_desc, rubro_iva) values (descr, iva);
	return 0;
	 --return $1 + $2;
	-- RAISE NOTICE a + b;
end;
$_$;


ALTER FUNCTION public.inrubro(descr character varying, iva integer) OWNER TO postgres;

--
-- Name: suma(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.suma(a integer, b integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
begin 
	 return $1 + $2;
	-- RAISE NOTICE a + b;
end;
$_$;


ALTER FUNCTION public.suma(a integer, b integer) OWNER TO postgres;

--
-- Name: vent_total(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.vent_total(id integer) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE 
	total numeric;
 BEGIN
	select sum(vdet_precio*vdet_cant) into total from ventasdet where vent_id =$1;
 return total;
 END;$_$;


ALTER FUNCTION public.vent_total(id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: almacenes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.almacenes (
    alma_id integer NOT NULL,
    alma_desc character varying(255) NOT NULL
);


ALTER TABLE public.almacenes OWNER TO postgres;

--
-- Name: almacenes_alma_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.almacenes_alma_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.almacenes_alma_id_seq OWNER TO postgres;

--
-- Name: almacenes_alma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.almacenes_alma_id_seq OWNED BY public.almacenes.alma_id;


--
-- Name: cajas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cajas (
    caja_id integer NOT NULL,
    tcaja_id integer,
    tmov_id integer,
    caja_fecha date NOT NULL,
    caja_monto numeric NOT NULL,
    caja_desc character varying(255) NOT NULL,
    caja_es smallint DEFAULT 0 NOT NULL,
    CONSTRAINT ckc_caja_es_cajas CHECK ((caja_es = ANY (ARRAY['-1'::integer, 0, 1])))
);


ALTER TABLE public.cajas OWNER TO postgres;

--
-- Name: cajas_caja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cajas_caja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cajas_caja_id_seq OWNER TO postgres;

--
-- Name: cajas_caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cajas_caja_id_seq OWNED BY public.cajas.caja_id;


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    cliente_id integer NOT NULL,
    cliente_nombre character varying(255) NOT NULL,
    cliente_ruc character varying(255) NOT NULL,
    cliente_telef character varying(255) NOT NULL,
    cliente_direc text,
    cliente_mail character varying(255)
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: clientes_cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientes_cliente_id_seq OWNER TO postgres;

--
-- Name: clientes_cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_cliente_id_seq OWNED BY public.clientes.cliente_id;


--
-- Name: compras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compras (
    comp_id integer NOT NULL,
    prov_id integer NOT NULL,
    emple_id integer NOT NULL,
    comp_fecha date NOT NULL,
    comp_nro character varying(255) NOT NULL,
    comp_estado integer DEFAULT 0 NOT NULL,
    CONSTRAINT ckc_comp_estado_compras CHECK ((comp_estado = ANY (ARRAY[0, 1])))
);


ALTER TABLE public.compras OWNER TO postgres;

--
-- Name: compras_comp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compras_comp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.compras_comp_id_seq OWNER TO postgres;

--
-- Name: compras_comp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compras_comp_id_seq OWNED BY public.compras.comp_id;


--
-- Name: comprasdet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comprasdet (
    cdet_id integer NOT NULL,
    lote_id integer NOT NULL,
    comp_id integer NOT NULL,
    cdet_cant numeric NOT NULL,
    cdet_psunit numeric NOT NULL,
    cdet_iva numeric NOT NULL
);


ALTER TABLE public.comprasdet OWNER TO postgres;

--
-- Name: comprasdet_cdet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comprasdet_cdet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comprasdet_cdet_id_seq OWNER TO postgres;

--
-- Name: comprasdet_cdet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comprasdet_cdet_id_seq OWNED BY public.comprasdet.cdet_id;


--
-- Name: empleados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleados (
    emple_id integer NOT NULL,
    emple_nombre character varying(255) NOT NULL,
    emple_ruc character varying(255) NOT NULL,
    emple_telef character varying(255) NOT NULL,
    emple_direc text,
    emple_mail character varying(255)
);


ALTER TABLE public.empleados OWNER TO postgres;

--
-- Name: empleados_emple_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.empleados_emple_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.empleados_emple_id_seq OWNER TO postgres;

--
-- Name: empleados_emple_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.empleados_emple_id_seq OWNED BY public.empleados.emple_id;


--
-- Name: farmacos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.farmacos (
    farma_id integer NOT NULL,
    farma_desc character varying(255) NOT NULL
);


ALTER TABLE public.farmacos OWNER TO postgres;

--
-- Name: farmacos_farma_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.farmacos_farma_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacos_farma_id_seq OWNER TO postgres;

--
-- Name: farmacos_farma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.farmacos_farma_id_seq OWNED BY public.farmacos.farma_id;


--
-- Name: gastos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gastos (
    gast_id integer NOT NULL,
    tmov_id integer,
    gast_desc character varying(255) NOT NULL,
    gast_monto numeric NOT NULL,
    gast_fecha date NOT NULL
);


ALTER TABLE public.gastos OWNER TO postgres;

--
-- Name: gastos_gast_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gastos_gast_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gastos_gast_id_seq OWNER TO postgres;

--
-- Name: gastos_gast_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gastos_gast_id_seq OWNED BY public.gastos.gast_id;


--
-- Name: laboratorio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laboratorio (
    lab_id integer NOT NULL,
    lab_desc character varying(255) NOT NULL,
    lab_active smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.laboratorio OWNER TO postgres;

--
-- Name: laboratorio_lab_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.laboratorio_lab_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.laboratorio_lab_id_seq OWNER TO postgres;

--
-- Name: laboratorio_lab_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.laboratorio_lab_id_seq OWNED BY public.laboratorio.lab_id;


--
-- Name: movtipo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movtipo (
    tmov_id integer NOT NULL,
    tmov_desc character varying(255) NOT NULL,
    tmov_es smallint DEFAULT 0 NOT NULL,
    CONSTRAINT ckc_tmov_es_movtipo CHECK ((tmov_es = ANY (ARRAY['-1'::integer, 0, 1])))
);


ALTER TABLE public.movtipo OWNER TO postgres;

--
-- Name: movtipo_tmov_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movtipo_tmov_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movtipo_tmov_id_seq OWNER TO postgres;

--
-- Name: movtipo_tmov_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movtipo_tmov_id_seq OWNED BY public.movtipo.tmov_id;


--
-- Name: prod_farma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prod_farma (
    pfar_id integer NOT NULL,
    prod_id integer NOT NULL,
    farma_id integer NOT NULL,
    pfar_cant numeric NOT NULL
);


ALTER TABLE public.prod_farma OWNER TO postgres;

--
-- Name: prod_farma_pfar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prod_farma_pfar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prod_farma_pfar_id_seq OWNER TO postgres;

--
-- Name: prod_farma_pfar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prod_farma_pfar_id_seq OWNED BY public.prod_farma.pfar_id;


--
-- Name: prod_sectores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prod_sectores (
    psec_id integer NOT NULL,
    sect_id integer NOT NULL,
    prod_id integer NOT NULL
);


ALTER TABLE public.prod_sectores OWNER TO postgres;

--
-- Name: prod_sectores_psec_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prod_sectores_psec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prod_sectores_psec_id_seq OWNER TO postgres;

--
-- Name: prod_sectores_psec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prod_sectores_psec_id_seq OWNED BY public.prod_sectores.psec_id;


--
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    prod_id integer NOT NULL,
    lab_id integer NOT NULL,
    rubro_id integer,
    prod_desc character varying(255) NOT NULL,
    prod_precio numeric NOT NULL,
    prod_activo integer DEFAULT 1 NOT NULL,
    prod_bcode character varying(255) NOT NULL
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- Name: productos_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.productos_prod_id_seq OWNER TO postgres;

--
-- Name: productos_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_prod_id_seq OWNED BY public.productos.prod_id;


--
-- Name: proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedores (
    prov_id integer NOT NULL,
    prov_nombre character varying(255) NOT NULL,
    prov_ruc character varying(255) NOT NULL,
    prov_telef character varying(255) NOT NULL,
    prov_direc text,
    prov_mail character varying(255)
);


ALTER TABLE public.proveedores OWNER TO postgres;

--
-- Name: proveedores_prov_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedores_prov_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.proveedores_prov_id_seq OWNER TO postgres;

--
-- Name: proveedores_prov_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedores_prov_id_seq OWNED BY public.proveedores.prov_id;


--
-- Name: rubros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rubros (
    rubro_id integer NOT NULL,
    rubro_desc character varying(255) NOT NULL,
    rubro_iva numeric NOT NULL
);


ALTER TABLE public.rubros OWNER TO postgres;

--
-- Name: rubros_rubro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rubros_rubro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rubros_rubro_id_seq OWNER TO postgres;

--
-- Name: rubros_rubro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rubros_rubro_id_seq OWNED BY public.rubros.rubro_id;


--
-- Name: sectores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sectores (
    sect_id integer NOT NULL,
    alma_id integer NOT NULL,
    sect_desc character varying(255) NOT NULL
);


ALTER TABLE public.sectores OWNER TO postgres;

--
-- Name: sectores_sect_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sectores_sect_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sectores_sect_id_seq OWNER TO postgres;

--
-- Name: sectores_sect_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sectores_sect_id_seq OWNED BY public.sectores.sect_id;


--
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    lote_id integer NOT NULL,
    prod_id integer NOT NULL,
    alma_id integer NOT NULL,
    lote_cantidad numeric NOT NULL,
    lote_desc character varying(255) NOT NULL,
    lote_venc date NOT NULL,
    lote_bcode character varying(255) NOT NULL
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- Name: stock_lote_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_lote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_lote_id_seq OWNER TO postgres;

--
-- Name: stock_lote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_lote_id_seq OWNED BY public.stock.lote_id;


--
-- Name: tcajas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tcajas (
    tcaja_id integer NOT NULL,
    tcaja_desc character varying(255) NOT NULL
);


ALTER TABLE public.tcajas OWNER TO postgres;

--
-- Name: tcajas_tcaja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tcajas_tcaja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tcajas_tcaja_id_seq OWNER TO postgres;

--
-- Name: tcajas_tcaja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tcajas_tcaja_id_seq OWNED BY public.tcajas.tcaja_id;


--
-- Name: total; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.total (
    sum numeric
);


ALTER TABLE public.total OWNER TO postgres;

--
-- Name: transcaja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transcaja (
    trcaja_id integer NOT NULL,
    trcaja_fecha date NOT NULL,
    trcaja_ori integer NOT NULL,
    trcaja_dest integer NOT NULL,
    trcaja_monto numeric NOT NULL
);


ALTER TABLE public.transcaja OWNER TO postgres;

--
-- Name: transcaja_trcaja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transcaja_trcaja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transcaja_trcaja_id_seq OWNER TO postgres;

--
-- Name: transcaja_trcaja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transcaja_trcaja_id_seq OWNED BY public.transcaja.trcaja_id;


--
-- Name: transdetalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transdetalle (
    transdet_id integer NOT NULL,
    lote_id integer NOT NULL,
    transf_id integer NOT NULL,
    transdet_cant numeric NOT NULL
);


ALTER TABLE public.transdetalle OWNER TO postgres;

--
-- Name: transdetalle_transdet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transdetalle_transdet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transdetalle_transdet_id_seq OWNER TO postgres;

--
-- Name: transdetalle_transdet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transdetalle_transdet_id_seq OWNED BY public.transdetalle.transdet_id;


--
-- Name: transferencias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transferencias (
    transf_id integer NOT NULL,
    trans_origen integer NOT NULL,
    trans_dest integer,
    trans_fecha date,
    trans_estado integer DEFAULT 0 NOT NULL,
    CONSTRAINT ckc_trans_estado_transfer CHECK ((trans_estado = ANY (ARRAY[0, 1, 2])))
);


ALTER TABLE public.transferencias OWNER TO postgres;

--
-- Name: transferencias_transf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transferencias_transf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transferencias_transf_id_seq OWNER TO postgres;

--
-- Name: transferencias_transf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transferencias_transf_id_seq OWNED BY public.transferencias.transf_id;


--
-- Name: ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas (
    vent_id integer NOT NULL,
    cliente_id integer NOT NULL,
    emple_id integer NOT NULL,
    vent_fecha date NOT NULL,
    vent_nro character varying(255) NOT NULL,
    vent_estado integer DEFAULT 0 NOT NULL,
    vent_tipo integer DEFAULT 1 NOT NULL,
    CONSTRAINT ckc_vent_estado_ventas CHECK ((vent_estado = ANY (ARRAY[0, 1]))),
    CONSTRAINT ckc_vent_tipo_ventas CHECK ((vent_tipo = ANY (ARRAY[1, 2])))
);


ALTER TABLE public.ventas OWNER TO postgres;

--
-- Name: ventas_vent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ventas_vent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ventas_vent_id_seq OWNER TO postgres;

--
-- Name: ventas_vent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ventas_vent_id_seq OWNED BY public.ventas.vent_id;


--
-- Name: ventasdet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventasdet (
    vdet_id integer NOT NULL,
    lote_id integer NOT NULL,
    vent_id integer NOT NULL,
    vdet_cant numeric NOT NULL,
    vdet_precio numeric NOT NULL,
    vdet_iva numeric NOT NULL
);


ALTER TABLE public.ventasdet OWNER TO postgres;

--
-- Name: TABLE ventasdet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ventasdet IS 'VENTASDET';


--
-- Name: ventasdet_vdet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ventasdet_vdet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ventasdet_vdet_id_seq OWNER TO postgres;

--
-- Name: ventasdet_vdet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ventasdet_vdet_id_seq OWNED BY public.ventasdet.vdet_id;


--
-- Name: vw_arque; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_arque AS
 SELECT cajas.caja_id AS nro,
    cajas.tmov_id,
    cajas.caja_fecha AS fecha,
    cajas.caja_desc AS "desc",
    cajas.caja_monto AS monto,
    movtipo.tmov_desc,
    movtipo.tmov_es,
    'CAJA'::text AS origen
   FROM (public.cajas
     JOIN public.movtipo ON ((movtipo.tmov_id = cajas.tmov_id)))
  WHERE (cajas.tcaja_id = 1)
UNION
 SELECT gastos.gast_id AS nro,
    gastos.tmov_id,
    gastos.gast_fecha AS fecha,
    gastos.gast_desc AS "desc",
    gastos.gast_monto AS monto,
    movtipo.tmov_desc,
    movtipo.tmov_es,
    'GASTOS'::text AS origen
   FROM (public.gastos
     JOIN public.movtipo ON ((movtipo.tmov_id = gastos.tmov_id)));


ALTER TABLE public.vw_arque OWNER TO postgres;

--
-- Name: vw_prodstock; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_prodstock AS
 SELECT lab.lab_id,
    lab.lab_desc,
    prod.prod_desc,
    prod.prod_id,
    prod.prod_precio,
    stk.lote_id,
    stk.lote_cantidad,
    stk.lote_venc,
    stk.lote_desc,
    alm.alma_id,
    alm.alma_desc
   FROM (((public.productos prod
     JOIN public.laboratorio lab ON ((prod.lab_id = lab.lab_id)))
     JOIN public.stock stk ON ((prod.prod_id = stk.prod_id)))
     JOIN public.almacenes alm ON ((stk.alma_id = alm.alma_id)));


ALTER TABLE public.vw_prodstock OWNER TO postgres;

--
-- Name: vw_productosfarmaco; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_productosfarmaco AS
 SELECT laboratorio.lab_id,
    laboratorio.lab_desc,
    productos.prod_id,
    productos.prod_desc,
    productos.prod_precio,
    prod_farma.pfar_cant,
    farmacos.farma_id,
    farmacos.farma_desc
   FROM public.laboratorio,
    public.farmacos,
    public.prod_farma,
    public.productos
  WHERE ((laboratorio.lab_id = productos.lab_id) AND (productos.prod_id = prod_farma.prod_id) AND (prod_farma.farma_id = farmacos.farma_id));


ALTER TABLE public.vw_productosfarmaco OWNER TO postgres;

--
-- Name: almacenes alma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.almacenes ALTER COLUMN alma_id SET DEFAULT nextval('public.almacenes_alma_id_seq'::regclass);


--
-- Name: cajas caja_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cajas ALTER COLUMN caja_id SET DEFAULT nextval('public.cajas_caja_id_seq'::regclass);


--
-- Name: clientes cliente_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN cliente_id SET DEFAULT nextval('public.clientes_cliente_id_seq'::regclass);


--
-- Name: compras comp_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras ALTER COLUMN comp_id SET DEFAULT nextval('public.compras_comp_id_seq'::regclass);


--
-- Name: comprasdet cdet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comprasdet ALTER COLUMN cdet_id SET DEFAULT nextval('public.comprasdet_cdet_id_seq'::regclass);


--
-- Name: empleados emple_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados ALTER COLUMN emple_id SET DEFAULT nextval('public.empleados_emple_id_seq'::regclass);


--
-- Name: farmacos farma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmacos ALTER COLUMN farma_id SET DEFAULT nextval('public.farmacos_farma_id_seq'::regclass);


--
-- Name: gastos gast_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos ALTER COLUMN gast_id SET DEFAULT nextval('public.gastos_gast_id_seq'::regclass);


--
-- Name: laboratorio lab_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorio ALTER COLUMN lab_id SET DEFAULT nextval('public.laboratorio_lab_id_seq'::regclass);


--
-- Name: movtipo tmov_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movtipo ALTER COLUMN tmov_id SET DEFAULT nextval('public.movtipo_tmov_id_seq'::regclass);


--
-- Name: prod_farma pfar_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_farma ALTER COLUMN pfar_id SET DEFAULT nextval('public.prod_farma_pfar_id_seq'::regclass);


--
-- Name: prod_sectores psec_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_sectores ALTER COLUMN psec_id SET DEFAULT nextval('public.prod_sectores_psec_id_seq'::regclass);


--
-- Name: productos prod_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN prod_id SET DEFAULT nextval('public.productos_prod_id_seq'::regclass);


--
-- Name: proveedores prov_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN prov_id SET DEFAULT nextval('public.proveedores_prov_id_seq'::regclass);


--
-- Name: rubros rubro_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rubros ALTER COLUMN rubro_id SET DEFAULT nextval('public.rubros_rubro_id_seq'::regclass);


--
-- Name: sectores sect_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sectores ALTER COLUMN sect_id SET DEFAULT nextval('public.sectores_sect_id_seq'::regclass);


--
-- Name: stock lote_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock ALTER COLUMN lote_id SET DEFAULT nextval('public.stock_lote_id_seq'::regclass);


--
-- Name: tcajas tcaja_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tcajas ALTER COLUMN tcaja_id SET DEFAULT nextval('public.tcajas_tcaja_id_seq'::regclass);


--
-- Name: transcaja trcaja_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcaja ALTER COLUMN trcaja_id SET DEFAULT nextval('public.transcaja_trcaja_id_seq'::regclass);


--
-- Name: transdetalle transdet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transdetalle ALTER COLUMN transdet_id SET DEFAULT nextval('public.transdetalle_transdet_id_seq'::regclass);


--
-- Name: transferencias transf_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transferencias ALTER COLUMN transf_id SET DEFAULT nextval('public.transferencias_transf_id_seq'::regclass);


--
-- Name: ventas vent_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas ALTER COLUMN vent_id SET DEFAULT nextval('public.ventas_vent_id_seq'::regclass);


--
-- Name: ventasdet vdet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventasdet ALTER COLUMN vdet_id SET DEFAULT nextval('public.ventasdet_vdet_id_seq'::regclass);


--
-- Data for Name: almacenes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.almacenes VALUES (1, 'Deposito');
INSERT INTO public.almacenes VALUES (2, 'Local Centro');


--
-- Data for Name: cajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cajas VALUES (1, 1, 2, '2019-11-26', 100000, 'venta cliente 1', 1);
INSERT INTO public.cajas VALUES (2, 1, 2, '2019-11-26', 50000, 'venta cliente 2', 1);
INSERT INTO public.cajas VALUES (3, 1, 2, '2019-11-26', 35000, 'venta cliente 3', 1);
INSERT INTO public.cajas VALUES (4, 1, 2, '2019-11-26', 212000, 'venta cliente ', 1);
INSERT INTO public.cajas VALUES (5, 1, 2, '2019-11-26', 170000, 'venta cliente 1', 1);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.clientes VALUES (1, 'walter piris', '32432423', '423424', '234324234', '242342');
INSERT INTO public.clientes VALUES (2, 'mario segovia', '2566564556', '423424', '234324234', '987654');
INSERT INTO public.clientes VALUES (3, 'francisco alcaraz', '932928923', '423424', '234324234', '6790358');
INSERT INTO public.clientes VALUES (4, 'carlos carlos', '34234234-3', '-', '', '');
INSERT INTO public.clientes VALUES (5, 'MARCOS MARCANA', '232323', '-', '-', '');


--
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.compras VALUES (2, 1, 1, '2019-11-05', '3333', 1);


--
-- Data for Name: comprasdet; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.comprasdet VALUES (3, 1, 2, 10, 10000, 5);
INSERT INTO public.comprasdet VALUES (4, 2, 2, 10, 10000, 5);


--
-- Data for Name: empleados; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.empleados VALUES (1, 'tamara gonzalez', '4349071', '0975 633417', 'nva esperanza', ' tamaragonzalezrg4@gmail.com');
INSERT INTO public.empleados VALUES (2, ' enzo dure', '5511127', '0991 967000', 'quiteria', 'enzodure25@gmail.com');


--
-- Data for Name: farmacos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.farmacos VALUES (1, 'ibuprofeno');
INSERT INTO public.farmacos VALUES (2, 'BETAMETASONA');
INSERT INTO public.farmacos VALUES (3, 'GENTAMICINA');
INSERT INTO public.farmacos VALUES (4, 'MICONAZOL');


--
-- Data for Name: gastos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.gastos VALUES (1, 3, 'PAGO ANDE NOVIEMBRE', 350000, '2019-11-26');
INSERT INTO public.gastos VALUES (2, 3, 'PAGO COPACO NOVIEMBRE', 50000, '2019-11-26');
INSERT INTO public.gastos VALUES (3, 4, 'COMBUSTIBLE PARA REPARTO', 80000, '2019-11-26');


--
-- Data for Name: laboratorio; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.laboratorio VALUES (1, 'Lasca', 1);
INSERT INTO public.laboratorio VALUES (2, 'Indufar', 1);
INSERT INTO public.laboratorio VALUES (3, 'Bago', 1);
INSERT INTO public.laboratorio VALUES (4, 'Quimfa', 0);
INSERT INTO public.laboratorio VALUES (6, 'Braun', 0);


--
-- Data for Name: movtipo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.movtipo VALUES (1, 'COMPRAS', -1);
INSERT INTO public.movtipo VALUES (2, 'VENTAS', 1);
INSERT INTO public.movtipo VALUES (3, 'SERVICIOS', -1);
INSERT INTO public.movtipo VALUES (4, 'ALQUILERES', -1);
INSERT INTO public.movtipo VALUES (5, 'COMBUSTIBLE', -1);


--
-- Data for Name: prod_farma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.prod_farma VALUES (1, 1, 1, 400);
INSERT INTO public.prod_farma VALUES (2, 2, 2, 10);
INSERT INTO public.prod_farma VALUES (3, 2, 3, 4);
INSERT INTO public.prod_farma VALUES (4, 2, 4, 8);


--
-- Data for Name: prod_sectores; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.productos VALUES (1, 1, 1, 'kitadol forte', 10000, 1, 'kfc100');
INSERT INTO public.productos VALUES (2, 2, 1, 'hexacol', 30000, 1, 'hexa1223423');
INSERT INTO public.productos VALUES (3, 4, 2, 'One Million', 340000, 1, 'omillionasdda');


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.proveedores VALUES (1, 'lala laala', '242342342', '34324', NULL, NULL);


--
-- Data for Name: rubros; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rubros VALUES (1, 'medicamentos', 5);
INSERT INTO public.rubros VALUES (2, 'perfumes', 10);
INSERT INTO public.rubros VALUES (3, 'sdadasd', 2);


--
-- Data for Name: sectores; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.stock VALUES (3, 1, 1, 250, '3212-111', '2020-12-15', 'asdsad2123213123');
INSERT INTO public.stock VALUES (1, 1, 1, 20, '2244-333', '2018-12-15', 'asdsdafsdafasdfdasf');
INSERT INTO public.stock VALUES (2, 1, 1, 20, '2244-33343', '2019-12-30', 'asdsdafsdafasdfdasf');


--
-- Data for Name: tcajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tcajas VALUES (1, 'PRINCIPAL');


--
-- Data for Name: total; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.total VALUES (170000);


--
-- Data for Name: transcaja; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: transdetalle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: transferencias; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ventas VALUES (3, 1, 1, '2018-02-19', '234', 0, 1);
INSERT INTO public.ventas VALUES (4, 3, 2, '2018-02-19', '234', 0, 1);
INSERT INTO public.ventas VALUES (2, 2, 2, '2018-02-19', '234', 1, 1);
INSERT INTO public.ventas VALUES (1, 1, 1, '2018-02-19', '234', 1, 1);


--
-- Data for Name: ventasdet; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ventasdet VALUES (1, 1, 1, 3, 50000, 5);
INSERT INTO public.ventasdet VALUES (2, 2, 1, 2, 10000, 5);
INSERT INTO public.ventasdet VALUES (3, 3, 2, 13, 4000, 5);
INSERT INTO public.ventasdet VALUES (4, 2, 2, 20, 8000, 5);


--
-- Name: almacenes_alma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.almacenes_alma_id_seq', 2, true);


--
-- Name: cajas_caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cajas_caja_id_seq', 5, true);


--
-- Name: clientes_cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_cliente_id_seq', 5, true);


--
-- Name: compras_comp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compras_comp_id_seq', 2, true);


--
-- Name: comprasdet_cdet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comprasdet_cdet_id_seq', 4, true);


--
-- Name: empleados_emple_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleados_emple_id_seq', 2, true);


--
-- Name: farmacos_farma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farmacos_farma_id_seq', 4, true);


--
-- Name: gastos_gast_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gastos_gast_id_seq', 3, true);


--
-- Name: laboratorio_lab_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.laboratorio_lab_id_seq', 6, true);


--
-- Name: movtipo_tmov_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movtipo_tmov_id_seq', 5, true);


--
-- Name: prod_farma_pfar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prod_farma_pfar_id_seq', 5, true);


--
-- Name: prod_sectores_psec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prod_sectores_psec_id_seq', 1, false);


--
-- Name: productos_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_prod_id_seq', 3, true);


--
-- Name: proveedores_prov_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_prov_id_seq', 1, true);


--
-- Name: rubros_rubro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rubros_rubro_id_seq', 3, true);


--
-- Name: sectores_sect_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sectores_sect_id_seq', 1, false);


--
-- Name: stock_lote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_lote_id_seq', 3, true);


--
-- Name: tcajas_tcaja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tcajas_tcaja_id_seq', 1, true);


--
-- Name: transcaja_trcaja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transcaja_trcaja_id_seq', 1, false);


--
-- Name: transdetalle_transdet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transdetalle_transdet_id_seq', 1, false);


--
-- Name: transferencias_transf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transferencias_transf_id_seq', 1, false);


--
-- Name: ventas_vent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventas_vent_id_seq', 4, true);


--
-- Name: ventasdet_vdet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventasdet_vdet_id_seq', 4, true);


--
-- Name: almacenes pk_almacenes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.almacenes
    ADD CONSTRAINT pk_almacenes PRIMARY KEY (alma_id);


--
-- Name: cajas pk_cajas; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cajas
    ADD CONSTRAINT pk_cajas PRIMARY KEY (caja_id);


--
-- Name: clientes pk_clientes; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT pk_clientes PRIMARY KEY (cliente_id);


--
-- Name: compras pk_compras; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT pk_compras PRIMARY KEY (comp_id);


--
-- Name: comprasdet pk_comprasdet; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comprasdet
    ADD CONSTRAINT pk_comprasdet PRIMARY KEY (cdet_id);


--
-- Name: empleados pk_empleados; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT pk_empleados PRIMARY KEY (emple_id);


--
-- Name: farmacos pk_farmacos; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmacos
    ADD CONSTRAINT pk_farmacos PRIMARY KEY (farma_id);


--
-- Name: gastos pk_gastos; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT pk_gastos PRIMARY KEY (gast_id);


--
-- Name: laboratorio pk_laboratorio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorio
    ADD CONSTRAINT pk_laboratorio PRIMARY KEY (lab_id);


--
-- Name: movtipo pk_movtipo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movtipo
    ADD CONSTRAINT pk_movtipo PRIMARY KEY (tmov_id);


--
-- Name: prod_farma pk_prod_farma; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_farma
    ADD CONSTRAINT pk_prod_farma PRIMARY KEY (pfar_id);


--
-- Name: prod_sectores pk_prod_sectores; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_sectores
    ADD CONSTRAINT pk_prod_sectores PRIMARY KEY (psec_id);


--
-- Name: productos pk_productos; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT pk_productos PRIMARY KEY (prod_id);


--
-- Name: proveedores pk_proveedores; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT pk_proveedores PRIMARY KEY (prov_id);


--
-- Name: rubros pk_rubros; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rubros
    ADD CONSTRAINT pk_rubros PRIMARY KEY (rubro_id);


--
-- Name: sectores pk_sectores; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sectores
    ADD CONSTRAINT pk_sectores PRIMARY KEY (sect_id);


--
-- Name: stock pk_stock; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT pk_stock PRIMARY KEY (lote_id);


--
-- Name: tcajas pk_tcajas; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tcajas
    ADD CONSTRAINT pk_tcajas PRIMARY KEY (tcaja_id);


--
-- Name: transcaja pk_transcaja; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcaja
    ADD CONSTRAINT pk_transcaja PRIMARY KEY (trcaja_id);


--
-- Name: transdetalle pk_transdetalle; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transdetalle
    ADD CONSTRAINT pk_transdetalle PRIMARY KEY (transdet_id);


--
-- Name: transferencias pk_transferencias; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transferencias
    ADD CONSTRAINT pk_transferencias PRIMARY KEY (transf_id);


--
-- Name: ventas pk_ventas; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT pk_ventas PRIMARY KEY (vent_id);


--
-- Name: ventasdet pk_ventasdet; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventasdet
    ADD CONSTRAINT pk_ventasdet PRIMARY KEY (vdet_id);


--
-- Name: alma_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX alma_idx ON public.almacenes USING btree (alma_desc);


--
-- Name: caja_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX caja_idx ON public.cajas USING btree (caja_fecha);


--
-- Name: cliente_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX cliente_idx ON public.clientes USING btree (cliente_ruc);


--
-- Name: comdet_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX comdet_idx ON public.comprasdet USING btree (lote_id, comp_id);


--
-- Name: compras_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX compras_idx ON public.compras USING btree (prov_id, comp_nro);


--
-- Name: dtrans_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX dtrans_idx ON public.transdetalle USING btree (lote_id, transf_id);


--
-- Name: dventa_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX dventa_idx ON public.ventasdet USING btree (lote_id, vent_id);


--
-- Name: emple_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX emple_idx ON public.empleados USING btree (emple_ruc);


--
-- Name: farma_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX farma_idx ON public.farmacos USING btree (farma_desc);


--
-- Name: gast_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX gast_idx ON public.gastos USING btree (gast_fecha);


--
-- Name: lab_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lab_idx ON public.laboratorio USING btree (lab_desc);


--
-- Name: lote_bcode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lote_bcode ON public.stock USING btree (lote_bcode);


--
-- Name: lote_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX lote_idx ON public.stock USING btree (prod_id, alma_id, lote_desc);


--
-- Name: movtipo_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX movtipo_idx ON public.movtipo USING btree (tmov_desc, tmov_es);


--
-- Name: pbcode_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pbcode_idx ON public.productos USING btree (prod_bcode);


--
-- Name: pfarna_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pfarna_idx ON public.prod_farma USING btree (prod_id, farma_id);


--
-- Name: prodsec_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX prodsec_idx ON public.prod_sectores USING btree (sect_id, prod_id);


--
-- Name: prov_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX prov_idx ON public.proveedores USING btree (prov_ruc);


--
-- Name: rubros_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX rubros_idx ON public.rubros USING btree (rubro_desc);


--
-- Name: sect_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sect_idx ON public.sectores USING btree (alma_id, sect_desc);


--
-- Name: tcaja_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tcaja_idx ON public.tcajas USING btree (tcaja_desc);


--
-- Name: trans_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trans_idx ON public.transferencias USING btree (trans_fecha, transf_id);


--
-- Name: trcaja_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX trcaja_idx ON public.transcaja USING btree (trcaja_fecha);


--
-- Name: ventas_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ventas_idx ON public.ventas USING btree (vent_nro);


--
-- Name: ventas au_procesar_vent; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER au_procesar_vent AFTER UPDATE ON public.ventas FOR EACH ROW EXECUTE PROCEDURE public.au_venta_procesar();


--
-- Name: compras trg_au_compras; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_au_compras AFTER UPDATE ON public.compras FOR EACH ROW EXECUTE PROCEDURE public.au_compras();


--
-- Name: clientes trg_bi_cliente; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_bi_cliente BEFORE INSERT ON public.clientes FOR EACH ROW EXECUTE PROCEDURE public.bi_cliente();


--
-- Name: sectores fk_alma_a_sectores; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sectores
    ADD CONSTRAINT fk_alma_a_sectores FOREIGN KEY (alma_id) REFERENCES public.almacenes(alma_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: stock fk_alma_a_stock; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT fk_alma_a_stock FOREIGN KEY (alma_id) REFERENCES public.almacenes(alma_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: transcaja fk_caja_dest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcaja
    ADD CONSTRAINT fk_caja_dest FOREIGN KEY (trcaja_dest) REFERENCES public.tcajas(tcaja_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: transcaja fk_caja_orig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcaja
    ADD CONSTRAINT fk_caja_orig FOREIGN KEY (trcaja_ori) REFERENCES public.tcajas(tcaja_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: cajas fk_cajas_reference_movtipo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cajas
    ADD CONSTRAINT fk_cajas_reference_movtipo FOREIGN KEY (tmov_id) REFERENCES public.movtipo(tmov_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: cajas fk_cajas_reference_tcajas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cajas
    ADD CONSTRAINT fk_cajas_reference_tcajas FOREIGN KEY (tcaja_id) REFERENCES public.tcajas(tcaja_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: compras fk_compras_reference_empleado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_reference_empleado FOREIGN KEY (emple_id) REFERENCES public.empleados(emple_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: compras fk_compras_reference_proveedo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_reference_proveedo FOREIGN KEY (prov_id) REFERENCES public.proveedores(prov_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: comprasdet fk_comprasd_reference_compras; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comprasdet
    ADD CONSTRAINT fk_comprasd_reference_compras FOREIGN KEY (comp_id) REFERENCES public.compras(comp_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: comprasdet fk_comprasd_reference_stock; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comprasdet
    ADD CONSTRAINT fk_comprasd_reference_stock FOREIGN KEY (lote_id) REFERENCES public.stock(lote_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: prod_farma fk_farma_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_farma
    ADD CONSTRAINT fk_farma_prod FOREIGN KEY (farma_id) REFERENCES public.farmacos(farma_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: gastos fk_gastos_reference_movtipo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT fk_gastos_reference_movtipo FOREIGN KEY (tmov_id) REFERENCES public.movtipo(tmov_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: productos fk_prod_a_lab; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT fk_prod_a_lab FOREIGN KEY (lab_id) REFERENCES public.laboratorio(lab_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: stock fk_prod_a_stock; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT fk_prod_a_stock FOREIGN KEY (prod_id) REFERENCES public.productos(prod_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: prod_farma fk_prod_farma; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_farma
    ADD CONSTRAINT fk_prod_farma FOREIGN KEY (prod_id) REFERENCES public.productos(prod_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: prod_sectores fk_prod_sectores; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_sectores
    ADD CONSTRAINT fk_prod_sectores FOREIGN KEY (prod_id) REFERENCES public.productos(prod_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: productos fk_rubro_a_prods; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT fk_rubro_a_prods FOREIGN KEY (rubro_id) REFERENCES public.rubros(rubro_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: prod_sectores fk_sectores_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_sectores
    ADD CONSTRAINT fk_sectores_prod FOREIGN KEY (sect_id) REFERENCES public.sectores(sect_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: transdetalle fk_transdet_reference_stock; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transdetalle
    ADD CONSTRAINT fk_transdet_reference_stock FOREIGN KEY (lote_id) REFERENCES public.stock(lote_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: transdetalle fk_transdet_reference_transfer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transdetalle
    ADD CONSTRAINT fk_transdet_reference_transfer FOREIGN KEY (transf_id) REFERENCES public.transferencias(transf_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: transferencias fk_transfer_destino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transferencias
    ADD CONSTRAINT fk_transfer_destino FOREIGN KEY (trans_dest) REFERENCES public.almacenes(alma_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: transferencias fk_transfer_origen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transferencias
    ADD CONSTRAINT fk_transfer_origen FOREIGN KEY (trans_origen) REFERENCES public.almacenes(alma_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ventas fk_ventas_reference_clientes; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT fk_ventas_reference_clientes FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ventas fk_ventas_reference_empleado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT fk_ventas_reference_empleado FOREIGN KEY (emple_id) REFERENCES public.empleados(emple_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ventasdet fk_ventasde_reference_stock; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventasdet
    ADD CONSTRAINT fk_ventasde_reference_stock FOREIGN KEY (lote_id) REFERENCES public.stock(lote_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ventasdet fk_ventasde_reference_ventas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventasdet
    ADD CONSTRAINT fk_ventasde_reference_ventas FOREIGN KEY (vent_id) REFERENCES public.ventas(vent_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

