-- Поиск сериала с самым большим временным промежутком между выходом первой и последней серий.
WITH EpisodeDates AS (
    SELECT
        tv_show_id,
        MIN(release_date) AS first_episode_date,
        MAX(release_date) AS last_episode_date
    FROM
        Episodes
    GROUP BY
        tv_show_id
),
TimeSpans AS (
    SELECT
        tv_show_id,
        last_episode_date - first_episode_date AS time_span
    FROM
        EpisodeDates
)

SELECT
    T.title,
    ED.first_episode_date,
    ED.last_episode_date,
    TS.time_span
FROM
    TimeSpans TS
    JOIN EpisodeDates ED ON TS.tv_show_id = ED.tv_show_id
    JOIN TVShows T ON TS.tv_show_id = T.id
ORDER BY
    TS.time_span DESC
LIMIT 1
