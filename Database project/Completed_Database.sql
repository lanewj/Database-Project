--Robert Szymkowicz
--Will Lane
--Scott Mosher

USE master
	GO

IF DB_ID('Lanewj') IS NOT NULL
DROP DATABASE Lanewj

GO

CREATE DATABASE Lanewj
GO

USE Lanewj
GO

CREATE TABLE Supplier (
	SupplierID			INT		IDENTITY	UNIQUE		 ,
	SupplierName		VARCHAR(50)		NOT NULL,
	[Address]			VARCHAR(50)		NOT NULL
);


CREATE TABLE CentralProductDB (
	ProductID		INT					PRIMARY KEY		IDENTITY			NOT NULL,
	[ProductName]			VARCHAR(50)		UNIQUE										NOT NULL,
	[ProductQuantity]		VARCHAR(50)												NOT NULL,
	[SupplierID]			int			REFERENCES Supplier(SupplierID)										NOT NULL,
	[LowQuantity]			BIT												NOT NULL
);


CREATE TABLE Stores(
	StoreID		INT		PRIMARY KEY		IDENTITY 	NOT NULL,
	StoreName	VARCHAR(50),
	[Address]	VARCHAR(50)
)


CREATE TABLE StoreInfo ( 
	StoreID			INT		 REFERENCES Stores(StoreID)	NOT NULL,
	[ProductName]	VARCHAR(50)			UNIQUE REFERENCES	dbo.CentralProductDB(ProductName)		NOT NULL,
	Quantity		INT		NOT NULL,
	Price			FLOAT	NOT NULL,
	MemberPrice		FLOAT	NOT NULL,
	SalePercentage	INT		NOT NULL			DEFAULT 0
)


CREATE TABLE Orders (
	OrderID			INT			NOT NULL,
	[CustomerName]	VARCHAR(50)	NOT NULL,
	[ProductName]	VARCHAR(50)	 REFERENCES dbo.StoreInfo(ProductName) NOT NULL,
	[Quantity]		INT			NOT NULL,
	[Address]		VARCHAR(50)	NOT NULL,
	[StoreID]		INT			NOT NULL
);

----================= INSERTS ======================----
SET IDENTITY_INSERT dbo.Supplier on
INSERT INTO Supplier( SupplierID, SupplierName, Address) VALUES
( 1, 'Gucci', '231 West Collins St'),
( 2, 'Luise V', '2869 Concord Rd'),
( 3, 'Umbrellas R Us', '1600 Pennsylvania Ave NW'),
(4, 'Cowboy Hats and Fishing Poles Emporium', '1234 high St')
SET IDENTITY_INSERT dbo.Supplier off

SET IDENTITY_INSERT dbo.CentralProductDB ON
INSERT INTO CentralProductDB(ProductID, ProductName, ProductQuantity, SupplierID, LowQuantity) VALUES
( 1,'Shoes', 100, 1, 0),
( 2,'Shirts', 200, 2, 0),
( 3,'Flip Flops', 50, 1, 1),
( 4,'Umbrellas', 10, 3, 1),
( 5,'Fishing Poles', 125, 4, 0),
( 6,'Cowboy Hats', 65, 4, 0)
SET IDENTITY_INSERT dbo.CentralProductDB OFF

SET IDENTITY_INSERT dbo.Stores ON
INSERT INTO Stores(StoreID, StoreName, Address) VALUES
(1, 'The Everything Store', '123456789 Brannon Dr'),
(2, 'Fishing Poles and Cowboy Hats Store', '456 Wolf Den dr'),
(3, 'Shoes and Umbrella Store', '987 Dorset Dr')
SET IDENTITY_INSERT dbo.Stores OFf

INSERT INTO StoreInfo(StoreID, ProductName, Quantity, Price, MemberPrice, SalePercentage) VALUES 
(1, 'Shoes', 100, 75.00, 65.00, 10),
(1, 'Cowboy Hats', 65, 150.99, 124.98, 0),
(1, 'Umbrellas', 10, 24.98, 19.99, 15)

INSERT INTO Orders(OrderID, CustomerName, ProductName, Quantity, Address, StoreID) VALUES 
(1, 'Jacob Zimmerman', 'Cowboy Hats', 2, '415 South Poplar', 1),
(2, 'Ms. Jackson', 'Shoes', 15, '123123 West Main St', 1),
(2, 'Ms Jackson', 'Umbrellas', 2, '123123 West Main St', 1),
(3, 'Donny T', 'Shoes', 50, '510 east High st', 1)


--===================STORED PROCEDURES===============================

CREATE PROCEDURE saleProducts
AS
SELECT * 
FROM dbo.StoreInfo 
WHERE(SalePercentage > 0)

--EXEC saleProducts

--========= items that have a low quantity
CREATE PROCEDURE lowQuantity
AS
SELECT ProductName
FROM dbo.CentralProductDB
WHERE (LowQuantity = 1)

--EXEC lowQuantity

--========== update low quantity
CREATE PROCEDURE updateLowQuantity
AS
UPDATE CentralProductDB
SET LowQuantity = 1
WHERE ProductQuantity < 50
SELECT *
FROM dbo.CentralProductDB


--EXEC updateLowQuantity

--==========Process orders
