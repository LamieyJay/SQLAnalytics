USE [SQL Essentials]
-- dbo - database object
SELECT * FROM [SQL Essentials].dbo.purchasetrans
SELECT * FROM sys.databases

 --Get information on the structure of an object
 exec sp_help purchasetrans

-- DECLARING VARAIABLES
 declare @pocket int 
 select @pocket=6

 declare @cup char(10)
 select @cup='$#2fgudhf'
 SELECT @Cup

 -- DECLARING VARIABLE TABLES 
 Select p.city, sum(p.OrderQty) TotalQty, sum(p.listprice*p.orderqty) TotalAmount from PurchaseTrans p
 group by City

 SELECT c.city, sum(c.orderqty), sum(c.listprice*c.OrderQty*(1-c.unitpricediscount))  FROM CustomerShipment c
 group by city

 Declare @SummaryData table
 (City nvarchar(50),
 TotalPurchaseQty int,
 TotalPurchaseAmount float,
 TotalShippedQty int,
 TotalDiscountAmount float
 )
 -- Insert data into the variable table 
 --Join two tables that you create from tables that already exists. The sub-queries below create tables, and then they are joined into one table with column we add to the SummaryData variable table.
 insert into @SummaryData (City, TotalPurchaseQty, TotalPurchaseAmount, TotalShippedQty, TotalDiscountAmount)

 select pt.city, pt.TotalQty, pt.TotalAmount, cus.TotalOrderQty, cus.TotaDiscountAmount FROM (
	 Select p.city, sum(p.OrderQty) TotalQty, sum(p.listprice*p.orderqty) TotalAmount from PurchaseTrans p
	group by City) pt
 LEFT JOIN 
	(SELECT c.city, sum(c.orderqty) TotalOrderQty, sum(c.listprice*c.OrderQty*(1-c.unitpricediscount)) TotaDiscountAmount FROM CustomerShipment c
	group by city) cus
ON pt.city = cus.city 

SELECT * FROM @SummaryData

-- Computed column in the variable table 

 Declare @SummaryData1 table
 (City nvarchar(50),
 TotalPurchaseQty int,
 TotalPurchaseAmount float,
 TotalShippedQty int,
 TotalDiscountAmount float,
 Diff_Amount AS TotalPurchaseAmount - TotalDiscountAmount,
 Indicator AS CASE 
 WHEN TotalPurchaseAmount - TotalDiscountAmount < 100 THEN 'Low Discount' ELSE 'High Discount' END
 )
 -- Insert data into the variable table 
 --join two tables that you create from tables that already exists. The sub-queries below create tables, and then they are joined into one table with column we add to the SummaryData variable table.
 insert into @SummaryData1 (City, TotalPurchaseQty, TotalPurchaseAmount, TotalShippedQty, TotalDiscountAmount)

 select pt.city, pt.TotalQty, pt.TotalAmount, cus.TotalOrderQty, cus.TotaDiscountAmount FROM (
	 Select p.city, sum(p.OrderQty) TotalQty, sum(p.listprice*p.orderqty) TotalAmount from PurchaseTrans p
	group by City) pt
 LEFT JOIN 
	(SELECT c.city, sum(c.orderqty) TotalOrderQty, sum(c.listprice*c.OrderQty*(1-c.unitpricediscount)) TotaDiscountAmount FROM CustomerShipment c
	group by city) cus
ON pt.city = cus.city 

SELECT * FROM @SummaryData1