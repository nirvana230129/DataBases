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

CREATE TABLE IF NOT EXISTS Episodes (
    id INTEGER PRIMARY KEY,
    tv_show_id INTEGER NOT NULL,
    season_number INTEGER,
    episode_number INTEGER,
    title VARCHAR,
    release_date DATE,
    duration TIME,
    rating FLOAT,
    FOREIGN KEY (tv_show_id) REFERENCES TVShows(id)
);

CREATE TABLE IF NOT EXISTS ContentGenres (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER,
    tv_show_id INTEGER,
    genre_id INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (tv_show_id) REFERENCES TVShows(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id),
    CHECK (
        (movie_id IS NOT NULL AND tv_show_id IS NULL)
        OR
        (movie_id IS NULL AND tv_show_id IS NOT NULL)
    )
);

CREATE TABLE IF NOT EXISTS ContentCountries (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER,
    tv_show_id INTEGER,
    country_id INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (tv_show_id) REFERENCES TVShows(id),
    FOREIGN KEY (country_id) REFERENCES Countries(id),
    CHECK (
        (movie_id IS NOT NULL AND tv_show_id IS NULL)
        OR
        (movie_id IS NULL AND tv_show_id IS NOT NULL)
    )
);

CREATE TABLE IF NOT EXISTS ContentPersonnel (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER,
    tv_show_id INTEGER,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (tv_show_id) REFERENCES TVShows(id),
    FOREIGN KEY (person_id) REFERENCES Personnel(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id),
    CHECK (
        (movie_id IS NOT NULL AND tv_show_id IS NULL)
        OR
        (movie_id IS NULL AND tv_show_id IS NOT NULL)
    )
);

CREATE TABLE IF NOT EXISTS ContentCharacters (
    id INTEGER PRIMARY KEY,
    content_person_id INTEGER NOT NULL,
    character_name VARCHAR NOT NULL,
    FOREIGN KEY (content_person_id) REFERENCES ContentPersonnel(id)
);
