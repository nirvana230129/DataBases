import sqlite3
import psycopg2


class PostgreDatabase:
    def __init__(self, dbname, user, password, host='localhost', port='5432'):
        self._dbname = dbname
        self._user = user
        self._password = password
        self._host = host
        self._port = port

    def __enter__(self):
        self._conn = psycopg2.connect(
            dbname=self._dbname,
            user=self._user,
            password=self._password,
            host=self._host,
            port=self._port
        )
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
            self._cursor.execute(sql_script)

    def create(self):
        with open('sql/postgre_create.sql', 'r') as file:
            sql_script = file.read()
            self._cursor.execute(sql_script)

    def transfer_from_sqlite(self, sqlite_db_path):
        sqlite_conn = sqlite3.connect(sqlite_db_path)
        sqlite_cursor = sqlite_conn.cursor()

        tables_order = [
            'Genres',
            'Countries',
            'Roles',
            'Personnel',
            'Movies',
            'TVShows',
            'Episodes',
            'ContentGenres',
            'ContentCountries',
            'ContentPersonnel',
            'ContentCharacters'
        ]

        for table in tables_order:
            sqlite_cursor.execute(f"SELECT * FROM {table}")
            rows = sqlite_cursor.fetchall()

            for row in rows:
                placeholders = ', '.join(['%s'] * len(row))
                self._cursor.execute(f"INSERT INTO {table} VALUES ({placeholders})", row)

            self._conn.commit()

        sqlite_conn.close()



with PostgreDatabase(dbname='MoviesTVShowsDB', user='postgres', password='Arif2004', host='127.0.0.1') as pdb:
    pdb.clean()
    pdb.create()
    pdb.transfer_from_sqlite('database.db')
