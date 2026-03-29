-- =============================================
-- Inventory & Sales Management System
-- Views
-- Author: Reuben Korsi Amuzu
-- =============================================

USE InventorySalesDB;
GO

-- View 1: Sales summary
CREATE VIEW vw_SalesSummary
AS
SELECT
    s.SaleID,
    c.CustomerName,
    p.ProductName,
    si.Quantity,
    si.UnitPrice,
    si.Subtotal,
    s.SaleDate,
    s.Status,
    i.PaymentStatus
FROM Sales s
JOIN Customers c  ON s.CustomerID  = c.CustomerID
JOIN SaleItems si ON s.SaleID      = si.SaleID
JOIN Products p   ON si.ProductID  = p.ProductID
JOIN Invoices i   ON s.SaleID      = i.SaleID;
GO


-- View 2: Low stock alert
CREATE VIEW vw_LowStock
AS
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    st.Quantity AS CurrentStock,
    p.ReorderLevel,
    s.SupplierName,
    s.Phone AS SupplierPhone
FROM Products p
JOIN Stock st      ON p.ProductID    = st.ProductID
JOIN Categories c  ON p.CategoryID   = c.CategoryID
JOIN Suppliers s   ON p.SupplierID   = s.SupplierID
WHERE st.Quantity <= p.ReorderLevel;
GO

-- View 3: Best selling products
CREATE VIEW vw_BestSellers
AS
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    SUM(si.Quantity)  AS TotalUnitsSold,
    SUM(si.Subtotal)  AS TotalRevenue
FROM Products p
JOIN SaleItems si ON p.ProductID  = si.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY p.ProductID, p.ProductName, c.CategoryName;
GO

-- View 4: Customer purchase summary
CREATE VIEW vw_CustomerSummary
AS
SELECT
    c.CustomerID,
    c.CustomerName,
    c.Phone,
    COUNT(DISTINCT s.SaleID)  AS TotalTransactions,
    SUM(si.Quantity)          AS TotalItemsBought,
    SUM(si.Subtotal)          AS TotalSpent,
    MAX(s.SaleDate)           AS LastPurchaseDate
FROM Customers c
JOIN Sales s     ON c.CustomerID = s.CustomerID
JOIN SaleItems si ON s.SaleID   = si.SaleID
GROUP BY c.CustomerID, c.CustomerName, c.Phone;
GO