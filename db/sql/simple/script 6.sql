-- Посмотреть кем пробовал себя Ben Stiller при создании продуктов.
SELECT DISTINCT R.name AS role
FROM Personnel P
    JOIN ContentPersonnel CP ON P.id = CP.person_id
    JOIN Roles R ON CP.role_id = R.id
WHERE P.name = 'Ben Stiller'
ORDER BY role
