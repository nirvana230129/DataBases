-- Получение частичной информации о всех вышедших сериях сериала Squid Game в порядке
-- номера сезона и серии.
SELECT E.season_number AS season,
       E.episode_number AS episode,
       E.title,
       E.release_date,
       E.duration,
       E.rating
FROM TVShows TVS
    JOIN Episodes E ON E.tv_show_id = TVS.id
WHERE TVS.title = 'Squid Game' AND
      E.release_date <= CURRENT_DATE
ORDER BY season,
         episode
