# Movies & TV Shows Database

A system for storing, importing, cleaning, and analyzing data about movies, TV shows, episodes, cast, crew, production countries, and genres. SQLite is used for the initial import and local storage. PostgreSQL is used for migration and analytical queries.

## Database Schema

Tables use one-to-many and many-to-many relationships with foreign keys and integrity constraints.

A diagram of the schema is in [db/scheme.png](db/scheme.png).

### Tables

- **Movies** stores title, release date, tagline, budget, revenue, duration, rating, and description.
- **TVShows** stores title, release date, tagline, budget, rating, and description.
- **Episodes** stores season number, episode number, title, release date, duration, and rating, and references `TVShows`.
- **Genres** is the genre dictionary.
- **Countries** is the country dictionary.
- **Roles** is the crew and cast role dictionary (director, writer, cast, composer, and others).
- **Personnel** stores name, birth date, death date, place of birth, and biography.
- **ContentGenres**, **ContentCountries**, and **ContentPersonnel** are bridge tables for many-to-many links. A `CHECK` constraint forces each row to point to either a movie or a TV show:

```sql
CHECK (
    (movie_id IS NOT NULL AND tv_show_id IS NULL)
    OR
    (movie_id IS NULL AND tv_show_id IS NOT NULL)
)
```

- **ContentCharacters** stores character names for people linked through `ContentPersonnel` with the `cast` role.

## Project Structure

```text
├── data/                  # Source CSV files (ignored by Git)
└── db/
    ├── main.py            # CSV parsing, currency conversion, and SQLite import
    ├── postgre.py         # PostgreSQL schema creation and migration from SQLite
    ├── database           # Generated SQLite database file
    ├── scheme.png         # Schema diagram
    └── sql/
        ├── create.sql              # SQLite schema
        ├── clean.sql               # Drop tables
        ├── postgre_create.sql      # PostgreSQL schema
        ├── postgre_test_script.sql # Sample PostgreSQL query
        ├── simple/                 # Nine simpler analytical queries
        └── complex/                # Nine analytical queries with CTEs and window functions
```

## Scripts

### Import and cleaning (`db/main.py`)

The script loads CSV files into a local SQLite database.

- Reads CSV files with `pandas` and shows progress with `tqdm`.
- Converts budgets and revenues from local currencies (rubles, francs, and others) to USD through [ExchangeRate-API](https://www.exchangerate-api.com/) and `requests`.
- Turns duration in minutes into `HH:MM`.
- Parses dates such as `12 May 2021` or a bare year into `YYYY-MM-DD`.
- Uses a context manager so a successful run commits and an error rolls back.

### PostgreSQL migration (`db/postgre.py`)

The script copies the cleaned SQLite data into PostgreSQL.

- Creates the schema from `db/sql/postgre_create.sql`.
- Reads tables in foreign-key order (`Genres`, `Countries`, and so on through `ContentCharacters`) and inserts the rows with `psycopg2`.

## Setup

Python 3.10+ and PostgreSQL are required.

Create and activate a virtual environment:

```bash
python -m venv .venv
source .venv/bin/activate
```

On Windows:

```bash
.venv\Scripts\activate
```

Install dependencies:

```bash
pip install pandas requests tqdm psycopg2-binary python-dotenv
```

Register at [ExchangeRate-API](https://www.exchangerate-api.com/) and put the key in `db/.env`:

```env
API_KEY=your_api_key_here
```

Place the source CSV files in `data/` and run the import:

```bash
cd db
python main.py
```

This writes a SQLite file named `database` in `db/`.

Start PostgreSQL and create the target database. By default the script connects to `MoviesTVShowsDB` as user `postgres`. Connection settings are at the bottom of `db/postgre.py`.

```bash
python postgre.py
```
