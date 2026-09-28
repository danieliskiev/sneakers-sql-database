/*
The database is based on a Sneakers Sales Dataset and contains four tables: Brands, Customers, Shoes, and Orders.
The Brands table stores the sneaker brands. BrandID is the Primary Key. One brand can have many shoes.
The Customers table stores customer information such as name, city, country, and phone number. CustomerID is the Primary Key. One customer can have many orders.
The Shoes table stores shoe information such as model, color, and prices. ShoeID is the Primary Key, and BrandID is a Foreign Key that connects each shoe to a brand.
The Orders table stores sales information such as size, condition, payment method, purchase date, and quantity. OrderID is the Primary Key. CustomerID and ShoeID are Foreign Keys that connect each order to a customer and a shoe.
This structure reduces duplicate data and creates clear relationships between the tables.
A CHECK constraint was added to make sure that online orders can only be paid by credit card, while in-store orders can be paid by cash or credit card.
*/

CREATE TABLE Brands
(
    BrandID INT IDENTITY(1,1),
    BrandName VARCHAR(250) NOT NULL,
    CONSTRAINT PK_Brands PRIMARY KEY (BrandID),
    CONSTRAINT UQ_BrandName UNIQUE (BrandName)
)
CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1,1),
    CustomerName VARCHAR(250) NOT NULL,
    City VARCHAR(250) NOT NULL,
    Country VARCHAR(250) NOT NULL,
    PhoneNumber VARCHAR(250) NOT NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_PhoneNumber UNIQUE (PhoneNumber)
)
CREATE TABLE Shoes
(
    ShoeID INT IDENTITY(1,1),
    BrandID INT NOT NULL,
    ShoeModel VARCHAR(250) NOT NULL,
    Color VARCHAR(250) NOT NULL,
    RetailPrice INT NOT NULL,
    ResalePrice INT NOT NULL,
    CONSTRAINT PK_Shoes PRIMARY KEY (ShoeID),
    CONSTRAINT FK_Shoes_Brands FOREIGN KEY (BrandID)
    REFERENCES Brands(BrandID),
    CONSTRAINT CHK_RetailPrice CHECK (RetailPrice > 0),
    CONSTRAINT CHK_ResalePrice CHECK (ResalePrice > 0)
)
CREATE TABLE Orders
(
    OrderID INT IDENTITY(1,1),
    CustomerID INT NOT NULL,
    ShoeID INT NOT NULL,
    SizeNumber INT NOT NULL,
    ShoeCondition VARCHAR(250) NOT NULL,
    PaymentMethod VARCHAR(250) NOT NULL,
    PurchaseDate DATE NOT NULL,
    SalesChannel VARCHAR(250) NOT NULL,
    SellMethod VARCHAR(250) NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Orders_Shoes FOREIGN KEY (ShoeID)
    REFERENCES Shoes(ShoeID),
    CONSTRAINT CHK_Size CHECK (SizeNumber BETWEEN 35 AND 50),
    CONSTRAINT CHK_ShoeCondition CHECK (ShoeCondition IN ('Brand New','Like New','Used')),
    CONSTRAINT CHK_PaymentMethod CHECK (PaymentMethod IN ('Credit Card','Cash')),
    CONSTRAINT CHK_SalesChannel CHECK (SalesChannel IN ('Online','In Store')),
    CONSTRAINT CHK_SellMethod CHECK (SellMethod IN ('Retail','Resale')),
    CONSTRAINT CHK_Quantity CHECK (Quantity > 0)
)
INSERT INTO Brands(BrandName)
SELECT DISTINCT BrandName
FROM [Sneakers Sales Project]

INSERT INTO Customers
(CustomerName,City,Country,PhoneNumber)
SELECT DISTINCT
CustomerName,
City,
Country,
PhoneNumber
FROM [Sneakers Sales Project]

INSERT INTO Shoes
(BrandID,ShoeModel,Color,RetailPrice,ResalePrice)
SELECT DISTINCT
B.BrandID,
S.ShoeModel,
S.Color,
S.RetailPrice,
S.ResalePrice
FROM [Sneakers Sales Project] S
JOIN Brands B
ON S.BrandName = B.BrandName

INSERT INTO Orders
(CustomerID,ShoeID,SizeNumber,ShoeCondition,PaymentMethod,PurchaseDate,SalesChannel,SellMethod,Quantity)
SELECT
C.CustomerID,
SH.ShoeID,
S.SizeNumber,
S.ShoeCondition,
S.PaymentMethod,
S.PurchaseDate,
S.SalesChannel,
S.SellMethod,
S.Quantity
FROM [Sneakers Sales Project] S
JOIN Customers C
ON S.CustomerName = C.CustomerName
JOIN Shoes SH
ON S.ShoeModel = SH.ShoeModel
AND S.Color = SH.Color
AND S.RetailPrice = SH.RetailPrice
AND S.ResalePrice = SH.ResalePrice

ALTER TABLE Orders
ADD CONSTRAINT CHK_OnlinePayment
CHECK
(
    SalesChannel = 'In Store'
    OR PaymentMethod = 'Credit Card'
)
