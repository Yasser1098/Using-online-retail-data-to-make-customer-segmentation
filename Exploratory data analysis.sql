--1--First we need do discover the avreage number of items that customer purchase for an invoice ?

--The average number of items for each invoice is equal to 
--246 item which means that the customer purchase for each invoice around 246 item

--Query--> 
WITH inv_qt AS
(SELECT invoice, SUM(quantity) as Total_items FROM tableretail GROUP BY invoice)

SELECT invoice, Total_items, ROUND(AVG(Total_items) OVER(),1) as AVG_Items_per_invoice
FROM inv_qt;
-----------------------------------------------------------------------------------------------------------------------------------------------------

--2--Next we can descover what is the Maximum paid amount for an invoice ?

--Maximum Paid amount for an invoice is equal to 18841

--Query-->
WITH inv_pri AS
(SELECT invoice,quantity, price,(quantity*price) AS item_Total_price
  FROM tableretail)
 
 SELECT invoice, price, SUM(item_total_price) OVER(PARTITION BY invoice) as total_per_inv
 FROM inv_pri
 ORDER BY total_per_inv DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------

--3--Netx, What is the minimum paid amount for an invoice ?

--Finding an invoice with zero amount so we may need to check why we have an invoice with 
--value of Zero and the Minimum paid amount for an invoice is equal to 0.95.

--Query-->

WITH inv_pri AS
(SELECT invoice,quantity, price,(quantity*price) AS item_Total_price
  FROM tableretail)
 
 SELECT invoice, price, SUM(item_total_price) OVER(PARTITION BY invoice) as total_per_inv
 FROM inv_pri
 ORDER BY total_per_inv ASC;
--------------------------------------------------------------------------------------------------------------------------------------------------

--4--What are the 5 most frequently purchased product ?

--the 5 products that present in larger number of 
--invoices are (84879 ,22086, 85099B , 22197, 85123A, 47566, 23298, 22457)

--Query-->

WITH prod_freq AS
( SELECT stockcode, COUNT(*) AS Frequency
 FROM tableretail
 GROUp BY stockcode
 ORDER BY COUNT(invoice) DESC)
 
 SELECT * FROM(SELECT stockcode, frequency, Rank() OVER(ORDER BY frequency DESC) AS Ranking
 FROM prod_freq)
 WHERE Ranking IN (1,2,3,4,5);
-------------------------------------------------------------------------------------------------------------------------------------------------
--5--What is the 5 products that are being purchased in large quantities ?

--(84077
--84879
--22197
--21787
--21977)

--Query-->

SELECT * FROM
 (SELECT stockcode, RANK() OVER(ORDER BY Tot_Quan DESC) AS Rnk 
  FROM (
  SELECT stockcode, SUM(quantity) as Tot_Quan
 FROM tableretail
 GROUP BY stockcode
 )) WHERE Rnk <= 5;