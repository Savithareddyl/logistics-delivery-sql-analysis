-- Task 5.1: Ranking delivery agents per route based on on-time delivery percentage
SELECT
    Route_ID,
    Agent_ID,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) AS on_time_shipments,
    ROUND(
        (SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS on_time_percent,
    RANK() OVER (
        PARTITION BY Route_ID
        ORDER BY 
        (SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*)) DESC
    ) AS agent_rank_per_route
FROM shipments
GROUP BY Route_ID, Agent_ID;

-- Task 5.2: Identifying delivery agents with on-time delivery percentage below 85%
SELECT
    s.Agent_ID,
    d.Agent_Name,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN s.Delay_Hours = 0 THEN 1 ELSE 0 END) AS on_time_shipments,
    ROUND(
        (SUM(CASE WHEN s.Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS on_time_percent
FROM shipments s
JOIN delivery_agents d 
    ON s.Agent_ID = d.Agent_ID
GROUP BY s.Agent_ID, d.Agent_Name
HAVING on_time_percent < 85
ORDER BY on_time_percent ASC;

-- Task 5.3: Comparing experience and ratings of top 5 vs bottom 5 delivery agents
-- Classification based on average customer rating
SELECT 'Top 5' AS category, Agent_ID, Agent_Name, Experience_Years, Avg_Rating
FROM (
    SELECT Agent_ID, Agent_Name, Experience_Years, Avg_Rating
    FROM delivery_agents
    ORDER BY Avg_Rating DESC
    LIMIT 5
) t

UNION ALL

SELECT 'Bottom 5' AS category, Agent_ID, Agent_Name, Experience_Years, Avg_Rating
FROM (
    SELECT Agent_ID, Agent_Name, Experience_Years, Avg_Rating
    FROM delivery_agents
    ORDER BY Avg_Rating ASC
    LIMIT 5
) b;