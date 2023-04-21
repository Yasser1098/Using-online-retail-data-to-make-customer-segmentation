Q1 Queries for qxploring the Data:

1- WITH inv_qt AS
(SELECT invoice, SUM(quantity) as Total_items FROM tableretail GROUP BY invoice)

SELECT invoice, Total_items, ROUND(AVG(Total_items) OVER(),1) as AVG_Items_per_invoice
FROM inv_qt;
====================================================================================================================================
2- WITH inv_pri AS
(SELECT invoice,quantity, price,(quantity*price) AS item_Total_price
  FROM tableretail)
 
 SELECT invoice, price, SUM(item_total_price) OVER(PARTITION BY invoice) as total_per_inv
 FROM inv_pri
 ORDER BY total_per_inv DESC;
===================================================================================================================================
3-  WITH inv_pri AS
(SELECT invoice,quantity, price,(quantity*price) AS item_Total_price
  FROM tableretail)
 
 SELECT invoice, price, SUM(item_total_price) OVER(PARTITION BY invoice) as total_per_inv
 FROM inv_pri
 ORDER BY total_per_inv ASC;
==================================================================================================================================
4- WITH prod_freq AS
( SELECT stockcode, COUNT(*) AS Frequency
 FROM tableretail
 GROUp BY stockcode
 ORDER BY COUNT(invoice) DESC)
 
 SELECT * FROM(SELECT stockcode, frequency, Rank() OVER(ORDER BY frequency DESC) AS Ranking
 FROM prod_freq)
 WHERE Ranking IN (1,2,3,4,5);
==================================================================================================================================
5-  SELECT * FROM
 (SELECT stockcode, RANK() OVER(ORDER BY Tot_Quan DESC) AS Rnk 
  FROM (
  SELECT stockcode, SUM(quantity) as Tot_Quan
 FROM tableretail
 GROUP BY stockcode
 )) WHERE Rnk <= 5;
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

                                                                Q2 (Customer Segmentation)
                                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Query-->

WITH inv_dat AS
(SELECT customer_id, AVG(num_day) as Recency  FROM
(SELECT customer_id, MAX(to_date(substr(invoicedate,1,instr(invoicedate, ' ')),'mm-dd-yyyy')) over() - MAX(to_date(substr(invoicedate,1,instr(invoicedate, ' ')),'mm-dd-yyyy')) OVER(PARTITION BY customer_id) AS num_day
FROM tableretail)
GROUP BY customer_id)
,
new_d AS
(SELECT customer_id, COUNT(invoice) AS Frequency
FROM (SELECT DISTINCT invoice, Customer_id
FROM tableretail)
GROUP BY customer_id)
,
monet_a AS
(SELECT customer_id, SUM(Total) AS monetary From
(SELECT customer_id, quantity, price, quantity*price as Total
FROM tableretail)
GROUP BY customer_id)

SELECT customer_id ,recency,frequency,monetary, r_score, fm_score
, CASE WHEN  r_score = 5 AND fm_score = 5 THEN 'Champions'
           WHEN  r_score = 5 AND fm_score = 4 THEN 'Champions'
           WHEN  r_score = 4 AND fm_score = 5 THEN 'Champions'
           WHEN  r_score = 5 AND fm_score = 2 THEN 'Potential Loyalists'
           WHEN  r_score = 4 AND fm_score = 2 THEN 'Potential Loyalists'
           WHEN  r_score = 3 AND fm_score = 3 THEN 'Potential Loyalists'
           WHEN  r_score = 4 AND fm_score = 3 THEN 'Potential Loyalists'
           WHEN  r_score = 5 AND fm_score = 3 THEN 'Loyal Customers'
           WHEN  r_score = 4 AND fm_score = 4 THEN 'Loyal Customers'
           WHEN  r_score = 3 AND fm_score = 5 THEN 'Loyal Customers'
           WHEN  r_score = 3 AND fm_score = 4 THEN 'Loyal Customers'
           WHEN  r_score = 5 AND fm_score = 1 THEN 'Recent customers'
           WHEN  r_score = 4 AND fm_score = 1 THEN 'Promising'
           WHEN  r_score = 3 AND fm_score = 1 THEN 'Promising'
           WHEN  r_score = 3 AND fm_score = 2 THEN 'Customer Needing Attention'
           WHEN  r_score = 2 AND fm_score = 3 THEN 'Customer Needing Attention'
           WHEN  r_score = 2 AND fm_score = 2 THEN 'Customer Needing Attention'
           WHEN  r_score = 2 AND fm_score = 5 THEN 'At Risk'
           WHEN  r_score = 2 AND fm_score = 4 THEN 'At Risk'
           WHEN  r_score = 1 AND fm_score = 3 THEN 'At Risk'
           WHEN  r_score = 1 AND fm_score = 5 THEN 'Can not lose them'
           WHEN  r_score = 1 AND fm_score = 4 THEN 'Can not lose them'
           WHEN  r_score = 1 AND fm_score = 2 THEN 'Hibernating'
           WHEN  r_score = 2 AND fm_score = 1 THEN 'Hibernating'
           WHEN  r_score = 1 AND fm_score = 1 THEN 'Lost'
     END AS cust_segment
FROM ( SELECT customer_id ,recency,frequency,monetary,NTILE(5) OVER(order by recency DESC) as r_score,TRUNC( (NTILE(5) OVER(order by frequency) + NTILE(5) OVER(order by monetary))/2)
as fm_score
FROM
(SELECT customer_id, Recency, frequency, monetary
FROM inv_dat 
JOIN new_d
USING(customer_id)
JOIN monet_a
USING(customer_id)
) );