# -*- coding: utf-8 -*-
import trac_etl.globals as globals
from trac_etl.db_config import config
import os
from shutil import copy2
import psycopg2

def test_connect():
    conn = None
    try:
        # read connection parameters
        # conf_file = os.path.join(os.path.dirname(os.path.dirname(__file__)),'trac_etl/database.ini')
        # params = config(filename=conf_file)

        print('\nConnecting to the PostgreSQL database...')
        # conn = psycopg2.connect(**params)
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)

        # create a cursor
        cur = conn.cursor()
        cur.execute('SELECT version();')

        # display the PostgreSQL database server version
        db_version = cur.fetchone()
        print('Connected to '+globals.dest_db_name+' on ', end = '')
        print(db_version)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def create_db_main_objects():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute(open(os.path.join(os.path.dirname(os.path.dirname(__file__)),'trac_etl/sql_objects/newlalauach_v2_2020.sql'), "r").read())
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def create_db_aux_objects():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute('TRUNCATE public."parameter";')
        cur.execute('INSERT INTO public."parameter" (passing_grade, loading_date) VALUES(4, NOW());')
        cur.execute(open(os.path.join(os.path.dirname(os.path.dirname(__file__)),'trac_etl/sql_objects/trac_etl.sql'), "r").read())
        cur.execute(open(os.path.join(os.path.dirname(os.path.dirname(__file__)),'trac_etl/sql_objects/performance_by_load_1708.sql'), "r").read())
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def csv_to_xmalla(csv):
    conn = None
    try:
        file_name = csv.split('/')[-1]
        copy2(csv, '/tmp/'+file_name)

        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.xmalla;")
        cur.execute("ALTER SEQUENCE public.xmalla_id_seq RESTART WITH 1;")
        cur.execute("COPY public.xmalla (asignatura_codigo,asignatura_nombre,asignatura_desc,asignatura_creditos,"+
        "asignatura_creditos_sct,program_id,program_name,malla_id,malla_agno,semestre,requisito,ciclo,linea_o_area,optativo,mencion,dummy) " +
        "FROM '" + "/tmp/" + file_name + "' " +
        "DELIMITER ',' " +
        "CSV HEADER;")
        cur.execute("UPDATE public.xmalla "+
        "SET asignatura_codigo=TRIM(asignatura_codigo), asignatura_nombre=TRIM(asignatura_nombre), asignatura_desc=TRIM(asignatura_nombre), "+
        "program_id=TRIM(program_id), program_name=TRIM(program_name), requisito=TRIM(requisito), ciclo=TRIM(ciclo), "+
        "linea_o_area=TRIM(linea_o_area), mencion=TRIM(mencion) "+
        "WHERE TRUE;")

        cur.close()
        os.remove('/tmp/'+file_name)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_program_structure():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.program_structure;")
        cur.execute("INSERT INTO public.program_structure (id, program_id, curriculum, semester, course_id, credits, requisites, mention, course_cat, mode, credits_sct, tags, elective)  " +
        "SELECT id, TRIM(program_id) AS program_id, malla_id, semestre, TRIM(asignatura_codigo) AS asignatura_codigo, "+
        "asignatura_creditos, TRIM(requisito) AS requisito, TRIM(mencion) AS mencion, TRIM(ciclo) AS ciclo, " +
        "CASE WHEN semestre=0 THEN 'anual' ELSE 'semestral' END AS mode, asignatura_creditos_sct, TRIM(linea_o_area) AS linea_o_area, optativo " +
        "FROM public.xmalla ORDER  BY program_id, malla_id, semestre, asignatura_codigo; ")

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_course():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.course;")
        cur.execute("INSERT INTO public.course (id,name,description,grading,grade_min,grade_max,grade_pass_min) "+
        "SELECT TRIM(asignatura_codigo) AS asignatura_codigo, TRIM(asignatura_nombre) AS asignatura_nombre, TRIM(asignatura_desc) AS asignatura_desc,'scale',1,7,4 " +
        "FROM public.xmalla group by asignatura_codigo, asignatura_nombre, asignatura_desc;")

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def csv_to_xsituac_sem(csv):
    conn = None
    try:
        file_name = csv.split('/')[-1]
        copy2(csv, '/tmp/'+file_name)

        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.xsituacion_semestral;")
        cur.execute("ALTER SEQUENCE public.xsituacion_semestral_id_seq RESTART WITH 1;")
        cur.execute("COPY public.xsituacion_semestral (estudiante, agno, semestre, psp, pga, pga_carrera, cod_carrera, carrera, malla_actual, agno_ingreso, situacion_semestre, reincorporaciones, mencion, dummy) " +
        "FROM '" + "/tmp/" + file_name + "' " +
        "DELIMITER ',' " +
        "CSV HEADER;")

        cur.execute("UPDATE public.xsituacion_semestral " +
        "SET estudiante=TRIM(estudiante), carrera=TRIM(carrera), situacion_semestre=TRIM(situacion_semestre), mencion=TRIM(mencion) " +
        "WHERE TRUE;")

        cur.close()
        os.remove('/tmp/'+file_name)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_student_term():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.student_term;")
        cur.execute("INSERT INTO public.student_term (id,student_id,year,term,situation,t_gpa,c_gpa, "+
        "comments,program_id,curriculum,start_year,mention) "+
        "SELECT id, TRIM(estudiante) AS estudiante, agno, semestre, TRIM(situacion_semestre) AS situacion_semestre, ROUND(psp::numeric,2), ROUND(pga::numeric,2), "+
		"reincorporaciones, cod_carrera, malla_actual, agno_ingreso, TRIM(mencion) AS mencion "+
        "FROM xsituacion_semestral order by id; ")

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def upd_student_term_comm():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        query = """
UPDATE student_term
SET    comments = 'ELIM-REINC'
WHERE  situation = 'ELIMINADO'
       AND ( comments = '1'
              OR comments = '2'
              OR comments = '3'
              OR comments = '4'
              OR comments = '5' );

UPDATE student_term
SET    comments = 'ELIMINADO'
WHERE  situation = 'ELIMINADO'
       AND comments = '0';

UPDATE student_term
SET    comments = 'PENDIENTE'
WHERE  situation = 'PENDIENTE';

UPDATE student_term
SET    comments = 'EGRESADO'
WHERE  situation = 'EGRESADO';

UPDATE student_term
SET    comments = 'REINCORP'
WHERE  comments = '1';

UPDATE student_term
SET    comments = 'CONDICIONAL'
WHERE  situation = 'CONDICIONAL'
       AND comments = '0';

UPDATE student_term
SET    comments = 'CONDICIONAL-REINC'
WHERE  situation = 'CONDICIONAL'
       AND ( comments = '1'
              OR comments = '2'
              OR comments = '3'
              OR comments = '4'
              OR comments = '5' );

UPDATE student_term
SET    comments = 'REPITENTE'
WHERE  situation = 'REPITENTE';

UPDATE student_term
SET    comments = 'REGULAR-REINC'
WHERE  situation = 'REGULAR'
       AND ( comments = '1'
              OR comments = '2'
              OR comments = '3'
              OR comments = '4'
              OR comments = '5' );

UPDATE student_term
SET    comments = ''
WHERE  comments = '0';
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def csv_to_xcursadas(csv, truncate=False):
    conn = None
    try:
        file_name = csv.split('/')[-1]
        copy2(csv, '/tmp/'+file_name)

        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        if truncate:
            cur.execute("TRUNCATE public.xcursadas;")
            cur.execute("ALTER SEQUENCE public.xcursadas_id_seq RESTART WITH 1;")
        cur.execute("COPY public.xcursadas (estudiante,asignatura,asignatura_equivalente,agno,semestre,concepto,calificacion," +
        "situacion,responsable,cod_carrera,malla_id,grupo_paralelo,electivo_equivalente,dummy) " +
        "FROM '" + "/tmp/" + file_name + "' " +
        "DELIMITER ',' " +
        "CSV HEADER;")

        cur.execute("UPDATE public.xcursadas " +
        "SET estudiante=TRIM(estudiante), asignatura=TRIM(asignatura), asignatura_equivalente=TRIM(asignatura_equivalente), concepto=TRIM(concepto), " +
        "situacion=TRIM(situacion), responsable=TRIM(responsable), cod_carrera=TRIM(cod_carrera), malla_id=TRIM(malla_id), electivo_equivalente=TRIM(electivo_equivalente) " +
        "WHERE TRUE;")

        cur.close()
        os.remove('/tmp/'+file_name)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_student_course():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        query = """
INSERT INTO student_course
        (id,
        year,
        term,
        student_id,
        course_taken,
        course_equiv,
        elect_equiv,
        registration,
        state,
        grade,
        p_group,
        comments,
        instructors,
        duplicates)
SELECT   Max(id),
         agno,
         semestre,
         TRIM(estudiante) AS estudiante,
         TRIM(asignatura) AS asignatura,
         Max(asignatura_equivalente) AS course_equiv,
         Max(electivo_equivalente)   AS elect_equiv,
         String_agg("concepto",',')    AS registration,
         Min(situacion)                AS state,
         Round(Max(calificacion)::numeric,2) AS grade,
         Max(grupo_paralelo)           AS p_group,
         String_agg(cod_carrera,',')   AS comments,
         ''                            AS instructors,
         Count(*)                      AS duplicates
FROM     xcursadas
GROUP BY TRIM(estudiante), TRIM(asignatura), agno, semestre
ORDER BY agno,
         semestre,
         asignatura,
         estudiante ASC
        """
        cur.execute("TRUNCATE public.student_course;")
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def upd_student_course_grade():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("UPDATE student_course SET grade = round(grade::numeric,2); ")

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def cre_ins_xstudent_program():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("DROP TABLE IF EXISTS xstudent_program;")
        query = """
CREATE TABLE public.xstudent_program AS
SELECT   TRIM(student_id) AS student_id,
         TRIM(program_id) AS program_id,
         TRIM(curriculum) AS curriculum,
         Max(start_year)   AS start_year,
         Max(mention)      AS mention,
         Max(year*10+term) AS last_term,
         0.0               AS program_completion
FROM     student_term
GROUP BY TRIM(student_id), TRIM(program_id), TRIM(curriculum)
ORDER BY program_id,
         curriculum,
         student_id ASC
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def cre_ins_xtemp_sc():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("DROP TABLE IF EXISTS public.xtemp_sc;")
        query = """
DROP INDEX IF EXISTS xstudent_program_student_id_idx;
DROP INDEX IF EXISTS xstudent_program_program_id_idx;
DROP INDEX IF EXISTS xstudent_program_curriculum_idx;

CREATE INDEX xstudent_program_student_id_idx ON public.xstudent_program (student_id);
CREATE INDEX xstudent_program_program_id_idx ON public.xstudent_program (program_id);
CREATE INDEX xstudent_program_curriculum_idx ON public.xstudent_program (curriculum);

/*
DROP INDEX IF EXISTS program_structure_program_id_idx;
DROP INDEX IF EXISTS program_structure_curriculum_idx;

CREATE INDEX program_structure_program_id_idx ON public.program_structure (program_id);
CREATE INDEX program_structure_curriculum_idx ON public.program_structure (curriculum);
*/

/************************************/

CREATE TABLE public.xtemp_sc AS

SELECT student_id,
       program_id,
       curriculum,
       start_year,
       mention,
       last_term,
       course_id,
       SUM(passed) AS passed FROM (

SELECT TRIM(SP.student_id) AS student_id,
       TRIM(SP.program_id) AS program_id,
       TRIM(SP.curriculum) AS curriculum,
       SP.start_year,
       TRIM(SP.mention) AS mention,
       SP.last_term,
       TRIM(PS.course_id) AS course_id,
       CASE
        WHEN SC.state = 'A' AND (TRIM(SC.course_taken) = TRIM(PS.course_id)
                       OR TRIM(SC.course_equiv) = TRIM(PS.course_id)
                       OR TRIM(SC.elect_equiv) = TRIM(PS.course_id)) THEN 1
        ELSE 0
        END
        AS passed
FROM   xstudent_program SP

LEFT JOIN program_structure PS ON (TRIM(PS.program_id) = TRIM(SP.program_id) AND TRIM(PS.curriculum) = TRIM(SP.curriculum) AND TRIM(PS.mention) = TRIM(SP.mention))
LEFT JOIN student_course SC ON (TRIM(SP.student_id) = TRIM(SC.student_id) AND (TRIM(PS.course_id) = TRIM(SC.course_taken) OR TRIM(PS.course_id) = TRIM(SC.course_equiv) OR TRIM(PS.course_id) = TRIM(SC.elect_equiv)))
ORDER  BY SC.id, SP.program_id,
          SP.curriculum,
          SP.student_id,
          PS.course_id ASC

) XSP
GROUP BY student_id,
       program_id,
       curriculum,
       start_year,
       mention,
       last_term,
       course_id;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_student():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.student;")
        query = """
INSERT INTO student
    ("id",
     "name",
     "state")
SELECT DISTINCT( TRIM(student_id) ),
       '',
       'active'
FROM   student_program;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_student_program():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.student_program;")
        query = """
INSERT INTO public.student_program
SELECT tsc.*,

CASE WHEN n_courses > 0 THEN round((1.0*n_passed_courses/n_courses)::NUMERIC, 2) ELSE 0 END
AS completion

FROM
(SELECT  TRIM(student_id) AS student_id,
        TRIM(program_id) AS program_id,
        TRIM(curriculum) AS curriculum,
        start_year,
        TRIM(mention) AS mention,
        last_term,
        count(*) AS n_courses,
        count(*) filter (WHERE passed > 0) AS n_passed_courses
FROM     xtemp_sc
GROUP BY TRIM(student_id), TRIM(program_id), TRIM(curriculum), start_year, TRIM(mention), last_term
ORDER BY program_id,
         curriculum,
         student_id ) tsc
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_course_stats_parallel_group(truncate=False):
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        if truncate:
            cur.execute("TRUNCATE public.course_stats;")
        query = """
INSERT INTO course_stats
    (id,
    course_taken,
    year,
    term,
    p_group,
    n_total,
    n_finished,
    n_pass,
    n_fail,
    n_drop,
    histogram,
    n_grades,
    avg_grade,
    histogram_labels,
    color_bands)
SELECT   Row_number() over (ORDER BY course_taken, year, term, p_group),
         course_taken,
         year,
         term,
         p_group,
         count(*) AS n_total,
         count(*) filter (WHERE state = 'A' OR state = 'R') AS n_finished,
         count(*) filter (WHERE state = 'A') AS n_pass,
         count(*) filter (WHERE state = 'R') AS n_fail,
         count(*) filter (WHERE state = 'N') AS n_drop,

         concat('', count(*) filter (WHERE grade >= 1 AND grade < 2) , ',',
         count(*) filter (WHERE grade >= 2 AND grade < 3) , ',',
         count(*) filter (WHERE grade >= 3 AND grade < 4) , ',',
         count(*) filter (WHERE grade >= 4 AND grade < 5) , ',',
         count(*) filter (WHERE grade >= 5 AND grade < 6) , ',',
         count(*) filter (WHERE grade >= 6 AND grade <= 7) ) AS histogram,
         count(*) filter (WHERE grade >= 1 AND grade <= 7) AS n_grades,
         round( ( avg(grade) filter (WHERE grade >= 1 AND grade <= 7) )::NUMERIC, 2) AS avg_grade,
         '1-2,2-3,3-4,4-5,5-6,6-7' AS histogram_labels,
         '1.0,3.4999,#d6604d;3.5,3.9999,#f48873;4.0,4.4999,#a7dc78;4.5,7,#66b43e' AS color_bands
FROM     student_course
WHERE    state IN ('A',
                   'R',
                   'N')
         AND (registration = 'CURSADA'
                 OR registration LIKE '%CURSADA'
                 OR registration = 'ANULADA'
                 OR registration= 'CAMBIO PLAN'
                 OR registration LIKE '%ANULADA')
GROUP BY course_taken,
         year,
         term,
         p_group;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_course_stats_course(truncate=False):
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        if truncate:
            cur.execute("TRUNCATE public.course_stats;")
        query = """
INSERT INTO course_stats
    (id,
    course_taken,
    year,
    term,
    p_group,
    n_total,
    n_finished,
    n_pass,
    n_fail,
    n_drop,
    histogram,
    n_grades,
    avg_grade,
    histogram_labels,
    color_bands)
SELECT   100000 + Row_number() over (ORDER BY course_taken),
     course_taken,
     -1,
     -1,
     -1,
     count(*) AS n_total,
     count(*) filter (WHERE state = 'A' OR state = 'R') AS n_finished,
     count(*) filter (WHERE state = 'A') AS n_pass,
     count(*) filter (WHERE state = 'R') AS n_fail,
     count(*) filter (WHERE state = 'N') AS n_drop,
     concat('', count(*) filter (WHERE grade >= 1 AND grade < 2) , ',',
     count(*) filter (WHERE grade >= 2 AND grade < 3) , ',',
     count(*) filter (WHERE grade >= 3 AND grade < 4) , ',',
     count(*) filter (WHERE grade >= 4
AND      grade < 5) , ',', count(*) filter (WHERE grade >= 5
AND      grade < 6) , ',', count(*) filter (WHERE grade >= 6
AND      grade <= 7) ) AS histogram,
     count(*) filter (WHERE grade >= 1
AND      grade <= 7) AS n_grades,
     round( ( avg(grade) filter (WHERE grade >= 1
AND      grade <= 7) )::NUMERIC, 2) AS avg_grade,
     '1-2,2-3,3-4,4-5,5-6,6-7' AS histogram_labels,
     '1.0,3.4999,#d6604d;3.5,3.9999,#f48873;4.0,4.4999,#a7dc78;4.5,7,#66b43e' AS color_bands
FROM     student_course
WHERE    state IN ('A',
                   'R',
                   'N')
         AND (registration = 'CURSADA'
             OR registration LIKE '%CURSADA'
             OR registration = 'ANULADA'
             OR registration= 'CAMBIO PLAN'
             OR registration LIKE '%ANULADA')
GROUP BY course_taken;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_course_stats_semester(truncate=False):
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        if truncate:
            cur.execute("TRUNCATE public.course_stats;")
        query = """
INSERT INTO course_stats
    (id,
    course_taken,
    year,
    term,
    p_group,
    n_total,
    n_finished,
    n_pass,
    n_fail,
    n_drop,
    histogram,
    n_grades,
    avg_grade,
    histogram_labels,
    color_bands)
SELECT   200000 + row_number() over (ORDER BY course_taken) AS id,
         course_taken,
         year,
         term,
         -1       AS p_group,
         count(*) AS n_total,
         count(*) filter (WHERE state = 'A' OR state = 'R') AS n_finished,
         count(*) filter (WHERE state = 'A') AS n_pass,
         count(*) filter (WHERE state = 'R') AS n_fail,
         count(*) filter (WHERE state = 'N') AS n_drop,
                  concat('', count(*) filter (WHERE grade >= 1
AND      grade < 2) , ',', count(*) filter (WHERE grade >= 2
AND      grade < 3) , ',', count(*) filter (WHERE grade >= 3
AND      grade < 4) , ',', count(*) filter (WHERE grade >= 4
AND      grade < 5) , ',', count(*) filter (WHERE grade >= 5
AND      grade < 6) , ',', count(*) filter (WHERE grade >= 6
AND      grade <= 7) ) AS histogram,
         count(*) filter (WHERE grade >= 1
AND      grade <= 7) AS n_grades,
         round( ( avg(grade) filter (WHERE grade >= 1
AND      grade <= 7) )::NUMERIC, 2) AS avg_grade,
         '1-2,2-3,3-4,4-5,5-6,6-7' AS histogram_labels,
         '1.0,3.4999,#d6604d;3.5,3.9999,#f48873;4.0,4.4999,#a7dc78;4.5,7,#66b43e' AS color_bands
FROM     student_course
WHERE    state IN ('A',
                   'R',
                   'N')
AND      (registration = 'CURSADA'
         OR registration LIKE '%CURSADA'
         OR registration = 'ANULADA'
         OR registration= 'CAMBIO PLAN'
         OR registration LIKE '%ANULADA')
GROUP BY course_taken,
         year,
         term;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def csv_to_inscritas2020(csv):
    conn = None
    try:
        file_name = csv.split('/')[-1]
        copy2(csv, '/tmp/'+file_name)

        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.inscritas2020;")
        cur.execute("ALTER SEQUENCE public.inscritas2020_id_seq RESTART WITH 1;")
        """
        # cur.execute("COPY public.inscritas2020 (estudiante,agno,semestre,psp,pga,pga_carrera,cod_carrera,carrera,malla_actual,agno_ingreso,situacion_semestre,reincorporaciones,mencion,dummy) " +
        """
        cur.execute("COPY public.inscritas2020 (estudiante,asignatura,asignatura_equivalente,agno,semestre,responsable,cod_carrera,malla_id,grupo_paralelo,electivo_equivalente,dummy) " +
        "FROM '" + "/tmp/" + file_name + "' " +
        "DELIMITER ',' " +
        "CSV HEADER;")
        cur.execute("UPDATE public.inscritas2020 " +
        "SET estudiante=TRIM(estudiante), asignatura=TRIM(asignatura), asignatura_equivalente=TRIM(asignatura_equivalente), " +
        "responsable=TRIM(responsable), cod_carrera=TRIM(cod_carrera), malla_id=TRIM(malla_id), electivo_equivalente=TRIM(electivo_equivalente) " +
        "WHERE TRUE;")

        cur.close()
        os.remove('/tmp/'+file_name)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_inscritas2020_into_stud_cou():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        query = """
INSERT INTO public.student_course (id,year,term,student_id,course_taken,course_equiv,elect_equiv,
registration,state,grade,p_group,comments,instructors,duplicates)
SELECT   max(id)+1300000 AS id,
         agno,
         semestre,
         estudiante,
         asignatura,
         max(asignatura_equivalente) AS course_equiv,
         max(electivo_equivalente) AS elect_equiv,
         'REGISTRADA' AS registration,
         'C' AS state,
         0 AS grade,
         max(grupo_paralelo) AS p_group,
         string_agg(cod_carrera,',') AS comments,
         string_agg(responsable,';') AS instructors,
         0 AS duplicates
FROM

(SELECT a.*
  FROM inscritas2020 a
  LEFT JOIN student_course b
    ON  a.agno = b."year"
    AND a.semestre = b.term
    AND a.estudiante = b.student_id
    AND a.asignatura = b.course_taken
WHERE a.asignatura IS NOT NULL AND b.student_id IS NULL) insc

GROUP BY agno,semestre,estudiante,asignatura;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_inscritas2020_into_stud_term():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        query = """
INSERT INTO public.student_term
            (id,student_id,"year",term,situation,t_gpa,c_gpa,comments,program_id,
             curriculum,start_year)
SELECT 500000 + row_number() OVER (ORDER BY estudiante, agno, semestre, cod_carrera) AS
       rownum,estudiante,agno,semestre,'',0,0,'',cod_carrera,malla_id,0
FROM   inscritas2020
WHERE  malla_id IS NOT NULL
GROUP  BY estudiante,agno,semestre,cod_carrera,malla_id;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def upd_student_term_year():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        query = """
UPDATE public.student_term T
SET    start_year = coalesce((SELECT max(start_year)
        FROM   student_term
        WHERE  start_year > 0
            AND student_id = T.student_id
            AND program_id = T.program_id
        GROUP  BY student_id,program_id), 2020)
WHERE  start_year = 0 ;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True


def cre_ins_x_last_gpas():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("DROP TABLE IF EXISTS public.x_last_gpas;")
        query = """
CREATE TABLE public.x_last_gpas AS
  SELECT DISTINCT on (program_id, student_id) id,student_id,program_id,year,term,round(c_gpa::numeric) AS c_gpa
  FROM   student_term
  WHERE  year >= 2010
         AND c_gpa <> 0.0
  ORDER  BY program_id ASC,student_id,year DESC,term DESC;
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True

def ins_student_cluster():
    conn = None
    try:
        conn = psycopg2.connect("dbname='"+globals.dest_db_name+"' user='"+globals.dest_db_user+"' host='"+globals.dest_db_host+"' password='"+globals.dest_db_pass+"'")
        conn.set_session(autocommit=True)
        cur = conn.cursor()
        cur.execute("TRUNCATE public.student_cluster;")
        query = """
INSERT INTO public.student_cluster(student_id,program_id,last_cgpa,cluster)
SELECT student_id,program_id,c_gpa,
CASE
     WHEN c_gpa <= 4.38 THEN 1
     WHEN c_gpa > 4.38
          AND c_gpa <= 4.82 THEN 2
     WHEN c_gpa > 4.82 THEN 3
     ELSE 0
    end AS the_cluster
FROM   x_last_gpas
WHERE  program_id = '1708';
        """
        cur.execute(query)

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False
    finally:
        if conn is not None:
            conn.close()
    return True
