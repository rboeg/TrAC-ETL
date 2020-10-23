# -*- coding: utf-8 -*-

from setuptools import setup, find_packages

with open('README.rst') as f:
    readme = f.read()

setup(
    name='trac_etl',
    version='0.1.0',
    description="Python tool for the LALA-UACh's TrAC system data extraction-transformation-loading procedure",
    long_description=readme,
    author='Renato Boegeholz to LALA UACh',
    author_email='renatoboegeholz@gmail.com',
    url='https://github.com/x',
    license=license,
    packages=find_packages(exclude=('tests', 'docs')),
    python_requires='>=3.5',
    install_requires=[
        'os',
        're',
        'xlsx2csv',
        'configparser',
        'psycopg2',
        'getpass',
        'shutil',
        'openpyxl'
    ],
    # function to call on $ python trac_etl*.egg
    # py_modules=['trac_etl.__main__']
    entry_points={
        "console_scripts": [
            "trac_etl = trac_etl.__main__:main"
        ]
    }
)
