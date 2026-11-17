-- Share of movies with missing budget or revenue, plus rating coverage.
SELECT
    COUNT(*) AS movie_count,
    SUM(CASE WHEN budget IS NULL OR revenue IS NULL THEN 1 ELSE 0 END) AS missing_financials,
    ROUND(
        100.0 * SUM(CASE WHEN budget IS NULL OR revenue IS NULL THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS missing_financials_pct,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS missing_rating,
    ROUND(
        100.0 * SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS missing_rating_pct,
    ROUND(AVG(rating), 2) AS avg_rating
FROM Movies;
