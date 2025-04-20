-- Поиск самых окупившихся фильмов.
SELECT TVS.title,
       COUNT(*) AS count
FROM TVShows TVS
    JOIN Episodes E ON TVS.id = E.tv_show_id
GROUP BY TVS.id
ORDER BY count
LIMIT 1
