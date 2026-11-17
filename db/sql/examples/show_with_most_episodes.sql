-- TV show with the largest number of episodes in the database.
SELECT TVS.title,
       COUNT(*) AS count
FROM TVShows TVS
    JOIN Episodes E ON TVS.id = E.tv_show_id
GROUP BY TVS.id
ORDER BY count DESC
LIMIT 1;
