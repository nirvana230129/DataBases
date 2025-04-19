-- Поиск стран с лучшей средней оценкой.
WITH CountriesRatings AS (
    SELECT C.name AS country,
           M.rating
    FROM Countries C
        JOIN ContentCountries CC ON C.id = CC.country_id
        JOIN Movies M ON CC.movie_id = M.id

    UNION ALL

    SELECT C.name AS country,
           ROUND(AVG(rating), 1) AS rating
    FROM Countries C
        JOIN ContentCountries CC ON C.id = CC.country_id
        JOIN TVShows TVS ON CC.tv_show_id = TVS.id
)

SELECT country,
       ROUND(AVG(rating), 1) AS rating
FROM CountriesRatings CR
GROUP BY country
HAVING COUNT(*) > 3
ORDER BY rating DESC, country
LIMIT 10
