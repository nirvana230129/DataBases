import sqlite3

conn = sqlite3.connect('movies_and_series.db')
cursor = conn.cursor()

with open('clean.sql', 'r') as file:
    sql_script = file.read()
    cursor.executescript(sql_script)

with open('main.sql', 'r') as file:
    sql_script = file.read()
    cursor.executescript(sql_script)

conn.commit()
conn.close()
