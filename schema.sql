-- =============================================
-- Inventory & Sales Management System
-- Schema: All Tables
-- =============================================

USE InventorySalesDB;
GO

-- 1. Categories
CREATE TABLE Categories (
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description  NVARCHAR(255)
);
GO

-- 2. Suppliers
CREATE TABLE Suppliers (
    SupplierID   INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(150) NOT NULL,
    ContactName  NVARCHAR(100),
    Phone        NVARCHAR(20),
    Email        NVARCHAR(100),
    Address      NVARCHAR(255)
);
GO

-- 3. Products
CREATE TABLE Products (
    ProductID    INT IDENTITY(1,1) PRIMARY KEY,
    ProductName  NVARCHAR(150) NOT NULL,
    CategoryID   INT NOT NULL,
    SupplierID   INT NOT NULL,
    UnitPrice    DECIMAL(10,2) NOT NULL,
    ReorderLevel INT DEFAULT 10,
    CONSTRAINT FK_Products_Category FOREIGN KEY (CategoryID) 
        REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Products_Supplier FOREIGN KEY (SupplierID) 
        REFERENCES Suppliers(SupplierID)
);
GO

-- 4. Stock
CREATE TABLE Stock (
    StockID     INT IDENTITY(1,1) PRIMARY KEY,
    ProductID   INT NOT NULL UNIQUE,
    Quantity    INT NOT NULL DEFAULT 0,
    LastUpdated DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Stock_Product FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);
GO

-- 5. Customers
CREATE TABLE Customers (
    CustomerID   INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(150) NOT NULL,
    Phone        NVARCHAR(20),
    Email        NVARCHAR(100),
    Address      NVARCHAR(255),
    CreatedAt    DATETIME DEFAULT GETDATE()
);
GO

-- 6. Sales
CREATE TABLE Sales (
    SaleID      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID  INT NOT NULL,
    SaleDate    DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) DEFAULT 0,
    Status      NVARCHAR(20) DEFAULT 'Completed',
    CONSTRAINT FK_Sales_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO

-- 7. SaleItems
CREATE TABLE SaleItems (
    SaleItemID  INT IDENTITY(1,1) PRIMARY KEY,
    SaleID      INT NOT NULL,
    ProductID   INT NOT NULL,
    Quantity    INT NOT NULL,
    UnitPrice   DECIMAL(10,2) NOT NULL,
    Subtotal    AS (Quantity * UnitPrice),
    CONSTRAINT FK_SaleItems_Sale FOREIGN KEY (SaleID)
        REFERENCES Sales(SaleID),
    CONSTRAINT FK_SaleItems_Product FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);
GO

-- 8. Invoices
CREATE TABLE Invoices (
    InvoiceID     INT IDENTITY(1,1) PRIMARY KEY,
    SaleID        INT NOT NULL UNIQUE,
    InvoiceDate   DATETIME DEFAULT GETDATE(),
    AmountDue     DECIMAL(10,2) NOT NULL,
    AmountPaid    DECIMAL(10,2) DEFAULT 0,
    PaymentStatus NVARCHAR(20) DEFAULT 'Unpaid',
    CONSTRAINT FK_Invoices_Sale FOREIGN KEY (SaleID)
        REFERENCES Sales(SaleID)
);
GO

-- 9. Returns
CREATE TABLE Returns (
    ReturnID    INT IDENTITY(1,1) PRIMARY KEY,
    SaleItemID  INT NOT NULL,
    Quantity    INT NOT NULL,
    Reason      NVARCHAR(255),
    ReturnDate  DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Returns_SaleItem FOREIGN KEY (SaleItemID)
        REFERENCES SaleItems(SaleItemID)
);
GO