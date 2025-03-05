DROP TABLE IF EXISTS Characters;
DROP TABLE IF EXISTS Countries;
DROP TABLE IF EXISTS Episodes;
DROP TABLE IF EXISTS Genres;
DROP TABLE IF EXISTS MovieCharacters;
DROP TABLE IF EXISTS MovieCountries;
DROP TABLE IF EXISTS MovieGenres;
DROP TABLE IF EXISTS MoviePersonnel;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Personnel;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS TVShowCharacters;
DROP TABLE IF EXISTS TVShowCountries;
DROP TABLE IF EXISTS TVShowGenres;
DROP TABLE IF EXISTS TVShowPersonnel;
DROP TABLE IF EXISTS TVShows;

CREATE TABLE IF NOT EXISTS Movies (
    id INTEGER PRIMARY KEY,
    title VARCHAR NOT NULL,
    release_date DATE NOT NULL,
    tagline VARCHAR,
    budget INTEGER,
    revenue INTEGER,
    duration TIME,
    rating FLOAT,
    description TEXT
);

CREATE TABLE IF NOT EXISTS TVShows (
    id INTEGER PRIMARY KEY,
    title VARCHAR NOT NULL,
    release_date DATE NOT NULL,
    tagline VARCHAR,
    budget INTEGER,
    rating FLOAT,
    description TEXT
);

CREATE TABLE IF NOT EXISTS Genres (
    id INTEGER PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Countries (
    id INTEGER PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Personnel (
    id INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL,
    birth_date DATE,
    death_date DATE,
    birth_place VARCHAR,
    description TEXT
);

CREATE TABLE IF NOT EXISTS Roles (
    id INTEGER PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Characters (
    id INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS Episodes (
    id INTEGER PRIMARY KEY,
    tvshow_id INTEGER NOT NULL,
    season_number INTEGER,
    episode_number INTEGER,
    title VARCHAR,
    release_date DATE,
    duration TIME,
    rating FLOAT,
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id)
);

CREATE TABLE IF NOT EXISTS MovieGenres (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

CREATE TABLE IF NOT EXISTS TVShowGenres (
    tvshow_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

CREATE TABLE IF NOT EXISTS MovieCountries (
    movie_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (country_id) REFERENCES Countries(id)
);

CREATE TABLE IF NOT EXISTS TVShowCountries (
    tvshow_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (country_id) REFERENCES Countries(id)
);

CREATE TABLE IF NOT EXISTS MoviePersonnel (
    movie_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

CREATE TABLE IF NOT EXISTS TVShowPersonnel (
    tvshow_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

CREATE TABLE IF NOT EXISTS MovieCharacters (
    movie_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (character_id) REFERENCES Characters(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

CREATE TABLE IF NOT EXISTS TVShowCharacters (
    tvshow_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (character_id) REFERENCES Characters(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);
