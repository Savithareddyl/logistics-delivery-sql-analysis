-- Task 7.1: Average delivery delay per source country
SELECT
    r.Source_Country,
    ROUND(AVG(s.Delay_Hours), 2) AS avg_delay_hours
FROM shipments s
JOIN routes r 
    ON s.Route_ID = r.Route_ID
GROUP BY r.Source_Country
ORDER BY avg_delay_hours DESC;

-- Task 7.2: On-time delivery percentage
SELECT
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) AS on_time_deliveries,
    ROUND(
        (SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS on_time_delivery_percent
FROM shipments;

-- Task 7.3: Average delay per route
SELECT
    Route_ID,
    ROUND(AVG(Delay_Hours), 2) AS avg_delay_hours
FROM shipments
GROUP BY Route_ID
ORDER BY avg_delay_hours DESC;

-- Task 7.4: Warehouse utilization percentage
SELECT
    w.Warehouses_ID,
    COUNT(s.Shipment_ID) AS shipments_handled,
    w.Capacity_per_day,
    ROUND(
        (COUNT(s.Shipment_ID) / w.Capacity_per_day) * 100, 
        2
    ) AS utilization_percent
FROM warehouses w
LEFT JOIN shipments s 
    ON w.Warehouses_ID = s.Warehouse_ID
GROUP BY w.Warehouses_ID, w.Capacity_per_day
ORDER BY utilization_percent DESC;