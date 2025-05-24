-- Поиск для каждой страны жанра, с наибольшим средним рейтингом фильмов
WITH CountryGenreRatings AS (
    SELECT
        c.name AS country_name,
        g.name AS genre_name,
        ROUND(AVG(m.rating), 3) AS avg_rating
    FROM
        Countries C
        JOIN ContentCountries CC ON C.id = CC.country_id
        JOIN Movies M ON CC.movie_id = M.id
        JOIN ContentGenres CG ON M.id = CG.movie_id
        JOIN Genres G ON CG.genre_id = G.id
    GROUP BY
        c.name, g.name
),
RankedCountryGenres AS (
    SELECT
        country_name,
        genre_name,
        avg_rating,
        RANK() OVER (PARTITION BY country_name ORDER BY avg_rating DESC) AS rank
    FROM
        CountryGenreRatings
)

SELECT
    country_name,
    genre_name,
    avg_rating
FROM
    RankedCountryGenres
WHERE
    rank = 1;
