TrAC-ETL
========================
TrAC-ETL is a Python tool for the data extraction-transformation-loading procedure of LALA-UACh's TrAC system .

Prerequisites and definitions
-----------
- Linux or MacOS operating system.
- Python >=3.5
- Installed Python packages:
  os, re, xlsx2csv, configparser, psycopg2, getpass, shutil, openpyxl.
- The input files have .xlsx extension. They are all in the same directory and are named:
  malla\*.xlsx, \*cursadas\*.xlsx, \*situac\*.xlsx, \*inscritas\*.xlsx
  (Lowercase, camelcase, and uppercase for the file names are supported).
- The names of the \*cursadas\*.xls files are lexicographically sortable according with their date ranges.
- The destination database _exists_ and it is _empty_ (no tables, no objects).


Installation and usage
-----------
1. Generate the distribution archives:
```
[$] cd /directory/of/the/project
[$] sudo python3.6 setup.py sdist bdist_wheel
```
1. Run the module:
```
[$] python3.6 -m trac_etl
```
1. Parameters required by the script:
    1. Destination database host.
    1. Destination database name.
    1. Database user.
    1. Database user's password.
    1. Absolute path to the xlsx input files directory.


1. Output/input example. Entry points are marked with the > symbol at the beginning of the line.
```
Welcome to the LALA UACh's TrAC ETL tool
========================================
> Enter destination database host (e.g. localhost): **localhost**
> Enter destination database name (e.g. lalauach_2022): **lala_dec20**
> Enter user for the destination database (e.g. postgres): **postgres**
> Enter user's password: ****
.
Connecting to the PostgreSQL database...
Connected to lala_dec20 on ('PostgreSQL 10.9.16 on x86_64-pc-linux-gnu (Debian 10.1.22-1.pgdg90+1), compiled by gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516, 64-bit',)
.
.
Step 1/5: Creating database objects into lala_dec20b
 Done
.
> Enter absolute path to the xlsx input files directory (e.g. /home/lalauach/xlsx/2022): **/home/lala/LALA-UACh-DB/data_20201001**
.
.
Step 2/5: Excel files conversion
Converting AsignaturasCursadas_1.xlsx to UTF-8 CSV...
 Done
Converting AsignaturasCursadas_2.xlsx to UTF-8 CSV...
 Done
Converting AsignaturasCursadas_3.xlsx to UTF-8 CSV...
 Done
Converting AsignaturasInscritas.xlsx to UTF-8 CSV...
 Done
Converting Situacin_Semestral.xlsx to UTF-8 CSV...
 Done
Pre-processing malla_curricular.xlsx file...
 Done
Converting malla_curricular.xlsx to UTF-8 CSV...
 Done
[All files converted to CSV in 4.5 minutes]
.
.
Step 3/5: CSVs data insertion
Inserting xcursadas data (AsignaturasCursadas_1.xlsx.csv)...
 Done
Inserting xcursadas data (AsignaturasCursadas_2.xlsx.csv)...
 Done
Inserting xcursadas data (AsignaturasCursadas_3.xlsx.csv)...
 Done
Inserting inscritas2020 data (AsignaturasInscritas.xlsx.csv)...
 Done
Inserting xsituacion_semestral data...
 Done
Inserting xmalla data...
 Done
[CSVs inserted in database in 1.6 minutes]
.
.
Step 4/5: LALA UACh data model population
Inserting program_structure data...
 Done
Inserting course data...
 Done
Inserting student_term data...
 Done
Encoding student_term comments...
 Done
Inserting student_course data...
 Done
Inserting inscritas2020 data into student_course...
 Done
Inserting inscritas2020 data into student_term...
 Done
Updating student_term 2020 start_year...
 Done
Creating xstudent_program temporary table...
 Done
Creating xtemp_sc temporary table...
 Done
Inserting student_program data...
 Done
Inserting student data...
 Done
Creating x_last_gpas temporary table...
 Done
Computing and inserting student_cluster...
 Done
[Model data inserted in 2.5 minutes]
.
.
Step 5/5: Computation of courses statistics
Inserting stats by parallel groups...
 Done
Inserting stats by course...
 Done
Inserting stats by semester...
 Done
[Statistics computed in 0.2 minutes]
.
.
========================================
LALA UACh's TrAC ETL tool completed.
[Total execution time: 8.1 minutes]
Have a nice day.
```
