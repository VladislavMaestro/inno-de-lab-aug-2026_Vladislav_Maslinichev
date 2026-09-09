SELECT 
	item, 
	COUNT(*) AS count, 
TRUNC(AVG(amount), 2) AS avg_amount
FROM Orders 
GROUP BY item;