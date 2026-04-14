-- Task 2.1: Calculating delivery delay (in hours) for each shipment
SELECT 
    Shipment_ID,
    Order_ID,
    Route_ID,
    Warehouse_ID,
    TIMESTAMPDIFF(HOUR, Pickup_Date, Delivery_Date) AS Calculated_Delay_Hours
FROM shipments;

-- Task 2.2: Identifying top 10 delayed routes based on average delay
SELECT 
    Route_ID,
    AVG(TIMESTAMPDIFF(HOUR, Pickup_Date, Delivery_Date)) AS Avg_Delay_Hours
FROM shipments
GROUP BY Route_ID
ORDER BY Avg_Delay_Hours DESC
LIMIT 10;

-- Task 2.3: Ranking shipments by delay within each warehouse
SELECT *
FROM (
    SELECT
        Shipment_ID,
        Warehouse_ID,
        Delay_Hours,
        RANK() OVER (
            PARTITION BY Warehouse_ID
            ORDER BY Delay_Hours DESC
        ) AS delay_rank_in_warehouse
    FROM shipments
) ranked
WHERE delay_rank_in_warehouse <= 5;

-- Task 2.4: Comparing average delay by delivery type (Express vs Standard)
SELECT 
    o.Delivery_Type,
    AVG(s.Delay_Hours) AS avg_delay_hours
FROM shipments s
JOIN orders o 
    ON s.Order_ID = o.Order_ID
GROUP BY o.Delivery_Type;