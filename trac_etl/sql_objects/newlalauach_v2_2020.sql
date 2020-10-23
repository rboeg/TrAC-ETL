--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.16
-- Dumped by pg_dump version 9.5.16

-- Started on 2020-05-25 09:41:19 CLT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
-- SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12623)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2462 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 181 (class 1259 OID 50943)
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    tags text DEFAULT ''::text NOT NULL,
    grading text NOT NULL,
    grade_min real NOT NULL,
    grade_max real NOT NULL,
    grade_pass_min real NOT NULL
);


ALTER TABLE public.course OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 50950)
-- Name: course_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_stats (
    course_taken text NOT NULL,
    year integer NOT NULL,
    term integer NOT NULL,
    p_group smallint NOT NULL,
    n_total bigint NOT NULL,
    n_finished bigint NOT NULL,
    n_pass bigint NOT NULL,
    n_fail bigint NOT NULL,
    n_drop bigint NOT NULL,
    histogram text NOT NULL,
    avg_grade real,
    n_grades integer NOT NULL,
    id bigint NOT NULL,
    histogram_labels text NOT NULL,
    color_bands text NOT NULL
);


ALTER TABLE public.course_stats OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 50956)
-- Name: parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parameter (
    passing_grade double precision,
    loading_date timestamp without time zone
);


ALTER TABLE public.parameter OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 50959)
-- Name: program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program (
    id text NOT NULL,
    name text NOT NULL,
    "desc" text NOT NULL,
    tags text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    last_gpa real DEFAULT 0.0
);


ALTER TABLE public.program OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 50967)
-- Name: program_structure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_structure (
    id bigint NOT NULL,
    program_id text NOT NULL,
    curriculum text NOT NULL,
    semester integer NOT NULL,
    course_id text NOT NULL,
    credits double precision NOT NULL,
    requisites text DEFAULT ''::text NOT NULL,
    mention text DEFAULT ''::text NOT NULL,
    course_cat text DEFAULT ''::text NOT NULL,
    mode text DEFAULT 'semestral'::text NOT NULL,
    credits_sct double precision NOT NULL,
    tags text DEFAULT ''::text NOT NULL,
    elective smallint DEFAULT 0
);


ALTER TABLE public.program_structure OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 50978)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id text NOT NULL,
    name text NOT NULL,
    state text NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 50984)
-- Name: student_course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_course (
    id bigint NOT NULL,
    year integer NOT NULL,
    term integer NOT NULL,
    student_id text NOT NULL,
    course_taken text NOT NULL,
    course_equiv text NOT NULL,
    elect_equiv text NOT NULL,
    registration text NOT NULL,
    state text NOT NULL,
    grade double precision NOT NULL,
    p_group smallint NOT NULL,
    comments text NOT NULL,
    instructors text NOT NULL,
    duplicates bigint NOT NULL
);


ALTER TABLE public.student_course OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 50990)
-- Name: student_dropout; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_dropout (
    student_id text NOT NULL,
    prob_dropout real,
    weight_per_semester text,
    active boolean DEFAULT false,
    model_accuracy real,
    explanation text
);


ALTER TABLE public.student_dropout OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 50997)
-- Name: student_program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_program (
    student_id text NOT NULL,
    program_id text NOT NULL,
    curriculum text NOT NULL,
    start_year integer NOT NULL,
    mention text NOT NULL,
    last_term integer NOT NULL,
    n_courses bigint NOT NULL,
    n_passed_courses bigint NOT NULL,
    completion real NOT NULL
);


ALTER TABLE public.student_program OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 51003)
-- Name: student_term; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_term (
    id bigint NOT NULL,
    student_id text NOT NULL,
    year integer NOT NULL,
    term integer NOT NULL,
    situation text NOT NULL,
    t_gpa double precision NOT NULL,
    c_gpa double precision NOT NULL,
    comments text DEFAULT ''::text NOT NULL,
    program_id text NOT NULL,
    curriculum text NOT NULL,
    start_year integer NOT NULL,
    mention text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.student_term OWNER TO postgres;

--
-- TOC entry 2444 (class 0 OID 50943)
-- Dependencies: 181
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2445 (class 0 OID 50950)
-- Dependencies: 182
-- Data for Name: course_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2446 (class 0 OID 50956)
-- Dependencies: 183
-- Data for Name: parameter; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2447 (class 0 OID 50959)
-- Dependencies: 184
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1748', 'INGENIERÍA MECÁNICA', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1799', 'PROGRAMA ESPECIAL SEGUNDA MENCIÓN', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1802', 'BIÓLOGO AMBIENTAL', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1809', 'PROG  ESPECIAL DE LICENCIATURA EN TURISMO', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1810', 'PROGRAMA ESPECIAL DE TITULACION INGENIERÍA DE EJECUCIÓN EN PESCA - INGENIERÍA PESQUERA - INGENIERÍA EN ACUICULTURA', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1833', 'ARTES MUSICALES Y SONORAS', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1834', 'DISEÑO', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1835', 'DERECHO (PTO. MONTT)', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1836', 'CREACIÓN AUDIOVISUAL', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1837', 'ARQUEOLOGÍA', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1838', 'ADMINISTRACIÓN PÚBLICA', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1839', 'INGENIERÍA AMBIENTAL', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1875', 'PROGRAMA ESPECIAL PARA PROFESIONALES O GRADUADOS CONDUCENTE AL TÍTULO DE INGENIERO CIVIL ELECTRÓNICO', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1876', 'PROGRAMA DE PROSECUCIÓN DE ESTUDIOS PARA INGENIEROS MECÁNICOS A TÍTULO DE INGENIERO CIVIL MECÁNICO', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1747', 'INGENIERÍA ELECTRÓNICA', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1783', 'INGENIERÍA EN MADERAS', '', '', true, 0);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1754', 'ADMINISTRACIÓN DE EMPRESAS DE TURISMO', '', '', true, 4.82999992);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1831', 'ADMINISTRACIÓN PÚBLICA (PM)', '', '', true, 4.90999985);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1700', 'AGRONOMÍA', '', '', true, 4.48999977);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1729', 'ANTROPOLOGÍA', '', '', true, 5.17000008);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1733', 'ARQUITECTURA', '', '', true, 4.6500001);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1703', 'AUDITORÍA', '', '', true, 4.67999983);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1812', 'BACHILLERATO EN CIENCIAS DE LA INGENIERÍA (COY)', '', '', true, 4.19000006);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1807', 'BACHILLERATO EN CIENCIAS DE LA INGENIERÍA PLAN COMÚN', '', '', true, 4.01999998);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1813', 'BACHILLERATO EN CIENCIAS Y RECURSOS NATURALES (COY)', '', '', true, 4.36000013);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1701', 'BIOLOGÍA MARINA', '', '', true, 4.40999985);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1702', 'BIOQUÍMICA', '', '', true, 4.57999992);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1782', 'DERECHO', '', '', true, 4.28999996);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1705', 'ENFERMERÍA', '', '', true, 5.44999981);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1825', 'ENFERMERÍA (P.M.)', '', '', true, 5.17999983);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1787', 'FONOAUDIOLOGÍA', '', '', true, 5.34000015);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1814', 'GEOGRAFÍA', '', '', true, 4.76999998);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1821', 'GEOLOGÍA', '', '', true, 4.90999985);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1730', 'INGENIERÍA CIVIL ACÚSTICA', '', '', true, 4.53000021);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1736', 'INGENIERÍA CIVIL ELECTRÓNICA', '', '', true, 4.30000019);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1708', 'INGENIERÍA CIVIL EN INFORMÁTICA', '', '', true, 4.30999994);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1704', 'INGENIERÍA CIVIL EN OBRAS CIVILES', '', '', true, 4.44000006);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1752', 'INGENIERÍA CIVIL INDUSTRIAL (P.M.)', '', '', true, 4.88999987);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1822', 'INGENIERÍA CIVIL INDUSTRIAL (VALDIVIA)', '', '', true, 4.86000013);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1779', 'INGENIERÍA CIVIL MECÁNICA', '', '', true, 4.48000002);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1709', 'INGENIERÍA COMERCIAL', '', '', true, 4.55999994);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1778', 'INGENIERÍA COMERCIAL (PM)', '', '', true, 4.73000002);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1758', 'INGENIERÍA EN ACUICULTURA', '', '', true, 4.6500001);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1753', 'INGENIERÍA EN ALIMENTOS', '', '', true, 4.44000006);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1759', 'INGENIERÍA EN COMPUTACIÓN', '', '', true, 4.61000013);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1775', 'INGENIERÍA EN CONSERVACIÓN DE RECURSOS NATURALES', '', '', true, 5.05999994);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1827', 'INGENIERÍA EN CONSERVACIÓN DE RECURSOS NATURALES - INGENIERÍA FORESTAL', '', '', true, 4.69999981);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1737', 'INGENIERÍA EN CONSTRUCCIÓN', '', '', true, 4.25);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1815', 'INGENIERÍA EN INFORMACIÓN Y CONTROL DE GESTIÓN', '', '', true, 4.82000017);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1710', 'INGENIERÍA FORESTAL', '', '', true, 4.5);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1740', 'INGENIERÍA NAVAL', '', '', true, 4.19000006);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1776', 'KINESIOLOGÍA', '', '', true, 5.26000023);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1765', 'LICENCIATURA EN ARTES VISUALES', '', '', true, 5.19999981);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1711', 'LICENCIATURA EN CIENCIAS BIOLÓGICAS', '', '', true, 4.44000006);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1816', 'LICENCIATURA EN CIENCIAS CON MENCIÓN', '', '', true, 4.38999987);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1713', 'MEDICINA', '', '', true, 6.11000013);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1731', 'MEDICINA (OS)', '', '', true, 6.03999996);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1714', 'MEDICINA VETERINARIA', '', '', true, 4.65999985);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1715', 'OBSTETRICIA Y PUERICULTURA', '', '', true, 5.17999983);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1789', 'ODONTOLOGÍA', '', '', true, 5.07999992);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1785', 'PEDAGOGÍA EN COMUNICACIÓN EN LENGUA INGLESA', '', '', true, 5.44000006);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1824', 'PEDAGOGÍA EN EDUCACIÓN BÁSICA CON MENCIONES (COY)', '', '', true, 5.11999989);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1823', 'PEDAGOGÍA EN EDUCACIÓN BÁSICA CON MENCIONES (PM)', '', '', true, 5.36000013);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1808', 'PEDAGOGÍA EN EDUCACIÓN DIFERENCIAL  CON MENCIÓN', '', '', true, 5.42000008);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1774', 'PEDAGOGÍA EN EDUCACIÓN FÍSICA, DEPORTES Y RECREACIÓN', '', '', true, 4.98999977);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1777', 'PEDAGOGÍA EN HISTORIA Y CIENCIAS SOCIALES', '', '', true, 4.94999981);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1784', 'PEDAGOGÍA EN LENGUAJE Y COMUNICACIÓN', '', '', true, 5.25);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1811', 'PEDAGOGÍA EN MATEMÁTICAS', '', '', true, 5.07000017);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1756', 'PERIODISMO', '', '', true, 4.98000002);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1757', 'PROGRAMA DE FORMACIÓN PEDAGÓGICA PARA PROFESIONALES  Y/O  LICENCIADOS EN CIENCIAS DE LA NATURALEZA', '', '', true, 6.32999992);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1806', 'PROGRAMA DE FORMACIÓN PEDAGÓGICA PARA PROFESIONALES Y/O LICENCIADOS EN ARTES VISUALES', '', '', true, 6.44999981);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1772', 'PROGRAMA ESPECIAL DE PREGRADO DE INTERCAMBIO', '', '', true, 5.44999981);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1770', 'PROGRAMA EXTRAORDINARIO DE PREGRADO', '', '', true, 4.48999977);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1788', 'PSICOLOGÍA', '', '', true, 5.07000017);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1826', 'PSICOLOGÍA (VALD)', '', '', true, 5.36999989);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1734', 'QUÍMICA Y FARMACIA', '', '', true, 4.73999977);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1820', 'TÉCNICO UNIVERSITARIO ASISTENTE EJECUTIVO Y DE GESTIÓN', '', '', true, 5.71999979);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1819', 'TÉCNICO UNIVERSITARIO EN ADMINISTRACIÓN CONTABLE Y FINANCIERA', '', '', true, 5.26000023);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1817', 'TÉCNICO UNIVERSITARIO EN CONSTRUCCIÓN Y OBRAS CIVILES', '', '', true, 4.98999977);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1829', 'TÉCNICO UNIVERSITARIO EN MANTENIMIENTO INDUSTRIAL', '', '', true, 5.19999981);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1830', 'TÉCNICO UNIVERSITARIO EN PRODUCCIÓN AGROPECUARIA', '', '', true, 4.48000002);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1818', 'TÉCNICO UNIVERSITARIO EN SALMONICULTURA', '', '', true, 4.82999992);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1828', 'TÉCNICO UNIVERSITARIO EN TURISMO DE NATURALEZA', '', '', true, 4.76000023);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1728', 'TECNOLOGÍA MÉDICA', '', '', true, 5.01000023);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1786', 'TECNOLOGÍA MÉDICA (PM)', '', '', true, 4.98999977);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1732', 'TERAPIA OCUPACIONAL', '', '', true, 5.42000008);
INSERT INTO public.program (id, name, "desc", tags, active, last_gpa) VALUES ('1832', 'TERAPIA OCUPACIONAL (PM)', '', '', true, 5.03000021);


--
-- TOC entry 2448 (class 0 OID 50967)
-- Dependencies: 185
-- Data for Name: program_structure; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2449 (class 0 OID 50978)
-- Dependencies: 186
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2450 (class 0 OID 50984)
-- Dependencies: 187
-- Data for Name: student_course; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2451 (class 0 OID 50990)
-- Dependencies: 188
-- Data for Name: student_dropout; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2452 (class 0 OID 50997)
-- Dependencies: 189
-- Data for Name: student_program; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2453 (class 0 OID 51003)
-- Dependencies: 190
-- Data for Name: student_term; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2302 (class 2606 OID 51012)
-- Name: a_course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT a_course_pkey PRIMARY KEY (id);


--
-- TOC entry 2304 (class 2606 OID 51014)
-- Name: a_course_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_stats
    ADD CONSTRAINT a_course_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 2327 (class 2606 OID 51016)
-- Name: a_student_term_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_term
    ADD CONSTRAINT a_student_term_pkey PRIMARY KEY (id);


--
-- TOC entry 2307 (class 2606 OID 51018)
-- Name: program_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);


--
-- TOC entry 2310 (class 2606 OID 51020)
-- Name: program_structure_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_structure
    ADD CONSTRAINT program_structure_pkey PRIMARY KEY (id);


--
-- TOC entry 2312 (class 2606 OID 51022)
-- Name: program_structure_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_structure
    ADD CONSTRAINT program_structure_unique UNIQUE (program_id, curriculum, semester, course_id, mention);


--
-- TOC entry 2318 (class 2606 OID 51024)
-- Name: student_course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_course
    ADD CONSTRAINT student_course_pkey PRIMARY KEY (id);


--
-- TOC entry 2322 (class 2606 OID 51026)
-- Name: student_dropout_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_dropout
    ADD CONSTRAINT student_dropout_pk PRIMARY KEY (student_id);


--
-- TOC entry 2314 (class 2606 OID 51028)
-- Name: student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- TOC entry 2325 (class 2606 OID 51030)
-- Name: student_program_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_program
    ADD CONSTRAINT student_program_pkey PRIMARY KEY (student_id, program_id, curriculum);


--
-- TOC entry 2320 (class 2606 OID 51032)
-- Name: unique_sc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_course
    ADD CONSTRAINT unique_sc UNIQUE (year, term, student_id, course_taken);


--
-- TOC entry 2305 (class 1259 OID 51033)
-- Name: idx_course_stat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_stat ON public.course_stats USING btree (course_taken);


--
-- TOC entry 2308 (class 1259 OID 51034)
-- Name: idx_ps_pm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ps_pm ON public.program_structure USING btree (program_id, curriculum);


--
-- TOC entry 2315 (class 1259 OID 51035)
-- Name: idx_sc_course; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sc_course ON public.student_course USING btree (course_taken);


--
-- TOC entry 2316 (class 1259 OID 51036)
-- Name: idx_sc_student; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sc_student ON public.student_course USING btree (student_id);


--
-- TOC entry 2323 (class 1259 OID 51037)
-- Name: idx_sp_p; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sp_p ON public.student_program USING btree (program_id);


--
-- TOC entry 2328 (class 1259 OID 51038)
-- Name: st_idx_program; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX st_idx_program ON public.student_term USING btree (program_id);


--
-- TOC entry 2329 (class 1259 OID 51039)
-- Name: st_idx_student; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX st_idx_student ON public.student_term USING btree (student_id);


--
-- TOC entry 2461 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2020-05-25 09:41:19 CLT

--
-- PostgreSQL database dump complete
--
