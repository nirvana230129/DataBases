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


with PostgreDatabase(dbname='MoviesTVShowsDB', user='postgres', password='Arif2004') as pdb:
    pdb.clean()
    pdb.create()
