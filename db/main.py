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
        with open('clean.sql', 'r') as file:
            sql_script = file.read()
            self._cursor.executescript(sql_script)

    def create(self):
        with open('create.sql', 'r') as file:
            sql_script = file.read()
            self._cursor.executescript(sql_script)

    def fill_with_personnel(self, personnel_file):
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

    def print_table(self, table):
        self._cursor.execute(f'SELECT * FROM {table}')
        return self._cursor.fetchall()


with Database('database') as db:
    db.clean()
    db.create()
    db.fill_with_personnel('../data/personnel_data.csv')
