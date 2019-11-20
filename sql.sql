-- For each country calculate the total spending for each customer, and 
-- include a column (called 'difference') showing how much more each customer 
-- spent compared to the next highest spender in that country. 
-- For the 'difference' column, fill any nulls with zero.
-- ROUND your all of your results to the next penny.

-- hints: 
-- keywords to google - lead, lag, coalesce
-- If rounding isn't working: 
-- https://stackoverflow.com/questions/13113096/how-to-round-an-average-to-2-decimal-places-in-postgresql/20934099



*** QUERY ***

WITH total_spent_by_customer_plus_lag AS (
SELECT country, customerid, SUM(unitprice*quantity*(1-discount)) AS total_spent,
LAG (SUM(unitprice*quantity*(1-discount)), 1) OVER (PARTITION BY country ORDER BY SUM(unitprice*quantity*(1-discount)) ASC) AS previous
FROM customers INNER JOIN orders USING(customerid) INNER JOIN orderdetails USING (orderid)
GROUP BY country, customerid
ORDER BY country, total_spent DESC
)

SELECT country, customerid, CAST(total_spent AS decimal (18,2)), CAST(previous AS decimal (18,2)),CAST(total_spent - previous AS decimal (18,2)) AS difference
FROM total_spent_by_customer_plus_lag
ORDER BY country, total_spent DESC;

*** ANSWER ***

  country   | customerid | total_spent | previous | difference
-------------+------------+-------------+----------+------------
 Argentina   | OCEAN      |     3460.20 |  2844.10 |     616.10
 Argentina   | RANCH      |     2844.10 |  1814.80 |    1029.30
 Argentina   | CACTU      |     1814.80 |          |
 Austria     | ERNSH      |   105182.18 | 23128.86 |   82053.32
 Austria     | PICCO      |    23128.86 |          |
 Belgium     | SUPRD      |    24088.78 |  9989.70 |   14099.09
 Belgium     | MAISD      |     9989.70 |          |
 Brazil      | HANAR      |    32841.37 | 25717.50 |    7123.87
 Brazil      | QUEEN      |    25717.50 | 12450.80 |   13266.70
 Brazil      | RICAR      |    12450.80 |  8414.14 |    4036.67
 Brazil      | URL        |     8414.14 |  6850.66 |    1563.47
 Brazil      | TRADH      |     6850.66 |  6664.81 |     185.85
 Brazil      | QUEDE      |     6664.81 |  6068.20 |     596.61
 Brazil      | WELLI      |     6068.20 |  4107.55 |    1960.65
 Brazil      | FAMIA      |     4107.55 |  3810.75 |     296.80
 Brazil      | COMMI      |     3810.75 |          |

...