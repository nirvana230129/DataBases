-- Посмотреть продукты с наибольшим отношением бюджета к рейтингу.
SELECT
    title,
    budget,
    rating,
    CASE
        WHEN rating = 0 THEN NULL
        ELSE ROUND(budget / rating)
    END AS cost_per_rating_unit
FROM (
    SELECT
        title,
        budget,
        rating
    FROM
        Movies

    UNION ALL

    SELECT
        title,
        budget,
        rating
    FROM
        TVShows
) AS Content
WHERE
    budget IS NOT NULL AND
    rating > 0
ORDER BY cost_per_rating_unit DESC