DROP TABLE IF EXISTS "public"."xmalla";

CREATE TABLE IF NOT EXISTS "public"."xmalla" (
	"id" serial NOT NULL,
	"asignatura_codigo" varchar(255) NOT NULL,
	"asignatura_nombre" varchar(255) NOT NULL,
  "asignatura_desc" text NOT NULL,
	"asignatura_creditos" int4 NOT NULL,
	"asignatura_creditos_sct" int4 NOT NULL,
  "program_id" varchar(255) NOT NULL,
  "program_name" varchar(255) NOT NULL,
  "malla_id" int4 NOT NULL,
  "malla_agno" int4 NOT NULL,
  "semestre" int4 NOT NULL,
	"requisito" text NOT NULL,
  "ciclo" varchar(255) NOT NULL,
	"linea_o_area" varchar(255) NOT NULL,
	"optativo" int4 NOT NULL,
	"mencion" varchar(255) NOT NULL,
  dummy varchar DEFAULT NULL,
	CONSTRAINT "malla_curricular2_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE
  )
  WITH (OIDS=FALSE);

DROP TABLE IF EXISTS public.xsituacion_semestral;

CREATE TABLE IF NOT EXISTS public.xsituacion_semestral (
  id serial NOT NULL,
	estudiante varchar(255) NOT NULL,
	agno int4 NOT NULL,
	semestre int4 NOT NULL,
	psp float4 NOT NULL,
	pga float4 NOT NULL,
	pga_carrera int4 NOT NULL,
	cod_carrera int4 NOT NULL,
  carrera varchar(255) NOT NULL,
	malla_actual int4 NOT NULL,
	agno_ingreso int4 NOT NULL,
	situacion_semestre varchar(255) NOT NULL,
	reincorporaciones int4 NOT NULL,
	mencion varchar(255) NOT NULL,
  dummy varchar DEFAULT NULL,
	CONSTRAINT xsituacion_semestral_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS public.xcursadas;

CREATE TABLE IF NOT EXISTS public.xcursadas (
  id bigserial NOT NULL,
	estudiante varchar(255) NOT NULL,
	asignatura varchar(255) NOT NULL,
	asignatura_equivalente varchar(255) NOT NULL,
	agno int4 NOT NULL,
	semestre int4 NOT NULL,
	concepto varchar(255) NOT NULL,
	calificacion float4 NOT NULL,
	situacion varchar(255) NOT NULL,
	responsable varchar(1000) NOT NULL,
	cod_carrera varchar(255) NOT NULL,
	malla_id varchar(255) NOT NULL,
	grupo_paralelo int4 NOT NULL,
	electivo_equivalente varchar(255) NOT NULL,
  dummy varchar DEFAULT NULL,
	CONSTRAINT xcursadas_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS public.inscritas2020;

CREATE TABLE IF NOT EXISTS public.inscritas2020 (
	id serial NOT NULL,
	estudiante varchar(255) NOT NULL,
	asignatura varchar(255) NOT NULL,
	asignatura_equivalente varchar(255) NOT NULL,
	agno int4 NOT NULL,
	semestre int4 NOT NULL,
	responsable varchar(1024) NOT NULL,
	cod_carrera varchar(255) NOT NULL,
	malla_id varchar(255) NOT NULL,
	grupo_paralelo int4 NOT NULL,
	electivo_equivalente varchar(255) NOT NULL,
	dummy varchar DEFAULT NULL,
	CONSTRAINT inscritas2020_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS public.student_cluster;

CREATE TABLE IF NOT EXISTS public.student_cluster (
	student_id text NOT NULL,
	program_id text NOT NULL,
	last_cgpa float4,
	cluster int2
);

ALTER TABLE public.student_cluster ADD CONSTRAINT "student_cluster_pkey" PRIMARY KEY ("student_id", "program_id") NOT DEFERRABLE INITIALLY IMMEDIATE;
