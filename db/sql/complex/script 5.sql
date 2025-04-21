-- Определение для каждой страны топ-3 популярных жанров.
WITH GenreCounts AS (
    SELECT
        C.name AS country,
        G.name AS genre,
        COUNT(*) AS count
    FROM
        ContentCountries CC
        JOIN Countries C ON CC.country_id = C.id
        JOIN ContentGenres CG ON CC.movie_id = CG.movie_id
        JOIN Genres G ON CG.genre_id = G.id
    GROUP BY
        country,
        genre
),
RankedGenres AS (
    SELECT
        country,
        genre,
        count,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY count DESC) AS rank
    FROM
        GenreCounts
)
SELECT
    country,
    genre,
    count
FROM
    RankedGenres
WHERE
    rank <= 3
ORDER BY
    country,
    rank
