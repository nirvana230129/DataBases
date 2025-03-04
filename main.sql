CREATE TABLE IF NOT EXISTS Movies (
    id INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL,
    release_date DATE NOT NULL,
    slogan VARCHAR,
    country VARCHAR,
    budget INTEGER,
    revenues INTEGER,
    duration TIME,
    rating FLOAT
);

CREATE TABLE IF NOT EXISTS Series (
    id INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL,
    release_date DATE NOT NULL,
    slogan VARCHAR,
    country VARCHAR,
    budget INTEGER,
    rating FLOAT
);

CREATE TABLE IF NOT EXISTS People (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    birthdate DATE,
    place_of_birth VARCHAR,
    bio TEXT
);

CREATE TABLE IF NOT EXISTS Genres (
    id INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS Roles (
    id INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS SeriesEpisodes (
    id INTEGER PRIMARY KEY,
    series_id INTEGER NOT NULL,
    name VARCHAR NOT NULL,
    release_date DATE NOT NULL,
    duration TIME,
    rating FLOAT,
    FOREIGN KEY (series_id) REFERENCES Series(id)
);

CREATE TABLE IF NOT EXISTS ProductGenres (
    product_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Movies(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

CREATE TABLE IF NOT EXISTS ProductParticipants (
    product_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    character_name VARCHAR,
    FOREIGN KEY (product_id) REFERENCES Movies(id),
    FOREIGN KEY (person_id) REFERENCES People(id),
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);
