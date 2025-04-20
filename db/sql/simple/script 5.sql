-- Получение всего персонала и его роли в создании фильма 2012.
SELECT P.name AS name,
       R.name AS role
FROM Movies M
    JOIN ContentPersonnel CP ON M.id = CP.movie_id
    JOIN Personnel P ON CP.person_id = P.id
    JOIN Roles R ON CP.role_id = R.id
WHERE title = '2012'
ORDER BY role,
         name
