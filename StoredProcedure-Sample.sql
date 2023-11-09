create procedure spSummaryData1 (@discountValue int, @topNvalues int)
AS 
	BEGIN
		 Declare @SummaryData2 table
		 (City nvarchar(50),
		 TotalPurchaseQty int,
		 TotalPurchaseAmount float,
		 TotalShippedQty int,
		 TotalDiscountAmount float,
		 Diff_Amount AS TotalPurchaseAmount - TotalDiscountAmount
		 )
	BEGIN
				 /*Insert data into the variable table 
				 join two tables that you create from tables that already exist. The sub-queries below create tables, 
				 and then they are joined into one table with column we add to the SummaryData variable table.*/
		insert into @SummaryData2 (City, TotalPurchaseQty, TotalPurchaseAmount, TotalShippedQty, TotalDiscountAmount) 
		select pt.city, pt.TotalQty, pt.TotalAmount, cus.TotalOrderQty, cus.TotaDiscountAmount FROM 
			(Select p.city, sum(p.OrderQty) TotalQty, sum(p.listprice*p.orderqty) TotalAmount from PurchaseTrans p
			group by City) pt
			LEFT JOIN 
			(SELECT c.city, sum(c.orderqty) TotalOrderQty, sum(c.listprice*c.OrderQty*(1-c.unitpricediscount)) TotaDiscountAmount FROM CustomerShipment c
			group by city) cus
			ON pt.city = cus.city 

		SELECT TOP (@topNvalues) * FROM @SummaryData2 where TotalPurchaseAmount - TotalDiscountAmount >= @discountValue
	END
END

exec spSummaryData1 300, 20

/*Exec stored procedure error 'Line 77 Maximum stored procedure, function, trigger, or view nesting level exceeded (limit 32).' was fixed by 
--adding 'begin' on line 12.*/

