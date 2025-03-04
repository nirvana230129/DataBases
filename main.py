import sqlite3

# Подключение к базе данных
conn = sqlite3.connect('movies_and_series.db')
cursor = conn.cursor()

# Чтение и выполнение SQL-скрипта
with open('main.sql', 'r') as file:
    sql_script = file.read()
    cursor.executescript(sql_script)

# Сохранение изменений и закрытие соединения
conn.commit()
conn.close()
