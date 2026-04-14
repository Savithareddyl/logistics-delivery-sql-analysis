-- Task 6.1: Displaying the latest delivery status and latest delivery date for each shipment
SELECT 
    Shipment_ID,Order_ID, Agent_ID, Route_ID, Warehouse_ID, Pickup_Date, 
	Delivery_Date, Delivery_Status, Delay_Hours, Delivery_Feedback,
    CASE 
        WHEN Delivery_Status = 'Delivered' THEN 'COMPLETED'
        WHEN Delivery_Status = 'In Transit' THEN 'ONGOING'
        WHEN Delivery_Status = 'Returned' THEN 'ISSUE'
        ELSE 'UNKNOWN'
    END as status_category
FROM Shipments
ORDER BY Delivery_Date DESC;

-- Task 6.2: Identifying routes where majority of shipments are In Transit or Returned
SELECT 
    r.Route_ID,
    CONCAT(r.Source_City, ' to ', r.Destination_City) as route_path,
    COUNT(s.Shipment_ID) as total_shipments,
    SUM(CASE WHEN s.Delivery_Status = 'In Transit' THEN 1 ELSE 0 END) as in_transit_count,
    SUM(CASE WHEN s.Delivery_Status = 'Returned' THEN 1 ELSE 0 END) as returned_count,
    SUM(CASE WHEN s.Delivery_Status = 'Delivered' THEN 1 ELSE 0 END) as delivered_count,
    ROUND(100 * SUM(CASE WHEN s.Delivery_Status IN ('In Transit', 'Returned') THEN 1 ELSE 0 END) / COUNT(s.Shipment_ID), 2) as problematic_pct
FROM Routes r
LEFT JOIN Shipments s ON r.Route_ID = s.Route_ID
GROUP BY r.Route_ID, r.Source_City, r.Destination_City
HAVING problematic_pct > 5
ORDER BY problematic_pct DESC;

-- Task 6.3: Identifying most frequent delay reasons
SELECT 
    Delivery_Feedback AS feedback_category,
    COUNT(*) AS frequency,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) 
    FROM Shipments WHERE Delay_Hours IS NOT NULL AND Delay_Hours > 0),2) AS percentage
FROM Shipments
WHERE Delay_Hours IS NOT NULL 
  AND Delay_Hours > 0
  AND Delivery_Feedback IN ('Positive', 'Negative', 'Neutral')
GROUP BY Delivery_Feedback
ORDER BY frequency DESC;

-- Task 6.4: Identifying orders with exceptionally high delivery delay (>120 hours)
SELECT s.Shipment_ID, s.Order_ID, da.Agent_Name, r.Source_City, r.Destination_City,
    w.City as warehouse_city, s.Pickup_Date, s.Delivery_Date, s.Delay_Hours,
    s.Delivery_Status, s.Delivery_Feedback, o.Order_Amount,
    CASE 
        WHEN s.Delay_Hours > 180 THEN 'CRITICAL'
        WHEN s.Delay_Hours > 120 THEN 'SEVERE'
        ELSE 'HIGH'
    END as ipr
FROM Shipments s
JOIN Orders o ON s.Order_ID = o.Order_ID
JOIN Routes r ON s.Route_ID = r.Route_ID
JOIN Warehouses w ON s.Warehouse_ID = w.Warehouses_ID
JOIN Delivery_Agents da ON s.Agent_ID = da.Agent_ID
WHERE s.Delay_Hours > 120
ORDER BY s.Delay_Hours DESC;


