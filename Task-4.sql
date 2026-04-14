-- Task 4.1: Identifying top 3 warehouses with highest average shipment delay
SELECT 
    Warehouse_ID,
    ROUND(AVG(Delay_Hours), 2) AS avg_delay_hours
FROM shipments
GROUP BY Warehouse_ID
ORDER BY avg_delay_hours DESC
LIMIT 3;

-- Task 4.2: Calculating total shipments vs delayed shipments per warehouse
SELECT
    Warehouse_ID,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Delay_Hours > 0 THEN 1 ELSE 0 END) AS delayed_shipments,
    ROUND(
        (SUM(CASE WHEN Delay_Hours > 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS delayed_percent
FROM shipments
GROUP BY Warehouse_ID
ORDER BY delayed_percent DESC;

-- Task 4.3: Identifying warehouses where average delay exceeds global average delay
WITH global_avg AS (
    SELECT AVG(Delay_Hours) AS global_delay
    FROM shipments
),
warehouse_avg AS (
    SELECT Warehouse_ID,
           AVG(Delay_Hours) AS warehouse_delay
    FROM shipments
    GROUP BY Warehouse_ID
)
SELECT 
    w.Warehouse_ID,
    ROUND(w.warehouse_delay, 2) AS warehouse_avg_delay,
    ROUND(g.global_delay, 2) AS global_avg_delay
FROM warehouse_avg w
CROSS JOIN global_avg g
WHERE w.warehouse_delay > g.global_delay
ORDER BY w.warehouse_delay DESC;

-- Task 4.4: Ranking warehouses based on on-time delivery percentage
SELECT
    Warehouse_ID,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) AS on_time_shipments,
    ROUND(
        (SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS on_time_percent,
    RANK() OVER(
        ORDER BY 
        (SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*)) DESC
    ) AS warehouse_rank
FROM shipments
GROUP BY Warehouse_ID;