alter procedure spSummaryData1 (@discountValue int, @topNvalues int, @logic nvarchar(10))
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
			insert into @SummaryData2 (City, TotalPurchaseQty, TotalPurchaseAmount, TotalShippedQty, TotalDiscountAmount) 
			select pt.city, pt.TotalQty, pt.TotalAmount, cus.TotalOrderQty, cus.TotaDiscountAmount FROM (
				Select p.city, sum(p.OrderQty) TotalQty, sum(p.listprice*p.orderqty) TotalAmount from PurchaseTrans p
			group by City) pt
			LEFT JOIN 
			(SELECT c.city, sum(c.orderqty) TotalOrderQty, sum(c.listprice*c.OrderQty*(1-c.unitpricediscount)) TotaDiscountAmount FROM CustomerShipment c
			group by city) cus
		ON pt.city = cus.city 
	IF @logic='EQUAL'
		SELECT TOP (@topNvalues) * FROM @SummaryData2 where TotalPurchaseAmount - TotalDiscountAmount = @discountValue
	ELSE IF @logic='LESS'
		SELECT TOP (@topNvalues) * FROM @SummaryData2 where TotalPurchaseAmount - TotalDiscountAmount < @discountValue
	ELSE IF @logic='GREATER' 
		SELECT TOP (@topNvalues) * FROM @SummaryData2 where TotalPurchaseAmount - TotalDiscountAmount > @discountValue
	END
END

exec spSummaryData1 337.3485, 20, 'EQUAL' 



