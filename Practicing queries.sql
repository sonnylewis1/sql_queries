/*Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of the
event, and the channel for each event. Additionally, you might choose to add a
fourth column to assure only Walmart events were chosen.*/

SELECT accounts.primary_poc, web_events.occurred_at, web_events.channel, accounts.name
FROM accounts
JOIN web_events
ON accounts.id = web_events.account_id
WHERE accounts.name = 'Walmart';

/*Provide a table that provides the region for each sales_rep along with their
associated accounts. Your final table should include three columns: the region
name, the sales rep name, and the account name. Sort the accounts alphabetically
(A-Z) according to account name. */

SELECT region.name as region, sales_reps.name as sales, accounts.name as account
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
ORDER BY account;

/*Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. Your final
table should have 3 columns: region name, account name, and unit price. A few
accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing
 by zero.*/

SELECT region.name AS Region, accounts.name AS Account, (orders.total_amt_usd/(orders.total + 0.01)) AS Unit
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id;

/*Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for the Midwest region. Your final table
should include three columns: the region name, the sales rep name, and the
account name. Sort the accounts alphabetically (A-Z) according to account name.*/

SELECT region.name AS Region, sales_reps.name AS Sales, accounts.name AS Account
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
WHERE Region.name = 'Midwest'

ORDER BY Region;

/*Find all the orders that occurred in 2015. Your final table should have 4
columns: occurred_at, account name, order total, and order total_amt_usd.*/

SELECT orders.occurred_at AS timer, accounts.name AS names, orders.total AS total, orders.total_amt_usd AS total_amt_usd

FROM orders
JOIN accounts
ON orders.account_id = accounts.id
WHERE orders.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';

/*For each account, determine the average amount of each type of paper they
purchased across their orders. Your result should have four columns - one for
the account name and one for the average quantity purchased for each of the
paper types for each account.*/

SELECT accounts.name AS name, AVG(orders.standard_qty) AS standard, AVG(orders.gloss_qty) AS gloss, AVG(orders.poster_qty) AS poster
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY name;

/*Determine the number of times a particular channel was used in the web_events
table for each sales rep. Your final table should have three columns - the name
of the sales rep, the channel, and the number of occurrences. Order your table
with the highest number of occurrences first.*/

SELECT sales_reps.name AS namer, web_events.channel AS channel, COUNT(web_events.channel) AS counter
FROM sales_reps
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN web_events
ON accounts.id = web_events.account_id
GROUP BY namer, channel
ORDER BY counter DESC;

/*Write a query to display the number of orders in each of three categories,
based on the total number of items in each order. The three categories are: 'At
Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/

SELECT id, total,
CASE WHEN total >= 2000 THEN 'At Least 2000'
	   WHEN total < 2000 AND total > 1000 THEN 'Between 1000 and 2000'
	   WHEN total < 1000 THEN 'Less than 1000'
     END AS designation
FROM orders

/*We would like to identify top performing sales reps, which are sales reps
associated with more than 200 orders. Create a table with the sales rep name,
the total number of orders, and a column with top or not depending on if they
have more than 200 orders. Place the top sales people first in your final table.*/

SELECT sales_reps.name Sales, COUNT(orders.id) AS Counter,
  CASE WHEN COUNT(orders.id) > 200 THEN 'Top'
       ELSE 'Not top' END AS Bracket
FROM sales_reps
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id

GROUP BY 1
ORDER BY 2

/* We want to find the average number of events for each day for each channel.*/
SELECT channel, AVG(Counter)
FROM
(SELECT DATE_TRUNC('day', occurred_at) AS DAYS,COUNT(id) Counter, channel AS channel
FROM web_events
GROUP BY 1,3) AS Sub

GROUP BY 1

/*For the region with the largest (sum) of sales total_amt_usd, how many total
(count) orders were placed? */

SELECT region.name Region, COUNT(orders.id) Num_orders
        FROM region
        JOIN sales_reps
        ON region.id = sales_reps.region_id
        JOIN accounts
        ON sales_reps.id = accounts.sales_rep_id
        JOIN orders
        ON accounts.id = orders.account_id
        GROUP BY Region

        HAVING SUM(orders.total_amt_usd) = (SELECT SUM(orders.total_amt_usd) Maximum
                                                  FROM region
                                                  JOIN sales_reps
                                                  ON region.id = sales_reps.region_id
                                                  JOIN accounts
                                                  ON sales_reps.id = accounts.sales_rep_id
                                                  JOIN orders
                                                  ON accounts.id = orders.account_id

                                                  GROUP BY region.name
                                                  ORDER BY 1 DESC
                                                  LIMIT 1)
