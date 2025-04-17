import sqlite3
from tqdm import tqdm
import pandas as pd

class Database:
    def __init__(self, db_file):
        self._db_file = db_file

    def __enter__(self):
        self._conn = sqlite3.connect(self._db_file)
        self._cursor = self._conn.cursor()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_val:
            self._conn.rollback()
        else:
            self._conn.commit()
        self._conn.close()

    def clean(self):
        with open('sql/clean.sql', 'r') as file:
            sql_script = file.read()
            self._cursor.executescript(sql_script)

    def create(self):
        with open('sql/create.sql', 'r') as file:
            sql_script = file.read()
            self._cursor.executescript(sql_script)

    def _fill_personnel(self, personnel_file):
        personnel_df = pd.read_csv(personnel_file)

        for i, row in tqdm(personnel_df.iterrows(), total=len(personnel_df)):
            if pd.notna(row['Name']):
                try:
                    self._cursor.execute('''
                        INSERT INTO Personnel (id, name, birth_date, death_date, birth_place, description)
                        VALUES (?, ?, ?, ?, ?, ?);
                    ''', (row['PersonID'], row['Name'], row['Birth Date'], row['Death Date'], row['Place of Birth'], row['Biography']))
                except Exception as e:
                    raise Exception(f'Error inserting personnel {i}, {row}:\n{e}\n' + '=' * 80)

    def _fill_genres(self, roles_file):
        genres_df = pd.read_csv(roles_file)
        for i, row in tqdm(genres_df.iterrows(), total=len(genres_df)):
            try:
                self._cursor.execute('''
                    INSERT INTO Genres (name)
                    VALUES (?);
                ''', (row['Genre'],))
            except Exception as e:
                raise Exception(f'Error inserting genre {i}, {row}:\n{e}\n' + '=' * 80)

    def _fill_countries(self, countries_file):
        countries_df = pd.read_csv(countries_file)
        for i, row in tqdm(countries_df.iterrows(), total=len(countries_df)):
            try:
                self._cursor.execute('''
                    INSERT INTO Countries (name)
                    VALUES (?);
                ''', (row['Country'],))
            except Exception as e:
                raise Exception(f'Error inserting country {i}, {row}:\n{e}\n' + '=' * 80)

    def fill(self, personnel_file, genres_file, countries_file):
        self._fill_personnel(personnel_file)
        self._fill_genres(genres_file)
        self._fill_countries(countries_file)

    def print_table(self, table):
        self._cursor.execute(f'SELECT * FROM {table}')
        return self._cursor.fetchall()


with Database('database') as db:
    db.clean()
    db.create()
    db.fill(
        '../data/personnel_data.csv',
        '../data/genres_data.csv',
        '../data/countries_data.csv'
    )
