-- Average ROI by genre for movies with complete financials.
-- Genres need at least 5 such movies to reduce noise from tiny samples.
SELECT
    G.name AS genre,
    COUNT(*) AS movie_count,
    ROUND(AVG(MF.roi), 2) AS avg_roi,
    ROUND(AVG(MF.profit), 0) AS avg_profit,
    ROUND(AVG(MF.budget), 0) AS avg_budget
FROM movie_financials MF
    JOIN ContentGenres CG ON MF.id = CG.movie_id
    JOIN Genres G ON CG.genre_id = G.id
WHERE MF.roi IS NOT NULL
GROUP BY G.name
HAVING COUNT(*) >= 5
ORDER BY avg_roi DESC;
