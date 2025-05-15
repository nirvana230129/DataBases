-- Корреляция дохода и прибыли от проката с рейтингом фильма.
SELECT
    rating,
    ROUND(AVG(revenue)) AS avg_revenue,
    ROUND(AVG(revenue - budget)) AS avg_profit
FROM
    Movies
WHERE
    rating IS NOT NULL AND
    revenue IS NOT NULL AND
    budget IS NOT NULL
GROUP BY
    rating
ORDER BY
    rating
