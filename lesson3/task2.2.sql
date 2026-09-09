SELECT s.status, c.first_name, c.last_name 
FROM Shipings AS s 
JOIN Customers AS c 
ON s.customer = c.customer_id;