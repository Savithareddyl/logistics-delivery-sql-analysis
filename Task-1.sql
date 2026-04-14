
-- Task 1.1: Checking for duplicate Order_IDs
SELECT Order_ID, COUNT(*) AS cnt                        
FROM orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;
-- Task 1.1: Checking for duplicate Shipment_IDs
SELECT Shipment_ID, COUNT(*) AS cnt
FROM shipments
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;
-- Task 1.2: Identifying shipments with NULL delay values
SELECT COUNT(*) AS null_delay_count
FROM shipments
WHERE Delay_Hours IS NULL;
-- Task 1.3: Converting Order_Date to proper DATETIME format
UPDATE orders
SET Order_Date = STR_TO_DATE(Order_Date, '%Y-%m-%d %H:%i:%s')
WHERE Order_ID IS NOT NULL;
ALTER TABLE orders
MODIFY Order_Date DATETIME;
-- Verifying converted order dates
SELECT Order_Date FROM orders LIMIT 5;
-- Task 1.3: Converting Pickup_Date and Delivery_Date to DATETIME format
UPDATE shipments
SET Pickup_Date   = STR_TO_DATE(Pickup_Date, '%Y-%m-%d %H:%i:%s'),
    Delivery_Date = STR_TO_DATE(Delivery_Date, '%Y-%m-%d %H:%i:%s')
WHERE Shipment_ID IS NOT NULL;
ALTER TABLE shipments
MODIFY Pickup_Date DATETIME,
MODIFY Delivery_Date DATETIME;
-- Verifying converted shipment dates
SELECT Pickup_Date, Delivery_Date FROM shipments LIMIT 5;
-- Checking final table structures
DESCRIBE orders;
DESCRIBE shipments;
-- Task 1.4: Flagging records where delivery occurred before pickup
SELECT *
FROM shipments
WHERE Delivery_Date < Pickup_Date;
-- Task 1.5: Validating referential integrity across tables
-- Orders reference check
SELECT s.Order_ID
FROM shipments s
LEFT JOIN orders o ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;
-- Routes reference check
SELECT s.Route_ID
FROM shipments s
LEFT JOIN routes r ON s.Route_ID = r.Route_ID
WHERE r.Route_ID IS NULL;
-- Delivery agents reference check
SELECT s.Agent_ID
FROM shipments s
LEFT JOIN delivery_agents d ON s.Agent_ID = d.Agent_ID
WHERE d.Agent_ID IS NULL;
-- Warehouses reference check
SELECT s.Warehouse_ID
FROM shipments s
LEFT JOIN warehouses w ON s.Warehouse_ID = w.Warehouses_ID
WHERE w.Warehouses_ID IS NULL;


