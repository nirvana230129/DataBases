-- Movies where the most common crew role differs from the role that is most often
-- the largest role group across all movies.
WITH RankedRoles AS (
    SELECT
        movie_id,
        role_id,
        RANK() OVER (PARTITION BY movie_id ORDER BY COUNT(*) DESC) AS rank
    FROM
        ContentPersonnel
    WHERE
        movie_id IS NOT NULL
    GROUP BY
        movie_id,
        role_id
),

MostNumerousRoleInMovies AS (
    SELECT
        movie_id,
        role_id
    FROM
        RankedRoles
    WHERE
        rank = 1
),

MostNumerousRoleOverall AS (
    SELECT
        role_id
    FROM
        MostNumerousRoleInMovies
    GROUP BY
        role_id
    ORDER BY
        COUNT(*) DESC
    LIMIT 1
)

SELECT
    M.title,
    R.name AS Most_frequent_role
FROM MostNumerousRoleInMovies MNRIM
    JOIN Movies M ON MNRIM.movie_id = M.id
    JOIN Roles R ON MNRIM.role_id = R.id
WHERE MNRIM.role_id != (SELECT MNRO.role_id FROM MostNumerousRoleOverall MNRO);
