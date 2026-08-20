SELECT c.first_name, c.last_name, o.item, o.amount 
FROM Orders AS o 
JOIN Customers AS c 
ON o.customer_id = c.customer_id;