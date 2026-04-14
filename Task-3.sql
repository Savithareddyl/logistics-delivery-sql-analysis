-- Task 3.1: Calculating average transit time (in hours) per route
SELECT 
    Route_ID,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, Pickup_Date, Delivery_Date)), 2) AS avg_transit_time_hours
FROM shipments
GROUP BY Route_ID;

-- Task 3.2: Calculating average delay (in hours) per route
SELECT 
    Route_ID,
    ROUND(AVG(Delay_Hours), 2) AS avg_delay_hours
FROM shipments
GROUP BY Route_ID;

-- Task 3.3: Calculating route efficiency ratio (Distance_KM / Avg_Transit_Time)
SELECT 
    r.Route_ID,
    r.Distance_KM,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 2) AS avg_transit_time_hours,
    ROUND(AVG(s.Delay_Hours), 2) AS avg_delay_hours,
    ROUND(
        r.Distance_KM / AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 
        4
    ) AS efficiency_ratio
FROM routes r
JOIN shipments s 
    ON r.Route_ID = s.Route_ID
GROUP BY r.Route_ID, r.Distance_KM;

-- Task 3.4: Identifying 3 routes with the worst efficiency (lowest distance-to-time ratio)
SELECT 
    r.Route_ID,
    r.Distance_KM,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 2) AS avg_transit_time_hours,
    ROUND(
        r.Distance_KM / AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 
        4
    ) AS efficiency_ratio
FROM routes r
JOIN shipments s 
    ON r.Route_ID = s.Route_ID
GROUP BY r.Route_ID, r.Distance_KM
ORDER BY efficiency_ratio ASC
LIMIT 3;

-- Task 3.5: Identifying routes with more than 20% shipments delayed beyond expected transit time
SELECT
    s.Route_ID,
    COUNT(*) AS total_shipments,
    SUM(
        CASE 
            WHEN TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date) 
                 > r.Avg_Transit_Time_Hours
            THEN 1 ELSE 0 
        END
    ) AS delayed_shipments,
    ROUND(
        (SUM(
            CASE 
                WHEN TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date) 
                     > r.Avg_Transit_Time_Hours
                THEN 1 ELSE 0 
            END
        ) / COUNT(*)) * 100, 
        2
    ) AS delayed_percent
FROM shipments s
JOIN routes r 
    ON s.Route_ID = r.Route_ID
GROUP BY s.Route_ID
HAVING delayed_percent > 20
ORDER BY delayed_percent DESC;
