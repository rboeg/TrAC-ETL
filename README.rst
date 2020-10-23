TrAC-ETL
========================
TrAC-ETL is a Python tool for the LALA-UACh's TrAC system data extraction-transformation-loading procedure.

Prerequisites and assumptions
-----------
- Linux or MacOS operating system.
- Installed Python packages:
  os, re, xlsx2csv, configparser, psycopg2, getpass, shutil, openpyxl.
- The input files have .xlsx extension. They are all in the same directory and are named:
  malla\*.xlsx, \*cursadas\*.xlsx, \*situac\*.xlsx, \*inscritas\*.xlsx
  (Lowercase, camelcase, and uppercase for the file names are supported).
- The names of the \*cursadas\*.xls files are lexicographically sortable according with their date ranges.
- The destination database exists and it is empty (no tables, no objects).
