-- Median movie rating by genre for the countries with the most titles.
WITH TopCountries AS (
    SELECT
        C.id AS country_id,
        C.name AS country
    FROM Countries C
        JOIN ContentCountries CC ON C.id = CC.country_id
    WHERE CC.movie_id IS NOT NULL
    GROUP BY C.id, C.name
    ORDER BY COUNT(*) DESC
    LIMIT 8
),
GenreCountry AS (
    SELECT
        TC.country,
        G.name AS genre,
        M.rating
    FROM TopCountries TC
        JOIN ContentCountries CC ON TC.country_id = CC.country_id
        JOIN Movies M ON CC.movie_id = M.id
        JOIN ContentGenres CG ON M.id = CG.movie_id
        JOIN Genres G ON CG.genre_id = G.id
    WHERE M.rating IS NOT NULL
)
SELECT
    country,
    genre,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM GenreCountry
GROUP BY country, genre
HAVING COUNT(*) >= 3
ORDER BY country, genre;
