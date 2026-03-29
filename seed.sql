-- =============================================
-- Inventory & Sales Management System
-- Seed Data: Sample Records
-- =============================================

USE InventorySalesDB;
GO

-- 1. Categories
INSERT INTO Categories (CategoryName, Description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Food & Beverages', 'Groceries and consumables'),
('Stationery', 'Office and school supplies'),
('Clothing', 'Apparel and accessories'),
('Household', 'Home and kitchen items');
GO

-- 2. Suppliers
INSERT INTO Suppliers (SupplierName, ContactName, Phone, Email, Address) VALUES
('Melcom Ghana', 'Kofi Mensah', '0244001122', 'kofi@melcom.com', 'Accra, Ghana'),
('Kasapreko Company', 'Ama Owusu', '0244003344', 'ama@kasapreko.com', 'Kumasi, Ghana'),
('Staples Ghana', 'Yaw Darko', '0244005566', 'yaw@staples.com', 'Takoradi, Ghana'),
('Woodin Fabrics', 'Abena Asante', '0244007788', 'abena@woodin.com', 'Accra, Ghana');
GO

-- 3. Products
INSERT INTO Products (ProductName, CategoryID, SupplierID, UnitPrice, ReorderLevel) VALUES
('Samsung Galaxy A15', 1, 1, 1200.00, 5),
('Tecno Spark 20', 1, 1, 950.00, 5),
('Kasapreko Water 1.5L', 2, 2, 3.50, 50),
('Kasapreko Juice 500ml', 2, 2, 5.00, 50),
('A4 Paper Ream', 3, 3, 45.00, 20),
('Ballpoint Pen Pack', 3, 3, 12.00, 30),
('Woodin Ankara Fabric', 4, 4, 85.00, 10),
('Kitchen Knife Set', 5, 1, 75.00, 10),
('Wireless Earbuds', 1, 1, 180.00, 8),
('Exercise Book Pack', 3, 3, 18.00, 25);
GO

-- 4. Stock
INSERT INTO Stock (ProductID, Quantity) VALUES
(1, 30),
(2, 25),
(3, 200),
(4, 150),
(5, 80),
(6, 100),
(7, 40),
(8, 35),
(9, 60),
(10, 90);
GO

-- 5. Customers
INSERT INTO Customers (CustomerName, Phone, Email, Address) VALUES
('Kwame Boateng', '0557001122', 'kwame@gmail.com', 'Kumasi, Ghana'),
('Akosua Frimpong', '0557003344', 'akosua@gmail.com', 'Accra, Ghana'),
('Fiifi Entsie', '0557005566', 'fiifi@gmail.com', 'Cape Coast, Ghana'),
('Adwoa Mensah', '0557007788', 'adwoa@gmail.com', 'Tamale, Ghana'),
('Kofi Asare', '0557009900', 'kofi@gmail.com', 'Sunyani, Ghana');
GO

-- 6. Sales
INSERT INTO Sales (CustomerID, TotalAmount, Status) VALUES
(1, 1380.00, 'Completed'),
(2, 53.50, 'Completed'),
(3, 57.00, 'Completed'),
(4, 180.00, 'Completed'),
(5, 963.00, 'Completed');
GO

-- 7. SaleItems
INSERT INTO SaleItems (SaleID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 1200.00),
(1, 6, 3, 12.00),
(1, 3, 20, 3.50),
(2, 3, 5, 3.50),
(2, 4, 6, 5.00),
(3, 5, 1, 45.00),
(3, 6, 1, 12.00),
(4, 9, 1, 180.00),
(5, 2, 1, 950.00),
(5, 6, 1, 12.00);
GO

-- 8. Invoices
INSERT INTO Invoices (SaleID, AmountDue, AmountPaid, PaymentStatus) VALUES
(1, 1380.00, 1380.00, 'Paid'),
(2, 53.50, 30.00, 'Partial'),
(3, 57.00, 57.00, 'Paid'),
(4, 180.00, 0.00, 'Unpaid'),
(5, 963.00, 963.00, 'Paid');
GO

-- 9. Returns
INSERT INTO Returns (SaleItemID, Quantity, Reason) VALUES
(3, 5, 'Excess quantity ordered'),
(8, 1, 'Defective item');
GO