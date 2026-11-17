# Data Dictionary

Units for money are USD after import-time conversion. Duration in base tables is stored as `TIME` (`HH:MM:SS`); the `movie_financials` view exposes minutes.

## Movies

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| title | VARCHAR | Title | No |
| release_date | DATE | Release date | No |
| tagline | VARCHAR | Marketing tagline | Yes |
| budget | INTEGER | USD | Yes |
| revenue | INTEGER | USD box office | Yes |
| duration | TIME | Runtime | Yes |
| rating | FLOAT | Audience / catalog rating | Yes |
| description | TEXT | Synopsis | Yes |

## TVShows

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| title | VARCHAR | Title | No |
| release_date | DATE | First release date | No |
| tagline | VARCHAR | Marketing tagline | Yes |
| budget | INTEGER | USD | Yes |
| rating | FLOAT | Audience / catalog rating | Yes |
| description | TEXT | Synopsis | Yes |

TV shows have no revenue column in this schema.

## Episodes

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| tv_show_id | INTEGER | FK to `TVShows.id` | No |
| season_number | INTEGER | Season index | Yes |
| episode_number | INTEGER | Episode index within season | Yes |
| title | VARCHAR | Episode title | Yes |
| release_date | DATE | Episode release date | Yes |
| duration | TIME | Runtime | Yes |
| rating | FLOAT | Episode rating | Yes |

## Genres

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| name | VARCHAR | Unique genre name | No |

## Countries

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| name | VARCHAR | Unique country name | No |

## Roles

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| name | VARCHAR | Unique crew / cast role | No |

## Personnel

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| name | VARCHAR | Person name | No |
| birth_date | DATE | Date of birth | Yes |
| death_date | DATE | Date of death | Yes |
| birth_place | VARCHAR | Place of birth | Yes |
| description | TEXT | Biography | Yes |

## ContentGenres / ContentCountries / ContentPersonnel

Bridge tables for many-to-many links. Each row points to either a movie or a TV show.

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| movie_id | INTEGER | FK to `Movies.id` | Yes* |
| tv_show_id | INTEGER | FK to `TVShows.id` | Yes* |
| genre_id / country_id / person_id | INTEGER | Dictionary FK | No |
| role_id | INTEGER | Only in `ContentPersonnel` | No |

\* Exactly one of `movie_id` and `tv_show_id` must be non-null (`CHECK` constraint).

## ContentCharacters

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Primary key | No |
| content_person_id | INTEGER | FK to `ContentPersonnel.id` | No |
| character_name | VARCHAR | Character name for cast credits | No |

## View: movie_financials

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Movie id | No |
| title | VARCHAR | Title | No |
| release_year | INTEGER | Year from `release_date` | Yes |
| rating | FLOAT | Rating | Yes |
| budget | INTEGER | USD | Yes |
| revenue | INTEGER | USD | Yes |
| profit | INTEGER | `revenue - budget` | Yes |
| roi | REAL | `profit / budget` when `budget > 0` | Yes |
| duration_minutes | INTEGER | Runtime in minutes | Yes |

## View: content

Union of movies and TV shows for shared analytics.

| Column | Type | Unit / notes | Nullable |
| --- | --- | --- | --- |
| id | INTEGER | Source table id | No |
| content_type | TEXT | `movie` or `tv` | No |
| title | VARCHAR | Title | No |
| release_date | DATE | Release date | No |
| release_year | INTEGER | Year from `release_date` | Yes |
| tagline | VARCHAR | Tagline | Yes |
| budget | INTEGER | USD | Yes |
| revenue | INTEGER | USD; always null for TV | Yes |
| rating | FLOAT | Rating | Yes |
| description | TEXT | Synopsis | Yes |
