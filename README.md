# Using-online-retail-data-to-make-customer-segmentation
Customers has purchasing transaction that we shall be monitoring to get intuition behind each  customer behavior to target the customers in the most efficient and proactive way, to increase  sales/revenue , improve customer retention and decrease churn.
# The idea behind this rfm analysis
In the begenning, the data includes information about invoices such as invoice date and quantity of items in each invoice, it also includes the stock code which represent the different products that are available in the store, price which represent the price of each product individually, customer ID and country.
So, our analysis involves analyzing customer data and dividing them into distinct groups based on various characteristics such as demographics, behavior, purchasing history, and interactions with the company as our goal for this project is to categories our customers into segments that will help the store to idintefy the behaviour and the loyality level of it's clients.
# 1. Exploring the data
I started by understanding my data first by performing some exploratory data analysis using SQL queries to have an overview about the data that i have and how can i deal with it, and i discovered that:
1. First we need do discover the avreage number of items that customer purchase for an invoice ?

The average number of items for each invoice is equal to 
246 item which means that the customer purchase for each invoice around 246 item
2. Next we can descover what is the Maximum paid amount for an invoice ?

Maximum Paid amount for an invoice is equal to 18841
3. Netx, What is the minimum paid amount for an invoice ?

Finding an invoice with zero amount so we may need to check why we have an invoice with 
value of Zero and the Minimum paid amount for an invoice is equal to 0.95.
4. What are the 5 most frequently purchased product ?

the 5 products that present in larger number of 
invoices are (84879 ,22086, 85099B , 22197, 85123A, 47566, 23298, 22457)
5. What is the 5 products that are being purchased in large quantities ?

(84077
84879
22197
21787
21977)

# 2.implementing a Monetary model for customers behavior for product purchasing and segment each customer:

The goal is to divide the customers into different groups which describe the level of loyality of these customers and these categories are (Champions - Loyal Customers - Potential Loyalists – Recent Customers – Promising -Customers Needing Attention - At Risk - Cant Lose Them – Hibernating – Lost).
These categories are going to be grouped based on 3 main values:
                               • Recency (R)=> how recent the last transaction is (The reference date that i used is 
                               the most recent purchase in the dataset ).
                               • Frequency (F)=> how many times the customer has bought from our store.
                               • Monetary (M)=> how much each customer has paid for our products.

Note: there are many groups for each of the R, F, and M features, there are also many potential permutations, this number is too much to manage in terms of marketing strategies. 
For this, we would decrease the permutations by getting the average scores of the frequency and monetary to consider them as one score named FM score.
Moreover, Customers were labelled based on the following values:
![image](https://user-images.githubusercontent.com/129599070/233680259-ff581ce9-0fa0-483b-9519-f499f0a34d91.png)

