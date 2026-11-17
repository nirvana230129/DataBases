-- Family movies ordered by rating and title.
SELECT M.title, M.rating
FROM Movies M
    JOIN ContentGenres CG ON M.id = CG.movie_id
    JOIN Genres G ON CG.genre_id = G.id
WHERE G.name = 'Family'
ORDER BY M.rating DESC,
         M.title;
