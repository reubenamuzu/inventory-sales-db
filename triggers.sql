-- =============================================
-- Inventory & Sales Management System
-- Triggers
-- Author: Reuben Korsi Amuzu
-- =============================================

USE InventorySalesDB;
GO

-- Trigger 1: Reduce stock when a sale item is recorded
CREATE TRIGGER trg_AfterSaleItem_UpdateStock
ON SaleItems
AFTER INSERT
AS
BEGIN
    UPDATE Stock
    SET 
        Stock.Quantity    = Stock.Quantity - i.Quantity,
        Stock.LastUpdated = GETDATE()
    FROM Stock
    JOIN inserted i ON Stock.ProductID = i.ProductID;
END;
GO

-- Trigger 2: Increase stock when a return is recorded
CREATE TRIGGER trg_AfterReturn_UpdateStock
ON Returns
AFTER INSERT
AS
BEGIN
    UPDATE Stock
    SET
        Stock.Quantity    = Stock.Quantity + i.Quantity,
        Stock.LastUpdated = GETDATE()
    FROM Stock
    JOIN SaleItems si ON Stock.ProductID = si.ProductID
    JOIN inserted i    ON si.SaleItemID  = i.SaleItemID;
END;
GO