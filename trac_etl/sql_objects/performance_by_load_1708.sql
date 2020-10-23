DROP TABLE IF EXISTS public.performance_by_load;

CREATE TABLE public.performance_by_load (
	"program_id" text NOT NULL,
	"student_cluster" int2 NOT NULL,
	"courseload_unit" text NOT NULL,
	"courseload_lb" int4 NOT NULL,
	"courseload_ub" int4 NOT NULL,
	"hp_count" int8 NOT NULL,
	"mp_count" int8 NOT NULL,
	"lp_count" int8 NOT NULL,
	"n_total" float4 NOT NULL,
	"id" int4 NOT NULL,
	"hp_value" float4 NOT NULL,
	"mp_value" float4 NOT NULL,
	"lp_value" float4 NOT NULL,
	"message_title" text NOT NULL,
	"message_text" text NOT NULL,
	"cluster_label" text NOT NULL,
	"courseload_label" text NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE public.performance_by_load OWNER TO "postgres";

ALTER TABLE public.performance_by_load
    ADD CONSTRAINT "x_perf_by_load_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;

INSERT INTO "performance_by_load" VALUES ('1708', '1', 'credits', '0', '20', '94', '86', '237', '417', '1000', '0.23', '0.21', '0.56', '¡Tu carga de estudio no es alta!', 'Sólo un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado dos o más.', 'pga <= 4.38', 'baja');
INSERT INTO "performance_by_load" VALUES ('1708', '2', 'credits', '0', '20', '119', '97', '85', '301', '1001', '0.4', '0.32', '0.28', '¡Tu carga de estudio parece algo baja!', 'Un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y sólo <HighFailRate /> han reprobado más de uno.', '4.38 < pga <= 4.82', 'baja');
INSERT INTO "performance_by_load" VALUES ('1708', '3', 'credits', '0', '20', '183', '59', '35', '277', '1002', '0.66', '0.21', '0.13', '¡Tu carga de estudio parece algo baja!', 'Un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y sólo <HighFailRate /> han reprobado más de uno.', 'pga > 4.82', 'baja');
INSERT INTO "performance_by_load" VALUES ('1708', '1', 'credits', '21', '26', '52', '74', '378', '504', '1003', '0.1', '0.15', '0.75', '¡Tu carga planeada parece moderada!', 'Sólo un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', 'pga <= 4.38', 'moderada');
INSERT INTO "performance_by_load" VALUES ('1708', '2', 'credits', '21', '26', '121', '122', '225', '468', '1004', '0.26', '0.26', '0.48', '¡Tu carga planeada parece moderada!', 'Sólo un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', '4.38 < pga <= 4.82', 'moderada');
INSERT INTO "performance_by_load" VALUES ('1708', '3', 'credits', '21', '26', '284', '97', '89', '470', '1005', '0.6', '0.21', '0.19', '¡Tu carga planeada parece moderada!', 'Un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', 'pga > 4.82', 'moderada');
INSERT INTO "performance_by_load" VALUES ('1708', '1', 'credits', '27', '30', '23', '13', '134', '170', '1006', '0.14', '0.08', '0.78', '¡Tu carga de estudio es alta!', 'Sólo un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', 'pga <= 4.38', 'alta');
INSERT INTO "performance_by_load" VALUES ('1708', '2', 'credits', '27', '30', '81', '72', '143', '296', '1007', '0.27', '0.24', '0.49', '¡Tu carga de estudio es alta!', 'Sólo un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', '4.38 < pga <= 4.82', 'alta');
INSERT INTO "performance_by_load" VALUES ('1708', '3', 'credits', '27', '30', '305', '85', '90', '480', '1008', '0.64', '0.18', '0.18', '¡Tu carga de estudio es alta!', 'Un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', 'pga > 4.82', 'alta');
INSERT INTO "performance_by_load" VALUES ('1708', '1', 'credits', '31', '9999', '29', '31', '250', '310', '1009', '0.09', '0.1', '0.81', '¡Tu carga de estudio es muy alta!', 'Sólo un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', 'pga <= 4.38', 'muy alta');
INSERT INTO "performance_by_load" VALUES ('1708', '2', 'credits', '31', '9999', '117', '77', '166', '360', '1010', '0.33', '0.21', '0.46', '¡Tu carga de estudio es muy alta!', 'Sólo un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', '4.38 < pga <= 4.82', 'muy alta');
INSERT INTO "performance_by_load" VALUES ('1708', '3', 'credits', '31', '9999', '469', '110', '88', '667', '1011', '0.7', '0.16', '0.14', '¡Tu carga de estudio es muy alta!', 'Un <LowFailRate /> de estudiantes con promedios similares al tuyo que han tomado una carga similar han pasado todos los cursos. Un <MidFailRate /> de ellos han reprobado 1 curso, y <HighFailRate /> han reprobado más de uno.', 'pga > 4.82', 'muy alta');
