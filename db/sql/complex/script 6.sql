-- Для сериалов, серии которых внесены в БД, определить отклонение их рейтинга
-- от среднего рейтинга их серий.
WITH EpisodeRatings AS (
    SELECT
        tv_show_id,
        AVG(rating) AS avg_episode_rating
    FROM
        Episodes
    GROUP BY
        tv_show_id
)

SELECT
    T.title,
    T.rating AS tv_show_rating,
    ROUND(ER.avg_episode_rating, 3) AS avg_episode_rating,
    ROUND(ER.avg_episode_rating - T.rating, 3) AS rating_deviation
FROM
    TVShows T
    JOIN EpisodeRatings ER ON T.id = ER.tv_show_id
ORDER BY
    ABS(rating_deviation) DESC
