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

    def _fill_personnel(self, personnel_df: pd.DataFrame):
        for i, row in tqdm(personnel_df.iterrows(), total=len(personnel_df)):
            if pd.notna(row['Name']):
                try:
                    self._cursor.execute('''
                        INSERT INTO Personnel (id, name, birth_date, death_date, birth_place, description)
                        VALUES (?, ?, ?, ?, ?, ?);
                    ''', (row['PersonID'], row['Name'], row['Birth Date'], row['Death Date'], row['Place of Birth'], row['Biography']))
                except Exception as e:
                    raise Exception(f'Error inserting personnel {i}, {row}:\n{e}\n' + '=' * 80)

    def _fill_genres(self, genres_df: pd.DataFrame):
        for i, row in tqdm(genres_df.iterrows(), total=len(genres_df)):
            try:
                self._cursor.execute('''
                    INSERT INTO Genres (name)
                    VALUES (?);
                ''', (row['Genre'],))
            except Exception as e:
                raise Exception(f'Error inserting genre {i}, {row}:\n{e}\n' + '=' * 80)

    def _fill_countries(self, countries_df: pd.DataFrame):
        for i, row in tqdm(countries_df.iterrows(), total=len(countries_df)):
            try:
                self._cursor.execute('''
                    INSERT INTO Countries (name)
                    VALUES (?);
                ''', (row['Country'],))
            except Exception as e:
                raise Exception(f'Error inserting country {i}, {row}:\n{e}\n' + '=' * 80)

    def _fill_episodes(self, episodes_df: pd.DataFrame):
        for i, row in tqdm(episodes_df.iterrows(), total=len(episodes_df)):
            try:
                self._cursor.execute('''
                    INSERT INTO Episodes 
                    (tv_show_id, season_number, episode_number, title, release_date, duration, rating)
                    VALUES (?, ?, ?, ?, ?, ?, ?);
                ''', (row['IMDb_id'][2:], row['Season'], row['Episode'], row['Title'], row['Release_Date'],
                      row['Duration'], row['Rating']))
            except Exception as e:
                raise Exception(f'Error inserting country {i}, {row}:\n{e}\n' + '=' * 80)

    def fill(self, files_dict: dict[str, str | tuple[str, str]]):
        def get_file_and_delimiter(value):
            if not isinstance(value, (str, list, tuple)):
                return None, None

            if isinstance(value, str):
                file_ = value
                delimiter_ = ','
            elif len(value) == 2 and type(value[0]) == type(value[1]) == str and len(value[1]) == 1:
                file_, delimiter_ = value
            else:
                return None, None
            return file_, delimiter_

        files = ['personnel_file', 'genres_file', 'countries_file', 'episodes_file']
        funcs = [self._fill_personnel, self._fill_genres, self._fill_countries, self._fill_episodes]
        for file, fill_function in zip(files, funcs):
            if file in files_dict:
                file_name, delimiter = get_file_and_delimiter(files_dict[file])
                if file_name and delimiter:
                    fill_function(pd.read_csv(file_name, delimiter=delimiter))

    def print_table(self, table):
        self._cursor.execute(f'SELECT * FROM {table}')
        return self._cursor.fetchall()


with Database('database') as db:
    db.clean()
    db.create()
    db.fill({
        'personnel_file': '../data/personnel_data.csv',
        'genres_file': '../data/genres_data.csv',
        'countries_file': '../data/countries_data.csv',
        'episodes_file': ('../data/TVShows_data.csv', ';'),
    })
