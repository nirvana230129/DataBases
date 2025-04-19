import sqlite3
from tqdm import tqdm
import pandas as pd
from datetime import time, datetime
import requests
from dotenv import load_dotenv
import os


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

    @staticmethod
    def _evaluate_duration(duration: str) -> str:
        if pd.isna(duration):
            return duration
        duration = int(duration)
        duration = str(time(duration // 60, duration % 60))
        return duration[:duration.rfind(':')]

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

    def _fill_roles(self, roles_df: pd.DataFrame):
        for i, row in tqdm(roles_df.iterrows(), total=len(roles_df)):
            try:
                self._cursor.execute('''
                    INSERT INTO Roles (name)
                    VALUES (?);
                ''', (row['Role'],))
            except Exception as e:
                raise Exception(f'Error inserting role {i}, {row}:\n{e}\n' + '=' * 80)

    def _fill_episodes(self, episodes_df: pd.DataFrame):
        for i, row in tqdm(episodes_df.iterrows(), total=len(episodes_df)):
            try:
                self._cursor.execute('''
                    INSERT INTO Episodes 
                    (tv_show_id, season_number, episode_number, title, release_date, duration, rating)
                    VALUES (?, ?, ?, ?, ?, ?, ?);
                ''', (row['IMDb_id'][2:], row['Season'], row['Episode'], row['Title'], row['Release_Date'],
                      self._evaluate_duration(row['Duration']), row['Rating']))
            except Exception as e:
                raise Exception(f'Error inserting episode {i}, {row}:\n{e}\n' + '=' * 80)

    def _fill_content(self, content_df: pd.DataFrame):
        def evaluate_money(amount:str):
            if pd.isna(amount):
                return amount
            if ', ' in amount:
                amount = amount[:amount.find(', ')]
            amount = amount.replace(',', '').replace(' (estimated)', '')

            if amount.startswith('$'):
                return int(amount[1:])

            currency_code = amount[:3]
            amount = int(amount[3:])
            if currency_code == 'FRF':
                rate = 0.17337
                return amount * rate

            if currency_code == 'RUR':
                currency_code = 'RUB'

            load_dotenv()
            api_key = os.getenv('API_KEY')

            url = f'https://v6.exchangerate-api.com/v6/{api_key}/latest/{currency_code}'
            response = requests.get(url)
            data = response.json()
            rate = data['conversion_rates']['USD']
            return amount * rate

        def evaluate_date(original_date: str) -> str:
            if pd.isna(original_date):
                return original_date

            if '(' in original_date:
                original_date = original_date[:original_date.find('(') - 1]

            if len(original_date) == 4 and original_date.isdigit():
                original_date = f'01 Jan {original_date}'
            date_object = datetime.strptime(original_date, "%d %b %Y")
            formatted_date = date_object.strftime("%Y-%m-%d")
            return formatted_date

        for i, row in tqdm(content_df.iterrows(), total=len(content_df)):
            try:
                release_date = evaluate_date(row['Release Date'])
                budget = evaluate_money(row['Budget'])
                revenue = evaluate_money(row['Revenue'])
                is_tv_show = eval(row['IsTVShow'])
                if is_tv_show:
                    # TVShows
                    self._cursor.execute('''
                        INSERT INTO TVShows 
                        (id, title, release_date, tagline, budget, rating, description)
                        VALUES (?, ?, ?, ?, ?, ?, ?);
                    ''', (row['MovieID'], row['Title'], release_date, row['Tagline'], budget,
                          row['Rating'], row['Description']))
                else:
                    # Movies
                    self._cursor.execute('''
                        INSERT INTO Movies 
                        (id, title, release_date, tagline, budget, revenue, duration, rating, description)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
                    ''', (row['MovieID'], row['Title'], release_date, row['Tagline'], budget,
                          revenue, self._evaluate_duration(row['Duration']), row['Rating'], row['Description']))

                # ContentCountries
                for country in eval(row['Countries']):
                    self._cursor.execute(f'''
                        INSERT INTO ContentCountries ({'tv_show_id' if is_tv_show else 'movie_id'}, country_id)
                        VALUES (?, (SELECT id FROM Countries WHERE name = ?));
                    ''', (row['MovieID'], country))

                # ContentGenres
                for genre in eval(row['Genres']):
                    self._cursor.execute(f'''
                        INSERT INTO ContentGenres ({'tv_show_id' if is_tv_show else 'movie_id'}, genre_id)
                        VALUES (?, (SELECT id FROM Genres WHERE name = ?));
                    ''', (row['MovieID'], genre))

                # ContentPersonnel
                for role in ['location management', 'costume designer', 'music department', 'casting department',
                             'costume department', 'art direction', 'make up', 'visual effects', 'director',
                             'composer', 'assistant director', 'casting director', 'editor', 'producer',
                             'cinematographer', 'miscellaneous crew', 'special effects',
                             'camera and electrical department', 'art department', 'stunt performer', 'thanks',
                             'production design', 'set decoration', 'cast', 'production manager', 'sound crew',
                             'script department', 'writer', 'transportation department', 'editorial department']:
                    for person_id in eval(row[role]):
                        self._cursor.execute(f'''
                            INSERT INTO ContentPersonnel 
                            ({'tv_show_id' if is_tv_show else 'movie_id'}, person_id, role_id)
                            VALUES (?, ?, (SELECT id FROM Roles WHERE name = ?));
                        ''', (row['MovieID'], person_id, role))

                    # ContentCharacters
                    if role == 'cast':
                        cast = eval(row[role])

                        self._cursor.execute("SELECT id FROM Roles WHERE name = 'cast';")
                        cast_id = self._cursor.fetchone()[0]

                        for person_id in cast:
                            self._cursor.execute(f'''
                                INSERT INTO ContentCharacters (content_person_id, character_name)
                                VALUES (
                                            (
                                                SELECT id FROM ContentPersonnel 
                                                WHERE
                                                    {'tv_show_id' if is_tv_show else 'movie_id'} = ? AND 
                                                    person_id = ? AND 
                                                    role_id = ?
                                            ), 
                                            ?
                                        );
                            ''', (row['MovieID'], person_id, cast_id, cast[person_id]))

            except Exception as e:
                raise Exception(f'Error inserting content {i}, {row}:\n{e}\n' + '=' * 80)

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

        files = ['roles_file', 'genres_file', 'countries_file', 'episodes_file', 'personnel_file', 'content_file']
        funcs = [self._fill_roles, self._fill_genres, self._fill_countries, self._fill_episodes, self._fill_personnel,
                 self._fill_content]
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
        'genres_file': '../data/genres_data.csv',
        'countries_file': '../data/countries_data.csv',
        'content_file': '../data/movies_data.csv',
        'personnel_file': '../data/personnel_data.csv',
        'episodes_file': ('../data/TVShows_data.csv', ';'),
        'roles_file': '../data/roles_data.csv',
    })
