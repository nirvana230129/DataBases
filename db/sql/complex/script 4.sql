-- Поиск года с максимальным приростом кассовых сборов.
WITH YearlyRevenue AS (
    SELECT
        strftime('%Y', release_date) AS year,
        SUM(revenue) AS total_revenue
    FROM
        Movies
    GROUP BY
        year
),
RevenueChanges AS (
    SELECT
        year,
        total_revenue - LAG(total_revenue) OVER (ORDER BY year) AS revenue_change
    FROM
        YearlyRevenue
)
SELECT
    year,
    revenue_change
FROM
    RevenueChanges
ORDER BY
    revenue_change DESC
LIMIT 1
