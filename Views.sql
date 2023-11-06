-- Views

CREATE OR ALTER VIEW Sales_Dept_Analysis AS

SELECT p.TransID, p.OrderID, p.AccountNumber, p.Supplier, p.City, p.DueDate, p.OrderDate,
pd.productname, pd.ProductNumber, c.CategoryName, s.SpecialOffer, p.OrderQty*p.UnitPrice TotalAmount, p.Address 
FROM PurchaseTrans p
INNER JOIN Product pd on p.ProductID=pd.productid
INNER JOIN ProductCategory pc on pd.ProductID = pc.ProductID
INNER JOIN Category c on pc.CategoryID = c.CategoryID
INNER JOIN SpecialOffer s on p.SpecialOfferID = s.SpecialOfferID

SELECT * FROM Sales_Dept_Analysis

