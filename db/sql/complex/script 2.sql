-- Поиск контента, выпущенного в Америке жанра Sci-Fi за последние 4 года.
WITH Selection AS (
    SELECT
        M.title,
        M.release_date,
        CG.genre_id,
        CC.country_id
    FROM
        Movies M
        JOIN ContentGenres CG ON M.id = CG.movie_id
        JOIN ContentCountries CC ON M.id = CC.movie_id

    UNION ALL

    SELECT
        TVS.title,
        TVS.release_date,
        CG.genre_id,
        CC.country_id
    FROM
        TVShows TVS
        JOIN ContentGenres CG ON TVS.id = CG.tv_show_id
        JOIN ContentCountries CC ON TVS.id = CC.tv_show_id
)

SELECT DISTINCT
    S.title,
    S.release_date
FROM
    Selection S
    JOIN Genres G ON S.genre_id = G.id
    JOIN Countries C ON S.country_id = C.id
WHERE
    G.name = 'Sci-Fi' AND
    C.name = 'United States' AND
    S.release_date >= DATE('now', '-4 years')
order by title;
