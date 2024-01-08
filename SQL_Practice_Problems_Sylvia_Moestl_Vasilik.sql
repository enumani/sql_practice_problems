-- #1
select *
from Shippers

-- #2
select CategoryName, Description
from Categories

-- #3
select FirstName, LastName, HireDate
from Employees
where Title='Sales Representative'

-- #4
select FirstName, LastName, HireDate
from Employees
where Title='Sales Representative' and
Country='USA'

-- #5
select OrderID, OrderDate
from Orders
where EmployeeID='5'

-- #6
select SupplierID, ContactName, ContactTitle
from Suppliers
where ContactTitle!='Marketing Manager'

-- #7
select ProductID, ProductName
from Products
where ProductName like '%queso%'

-- #8
select OrderID, CustomerID, ShipCountry
from Orders
where ShipCountry='France' or
ShipCountry='Belgium'

-- #9
select OrderID, CustomerID, ShipCountry
from Orders
where ShipCountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

-- #10
select FirstName, LastName, Title, BirthDate
from Employees
order by BirthDate asc

-- #11
select FirstName, LastName, Title, cast(BirthDate as date) as BirthDate
from Employees
order by BirthDate asc

-- #12
select FirstName, LastName, CONCAT(FirstName, ' ',LastName) as FullName
from Employees

-- #13
select OrderID, ProductID, UnitPrice, Quantity, UnitPrice*Quantity as TotalPrice
from [Order Details]
order by OrderID,ProductID

-- #14
select count(CustomerID) as TotalCustomers
from Customers

-- #15
select top (1) OrderDate as FirstOrder
from Orders
order by OrderDate asc

-- Other possible answer for #15
select min(OrderDate) as FirstOrder
from Orders

-- #16
select distinct Country
from Customers

-- Other possible answer for #16
select Country
from Customers
group by Country

-- #17
select ContactTitle, COUNT(ContactTitle) as TotalContactTitle
from Customers
group by ContactTitle

-- #18
select Products.ProductID, Products.ProductName, Suppliers.CompanyName as Supplier
from Products
join Suppliers on Products.SupplierID=Suppliers.SupplierID
order by ProductID

-- #19
select orders.OrderID, cast(orders.OrderDate as date) as OrderDate, Shippers.CompanyName as Shipper
from Orders
join Shippers on orders.ShipVia=Shippers.ShipperID
where OrderID<10300
order by OrderID

-- #20
select Categories.CategoryName, count(Products.CategoryID) as TotalProducts
from Products
join Categories on Products.CategoryID=Categories.CategoryID
group by CategoryName
order by TotalProducts desc

-- #21
select Country, City, count(CustomerID) as TotalCustomers
from Customers
group by country, City
order by TotalCustomers desc

-- #22
select ProductID, ProductName, UnitsInStock, ReorderLevel
from Products
where UnitsInStock<ReorderLevel
order by ProductID

-- #23
select ProductID, ProductName, UnitsInStock, ReorderLevel, UnitsOnOrder, Discontinued
from Products
where UnitsInStock+UnitsOnOrder<=ReorderLevel and Discontinued=0
order by ProductID

-- #24
select CustomerID, CompanyName, Region
from Customers
order by case when Region is null then 2 else 1 end, Region, CustomerID

-- #25
select top (3) ShipCountry, avg(freight) as AverageFreight
from Orders
group by ShipCountry
order by AverageFreight desc

-- #26
select top (3) ShipCountry, avg(freight) as AverageFreight
from Orders
where year(OrderDate)='2015'
group by ShipCountry
order by AverageFreight desc

-- #27
select *
from Orders
where year(OrderDate)='2015'
order by OrderDate desc

-- OrderID 10806 and 10807 aren't showing because if we use the between clause with just the date, it converts in datetime format, with a default time 00:00:00.000, so the last two OrderIDs, which happen to be AFTER 2015-12-31 00:00:00.000, are excluded

-- #28
select max(OrderDate) from Orders
select DATEADD(month,-12,(select max(OrderDate) from Orders))

-- #28
select top (3) ShipCountry, avg(freight) as AverageFreight
from Orders
where OrderDate between '2015-05-06 18:00:00.000' and '2016-05-06 18:00:00.000'
group by ShipCountry
order by AverageFreight desc

-- #29
select Orders.EmployeeID, Employees.LastName, Orders.OrderID, Products.ProductName, OrderDetails.Quantity
from Orders
join Employees on orders.EmployeeID=Employees.EmployeeID
join OrderDetails on orders.OrderID=OrderDetails.OrderID
join Products on OrderDetails.ProductID=Products.ProductID
order by OrderID, products.ProductID

-- #30
select Customers.CustomerID as CustomersList, Orders.CustomerID as PlacedAnOrder
from Customers
left join Orders on Customers.CustomerID=Orders.CustomerID
where orders.CustomerID is null

-- #31
Select Customers.CustomerID as CustomersList, Orders.CustomerID as PlacedAnOrder
from Customers
left join Orders on Customers.CustomerID=Orders.CustomerID
and orders.employeeid='4'
where orders.CustomerID is null

-- #32
with HighValueCustomersTable as
(
select Customers.CustomerID, Customers.CompanyName, Orders.OrderID, TotalOrderAmount=sum(OrderDetails.Quantity*OrderDetails.UnitPrice)
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where year(OrderDate)=2016
group by Customers.CustomerID, Customers.CompanyName, Orders.OrderID
)
select * from HighValueCustomersTable
where TotalOrderAmount>=10000
order by TotalOrderAmount desc

-- #33
with HighValueCustomersTable as
(
select Customers.CustomerID, Customers.CompanyName, TotalOrderAmount=sum(OrderDetails.Quantity*OrderDetails.UnitPrice)
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where year(OrderDate)=2016
group by Customers.CustomerID, Customers.CompanyName
)
select *
from HighValueCustomersTable
where TotalOrderAmount>=15000
order by TotalOrderAmount desc

-- #34
with HighValueCustomersTable as
(
select Customers.CustomerID, Customers.CompanyName, TotalOrderAmount=sum(OrderDetails.Quantity*OrderDetails.UnitPrice),TotalOrderAmountWithDiscount=sum((OrderDetails.Quantity*OrderDetails.UnitPrice)-(OrderDetails.Quantity*OrderDetails.UnitPrice*OrderDetails.Discount))
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where year(OrderDate)=2016
group by Customers.CustomerID, Customers.CompanyName
)
select *
from HighValueCustomersTable
-- The Expected Result shows the values of the TotalOrderAmountWithDiscount higher than 10,000$ even though the problem #34 doesn't mention changing any 'where' clause. I decided to stick to the problem's requests.
where TotalOrderAmountWithDiscount>=15000
order by TotalOrderAmountWithDiscount desc

-- #35
select Orders.EmployeeID, Orders.OrderID, Orders.OrderDate
from Orders
where day(dateadd(day, 1, Orders.OrderDate)) = 1
order by Orders.EmployeeID, Orders.OrderID

-- #36
select top(10) Orders.OrderID, COUNT(OrderDetails.OrderID) as TotalOrderDetails
from Orders
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
group by Orders.OrderID
order by COUNT(Orders.OrderID) desc

-- #37
select top(2) percent Orders.OrderID, RandomValue=ABS(CHECKSUM(NewId())) % 100
from Orders
order by RandomValue desc

-- #38
select OrderDetails.OrderID 
from OrderDetails
where OrderDetails.Quantity>=60
group by OrderDetails.OrderID, OrderDetails.Quantity
having count(OrderDetails.OrderID)>1
order by OrderDetails.OrderID

-- #39
select *
from OrderDetails
where OrderDetails.OrderID in
(select OrderDetails.OrderID from OrderDetails where OrderDetails.Quantity>=60
group by OrderDetails.OrderID, OrderDetails.Quantity
having count(OrderDetails.OrderID)>1
)

-- #40
Select
OrderDetails.OrderID
,ProductID
,UnitPrice
,Quantity
,Discount
From OrderDetails
Join (
-- We must add the 'distinct' clause in order to avoid duplicates
Select distinct
OrderID
From OrderDetails
Where Quantity >= 60
Group By OrderID, Quantity
Having Count(*) > 1
) PotentialProblemOrders
on PotentialProblemOrders.OrderID = OrderDetails.OrderID
Order by OrderID, ProductID

-- #41
select Orders.OrderID, Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate
from Orders
where Orders.ShippedDate>=Orders.RequiredDate

-- #42
select Employees.EmployeeID, Employees.LastName, count(Orders.EmployeeID) as LateCounts
from Orders
join Employees on Orders.EmployeeID=Employees.EmployeeID
where Orders.OrderID in
(
select Orders.OrderID
from Orders
where Orders.ShippedDate>=Orders.RequiredDate
)
group by Employees.EmployeeID, Employees.LastName
order by LateCounts desc

-- #43
with cte1 as
(
select EmployeeID, count(*) as LateOrders
from Orders
where Orders.ShippedDate>=Orders.RequiredDate
group by EmployeeID
),
cte2 as
(
select EmployeeID ,count(*) as TotalOrders
From Orders
group by EmployeeID
)
select Employees.EmployeeID, Employees.LastName, cte2.TotalOrders, cte1.LateOrders
from Employees
join cte1 on Employees.EmployeeID=cte1.EmployeeID
join cte2 on Employees.EmployeeID=cte2.EmployeeID
order by EmployeeID

-- #44
with cte1 as
(
select EmployeeID, count(*) as LateOrders
from Orders
where Orders.ShippedDate>=Orders.RequiredDate
group by EmployeeID
),
cte2 as
(
select EmployeeID ,count(*) as TotalOrders
From Orders
group by EmployeeID
)
select Employees.EmployeeID, Employees.LastName, cte2.TotalOrders, cte1.LateOrders
from Employees
left join cte1 on Employees.EmployeeID=cte1.EmployeeID
left join cte2 on Employees.EmployeeID=cte2.EmployeeID
order by EmployeeID

-- #45
with cte1 as
(
select EmployeeID, count(*) as LateOrders
from Orders
where Orders.ShippedDate>=Orders.RequiredDate
group by EmployeeID
),
cte2 as
(
select EmployeeID ,count(*) as TotalOrders
From Orders
group by EmployeeID
)
select Employees.EmployeeID, Employees.LastName, cte2.TotalOrders, isnull(cte1.LateOrders,0) as LateOrders
from Employees
left join cte1 on Employees.EmployeeID=cte1.EmployeeID
left join cte2 on Employees.EmployeeID=cte2.EmployeeID
order by EmployeeID

-- #46
with cte1 as
(
select EmployeeID, count(*) as LateOrders
from Orders
where Orders.ShippedDate>=Orders.RequiredDate
group by EmployeeID
),
cte2 as
(
select EmployeeID ,count(*) as TotalOrders
From Orders
group by EmployeeID
)
select Employees.EmployeeID, Employees.LastName, cte2.TotalOrders, isnull(cte1.LateOrders,0) as LateOrders, isnull(LateOrders/cast(TotalOrders as decimal (12,2)),0) as PercentLateOrders
from Employees
left join cte1 on Employees.EmployeeID=cte1.EmployeeID
left join cte2 on Employees.EmployeeID=cte2.EmployeeID
order by EmployeeID

-- #47
with cte1 as
(
select EmployeeID, count(*) as LateOrders
from Orders
where Orders.ShippedDate>=Orders.RequiredDate
group by EmployeeID
),
cte2 as
(
select EmployeeID ,count(*) as TotalOrders
From Orders
group by EmployeeID
)
select Employees.EmployeeID, Employees.LastName, cte2.TotalOrders, isnull(cte1.LateOrders,0) as LateOrders, cast(isnull(LateOrders/cast(TotalOrders as decimal (12,2)),0) as decimal (3,2)) as PercentLateOrders
from Employees
left join cte1 on Employees.EmployeeID=cte1.EmployeeID
left join cte2 on Employees.EmployeeID=cte2.EmployeeID
order by EmployeeID

-- #48
with HighValueCustomersTable as
(
select Customers.CustomerID, Customers.CompanyName, TotalOrderAmount=sum(OrderDetails.Quantity*OrderDetails.UnitPrice),
case when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)<1000 then 'Low'
when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)<5000 then 'Medium'
when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)<10000 then 'High'
when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)>10000 then 'Very High' end as CustomerGroup
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where year(OrderDate)=2016
group by Customers.CustomerID, Customers.CompanyName
)
select *
from HighValueCustomersTable

-- #49
-- This question asks for a change in the previous answer if there is a NULL value, but on my answer there were no NULL values so there is no need to change anything.

-- #50
with
TotalOrdersTable AS (
select Orders.CustomerID, Customers.CompanyName, SUM(OrderDetails.Quantity*OrderDetails.UnitPrice) AS TotalOrdersAmmount
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on OrderDetails.OrderID = Orders.OrderID
group by 
Orders.CustomerID,
Customers.CompanyName
),
HighValueCustomersTable as
(
select Customers.CustomerID,
case when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)<1000 then 'Low'
when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)<5000 then 'Medium'
when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)<10000 then 'High'
when sum(OrderDetails.Quantity*OrderDetails.UnitPrice)>10000 then 'Very High' end as CustomerGroup
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where year(OrderDate)=2016
group by Customers.CustomerID, Customers.CompanyName
)
select HighValueCustomersTable.CustomerGroup, count(*) as TotalInGroup, count(*)*1.0/(select count(*) from HighValueCustomersTable) as PercentageInGroup
from HighValueCustomersTable
join TotalOrdersTable on TotalOrdersTable.CustomerID=HighValueCustomersTable.CustomerID
group by HighValueCustomersTable.CustomerGroup
order by TotalInGroup desc

-- #51
with HighValueCustomersTable as
(
select Customers.CustomerID, Customers.CompanyName, TotalOrderAmount=sum(OrderDetails.Quantity*OrderDetails.UnitPrice)
from Customers
join Orders on Orders.CustomerID=Customers.CustomerID
join OrderDetails on Orders.OrderID=OrderDetails.OrderID
where year(OrderDate)=2016
group by Customers.CustomerID, Customers.CompanyName
)
select HighValueCustomersTable.CustomerID, HighValueCustomersTable.CompanyName, HighValueCustomersTable.TotalOrderAmount, CustomerGroupThresholds.CustomerGroupName
from HighValueCustomersTable
join CustomerGroupThresholds on HighValueCustomersTable.TotalOrderAmount between CustomerGroupThresholds.RangeBottom AND CustomerGroupThresholds.RangeTop
order by HighValueCustomersTable.CustomerID

-- #52
select distinct *
from (
select Country
from Customers
union 
select Country
from Suppliers
) tt

-- #53
select distinct Suppliers.Country as SupplierCountry, Customers.Country as CustomerCountry
from Suppliers
full join Customers on Suppliers.Country=Customers.Country

-- #54
with
CustomersCountryTable as
(
select Country, count(*) as TotalCustomers
from Customers
group by Country
),
SuppliersCountryTable as 
(
select Country, count(*) as TotalSuppliers
from Suppliers
group by Country
)
select
	isnull(CustomersCountryTable.Country, SuppliersCountryTable.Country) as Country,
	isnull(SuppliersCountryTable.TotalSuppliers, 0) as TotalSuppliers,
	isnull(CustomersCountryTable.TotalCustomers, 0) as TotalCustomers
from CustomersCountryTable
full outer join SuppliersCountryTable
on CustomersCountryTable.Country=SuppliersCountryTable.Country
order by Country asc

-- #55
with CountryRowTable as
(
select ShipCountry, CustomerID, OrderID, convert(date, OrderDate) as OrderDate, RowNumberPerCountry=row_number() over (partition by ShipCountry order by ShipCountry, OrderID)
from Orders
)
select *
from CountryRowTable
where RowNumberPerCountry=1

-- #56
select InitialOrder.CustomerID, InitialOrder.OrderID as InitialOrderID, InitialOrder.OrderDate as InitialOrderDate, NextOrder.OrderID as NextOrderID, NextOrder.OrderDate as NextOrderDate, datediff(dd, InitialOrder.OrderDate, NextOrder.OrderDate) as DaysBetween
from Orders as InitialOrder
join Orders as NextOrder on InitialOrder.CustomerID=NextOrder.CustomerID
where InitialOrder.OrderID<NextOrder.OrderID and datediff(dd, InitialOrder.OrderDate, NextOrder.OrderDate)<=5
order by InitialOrder.CustomerID, InitialOrder.OrderID

-- #57
with OrdersTableCTE as
(
select Orders.CustomerID, convert(date, OrderDate) as OrderDate, convert(date, lead(OrderDate, 1) over (partition by Orders.CustomerID order by Orders.CustomerID, OrderDate)) as NextOrderDate
from Orders
)
select OrdersTableCTE.OrderDate, OrdersTableCTE.NextOrderDate, datediff(dd, OrderDate, NextOrderDate) as DaysBetweenOrders
from OrdersTableCTE
where datediff(dd, OrdersTableCTE.OrderDate, OrdersTableCTE.NextOrderDate)<=5