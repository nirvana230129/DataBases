-- Most frequent person for each crew/cast role.
WITH RoleCounts AS (
    SELECT
        R.name AS role,
        P.name AS person,
        COUNT(*) AS performance_count,
        ROW_NUMBER() OVER (PARTITION BY R.id ORDER BY COUNT(*) DESC) AS rank
    FROM
        Roles R
        JOIN ContentPersonnel CP ON R.id = CP.role_id
        JOIN Personnel P ON CP.person_id = P.id
    GROUP BY
        R.id,
        P.id
)

SELECT
    role,
    person,
    performance_count
FROM
    RoleCounts
WHERE
    rank = 1
ORDER BY
    role;
