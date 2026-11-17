# Movies & TV Shows Database

How are genre, production country, and budget related to rating and commercial return?

This project loads movie and TV data into SQLite, exposes analysis views, and answers that question with SQL plus a short notebook. PostgreSQL migration is optional.

## Question and metrics

- **Profit** = `revenue - budget`
- **ROI** = `profit / budget` when budget is present and greater than zero
- Financial metrics use only movies with both budget and revenue filled in
- Ratings come from the catalog fields stored in the CSV import

Place source CSV files in `data/` (movies, TV shows / episodes, personnel, genres, countries, roles). The sample used for the findings below contains 480 movies, 45 TV shows, and 253 episodes.

## Findings

From [`analysis/movies.ipynb`](analysis/movies.ipynb) against the local SQLite database:

1. About **20%** of movies are missing budget or revenue, so every ROI chart describes the financially complete subset only. Ratings are almost complete (mean about **7.0**).
2. Rating and box office are only **weakly** related (correlation of rating with log revenue is about **0.17**). High scores still span several orders of magnitude in revenue.
3. By **median ROI**, romance, horror, and musical titles lead among genres with at least five complete financial rows. Horror's **mean** ROI is much higher than its median, which points to a few extreme hits.
4. Adventure and sci-fi titles often show large absolute profit while returning less per dollar of budget than smaller-scale genres.
5. The sample is heavily skewed toward the **United States** (about 400 movie country links), so country comparisons are uneven.
6. The largest year-over-year jump in total reported revenue in this dataset is **2017**. Later years look quieter, which can reflect both market shocks and incomplete coverage of recent releases.

Full charts and query steps live in the notebook. Named SQL files are under [`db/sql/analysis/`](db/sql/analysis/).

## Limitations

- Non-USD budgets and revenues are converted in [`db/main.py`](db/main.py) with a **current** ExchangeRate-API rate at import time, not the historical rate for the release year.
- Profit and ROI require both `budget` and `revenue`; missing either drops the title from financial summaries.
- Revenue exists only for movies. TV shows have budget and rating fields but no box-office column.
- The CSV set is a curated sample, not the full industry catalog.

## Project structure

```text
├── analysis/
│   └── movies.ipynb       # Main analysis notebook
├── data/                  # Source CSV files (ignored by Git)
├── docs/
│   └── data_dictionary.md # Field-level documentation
├── requirements.txt
└── db/
    ├── main.py            # CSV parsing, currency conversion, SQLite import
    ├── postgre.py         # Optional PostgreSQL migration
    ├── database           # Generated SQLite database
    ├── scheme.png         # Schema diagram
    └── sql/
        ├── create.sql
        ├── clean.sql
        ├── views.sql              # movie_financials and content views
        ├── postgre_create.sql
        ├── analysis/              # Analytical queries
        └── examples/              # Catalog / lookup examples
```

## Database schema

Tables use one-to-many and many-to-many relationships with foreign keys. A diagram is in [db/scheme.png](db/scheme.png). Field notes are in [docs/data_dictionary.md](docs/data_dictionary.md).

- **Movies** / **TVShows** / **Episodes** store titles and ratings; movies also store budget and revenue.
- **Genres**, **Countries**, **Roles**, **Personnel** are dictionaries.
- **ContentGenres**, **ContentCountries**, **ContentPersonnel** bridge many-to-many links with a `CHECK` so each row points to either a movie or a TV show.
- **ContentCharacters** stores character names for cast credits.
- Views in [`db/sql/views.sql`](db/sql/views.sql):
  - `movie_financials` — year, profit, ROI, duration in minutes
  - `content` — movies and TV shows in one table with `content_type`

## Setup

Python 3.10+ is required. PostgreSQL is optional.

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

For currency conversion during import, put an ExchangeRate-API key in `db/.env`:

```env
API_KEY=your_api_key_here
```

Put CSV files in `data/`, then build SQLite:

```bash
cd db
python main.py
```

This writes `db/database`. Open the notebook from the repo root or the `analysis/` folder:

```bash
jupyter notebook analysis/movies.ipynb
```

### Optional PostgreSQL migration

Set connection variables (password is required):

```env
PGPASSWORD=secret
PGDATABASE=MoviesTVShowsDB
PGUSER=postgres
PGHOST=127.0.0.1
PGPORT=5432
```

```bash
cd db
python postgre.py
```

## Scripts

### Import (`db/main.py`)

- Loads CSV files with `pandas` and shows progress with `tqdm`
- Converts non-USD money amounts to USD via ExchangeRate-API
- Normalizes duration to `HH:MM` and dates to `YYYY-MM-DD`
- Commits or rolls back through a context manager

### Migration (`db/postgre.py`)

- Creates the PostgreSQL schema from `db/sql/postgre_create.sql`
- Copies SQLite tables in foreign-key order into PostgreSQL
