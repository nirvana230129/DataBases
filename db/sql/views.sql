DROP VIEW IF EXISTS movie_financials;
DROP VIEW IF EXISTS content;

CREATE VIEW movie_financials AS
SELECT
    id,
    title,
    CAST(strftime('%Y', release_date) AS INTEGER) AS release_year,
    rating,
    budget,
    revenue,
    CASE
        WHEN revenue IS NOT NULL AND budget IS NOT NULL THEN revenue - budget
        ELSE NULL
    END AS profit,
    CASE
        WHEN revenue IS NOT NULL AND budget IS NOT NULL AND budget > 0
            THEN CAST(revenue - budget AS REAL) / budget
        ELSE NULL
    END AS roi,
    CASE
        WHEN duration IS NULL THEN NULL
        ELSE CAST(strftime('%H', duration) AS INTEGER) * 60
           + CAST(strftime('%M', duration) AS INTEGER)
    END AS duration_minutes
FROM Movies;

CREATE VIEW content AS
SELECT
    id,
    'movie' AS content_type,
    title,
    release_date,
    CAST(strftime('%Y', release_date) AS INTEGER) AS release_year,
    tagline,
    budget,
    revenue,
    rating,
    description
FROM Movies
UNION ALL
SELECT
    id,
    'tv' AS content_type,
    title,
    release_date,
    CAST(strftime('%Y', release_date) AS INTEGER) AS release_year,
    tagline,
    budget,
    NULL AS revenue,
    rating,
    description
FROM TVShows;
