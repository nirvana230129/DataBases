-- Поиск общих картин двух актеров: Роберта Дауни Мл. И Зендеи.
WITH Actor1Content AS (
    SELECT
        CP.movie_id,
        CP.tv_show_id
    FROM
        ContentPersonnel CP
        JOIN Personnel P ON CP.person_id = P.id
    WHERE
        p.name = 'Robert Downey Jr.'
),
Actor2Content AS (
    SELECT
        CP.movie_id,
        CP.tv_show_id
    FROM
        ContentPersonnel CP
        JOIN Personnel P ON CP.person_id = P.id
    WHERE
        p.name = 'Zendaya'
)

SELECT
    M.title
FROM
    Movies M
    JOIN (
            SELECT movie_id FROM Actor1Content
            INTERSECT
            SELECT movie_id FROM Actor2Content
    ) Movie_ids ON M.id = Movie_ids.movie_id

UNION ALL

SELECT
    TVS.title
FROM
    TVShows TVS
    JOIN (
            SELECT tv_show_id FROM Actor1Content
            INTERSECT
            SELECT tv_show_id FROM Actor2Content
    ) TVShow_ids ON TVS.id = TVShow_ids.tv_show_id
