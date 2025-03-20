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
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

CREATE TABLE IF NOT EXISTS TVShowGenres (
    id INTEGER PRIMARY KEY,
    tvshow_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (tvshow_id, genre_id),
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

CREATE TABLE IF NOT EXISTS MovieCountries (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, country_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (country_id) REFERENCES Countries(id)
);

CREATE TABLE IF NOT EXISTS TVShowCountries (
    id INTEGER PRIMARY KEY,
    tvshow_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,
    PRIMARY KEY (tvshow_id, country_id),
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (country_id) REFERENCES Countries(id)
);

CREATE TABLE IF NOT EXISTS MoviePersonnel (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, person_id, role_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

CREATE TABLE IF NOT EXISTS TVShowPersonnel (
    id INTEGER PRIMARY KEY,
    tvshow_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (tvshow_id, person_id, role_id),
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

CREATE TABLE IF NOT EXISTS MovieCharacters (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, character_id, person_id, role_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (character_id) REFERENCES Characters(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

CREATE TABLE IF NOT EXISTS TVShowCharacters (
    id INTEGER PRIMARY KEY,
    tvshow_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (tvshow_id, character_id, person_id, role_id),
    FOREIGN KEY (tvshow_id) REFERENCES TVShows(id),
    FOREIGN KEY (character_id) REFERENCES Characters(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);
