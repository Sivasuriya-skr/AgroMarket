-- =====================================================
-- AgroMarketDB - Sprint 1 : Table creation (DDL)
-- Target: MySQL 8
-- =====================================================

CREATE DATABASE IF NOT EXISTS AgroMarketDB;
USE AgroMarketDB;

-- Drop in reverse order of dependency so the script can be re-run safely
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS DeliveryRoute;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Produce;
DROP TABLE IF EXISTS Buyer;
DROP TABLE IF EXISTS Farm;

-- -----------------------------------------------------
-- 1. Farm
-- -----------------------------------------------------
CREATE TABLE Farm (
    FarmID     INT AUTO_INCREMENT PRIMARY KEY,
    FarmName   VARCHAR(100) NOT NULL,
    Region     VARCHAR(50)  NOT NULL,
    OwnerName  VARCHAR(100) NOT NULL
);

-- -----------------------------------------------------
-- 2. Buyer
-- -----------------------------------------------------
CREATE TABLE Buyer (
    BuyerID       INT AUTO_INCREMENT PRIMARY KEY,
    BusinessName  VARCHAR(100) NOT NULL,
    ContactEmail  VARCHAR(100) NOT NULL,
    City          VARCHAR(50)  NOT NULL
);

-- -----------------------------------------------------
-- 3. Produce  (Farm 1 --- N Produce)
-- -----------------------------------------------------
CREATE TABLE Produce (
    ProduceID       INT AUTO_INCREMENT PRIMARY KEY,
    FarmID          INT           NOT NULL,
    CropName        VARCHAR(80)   NOT NULL,
    QuantityKg      DECIMAL(10,2) NOT NULL,
    PricePerKg      DECIMAL(10,2) NOT NULL,
    HarvestDate     DATE          NOT NULL,
    BestBeforeDate  DATE          NOT NULL,
    CONSTRAINT chk_produce_quantity CHECK (QuantityKg >= 0),
    CONSTRAINT fk_produce_farm
        FOREIGN KEY (FarmID) REFERENCES Farm(FarmID)
);

-- -----------------------------------------------------
-- 4. Order  (Buyer 1 --- N Order)
--    `Order` is a reserved word in SQL, so it is quoted with backticks.
-- -----------------------------------------------------
CREATE TABLE `Order` (
    OrderID      INT AUTO_INCREMENT PRIMARY KEY,
    BuyerID      INT           NOT NULL,
    OrderDate    DATE          NOT NULL,
    Status       VARCHAR(20)   NOT NULL DEFAULT 'Placed',
    TotalAmount  DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order_buyer
        FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID)
);

-- -----------------------------------------------------
-- 5. OrderItem  (Order 1 --- N OrderItem, Produce 1 --- N OrderItem)
-- -----------------------------------------------------
CREATE TABLE OrderItem (
    OrderItemID  INT AUTO_INCREMENT PRIMARY KEY,
    OrderID      INT           NOT NULL,
    ProduceID    INT           NOT NULL,
    QuantityKg   DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_orderitem_quantity CHECK (QuantityKg > 0),
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (OrderID)   REFERENCES `Order`(OrderID),
    CONSTRAINT fk_orderitem_produce
        FOREIGN KEY (ProduceID) REFERENCES Produce(ProduceID)
);

-- -----------------------------------------------------
-- 6. DeliveryRoute  (Farm 1 --- N, Buyer 1 --- N)
-- -----------------------------------------------------
CREATE TABLE DeliveryRoute (
    RouteID         INT AUTO_INCREMENT PRIMARY KEY,
    FarmID          INT          NOT NULL,
    BuyerID         INT          NOT NULL,
    DistanceKm      DECIMAL(8,2) NOT NULL,
    EstimatedHours  DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_route_farm
        FOREIGN KEY (FarmID)  REFERENCES Farm(FarmID),
    CONSTRAINT fk_route_buyer
        FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID)
);

-- -----------------------------------------------------
-- Quick check
-- -----------------------------------------------------
SHOW TABLES;