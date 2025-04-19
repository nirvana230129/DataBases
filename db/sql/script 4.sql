-- Просмотр актерского состава фильма Interstellar.
SELECT P.name,
       CC.character_name
FROM Movies M
    JOIN ContentPersonnel CP ON M.id = CP.movie_id
    JOIN ContentCharacters CC ON CP.id = CC.content_person_id
    JOIN Personnel P ON CP.person_id = P.id
WHERE title = 'Interstellar'
ORDER BY character_name
