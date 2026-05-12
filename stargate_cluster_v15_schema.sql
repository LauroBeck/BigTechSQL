-- ==================================================================================
-- STARGATE CLUSTER: FULL SYSTEM SCHEMA & ETL LOAD
-- DATA DATE: MAY 11, 2026
-- ==================================================================================
USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'MarketData') CREATE DATABASE MarketData;
GO
USE MarketData;
GO

-- SCHEMA SETUP
CREATE TABLE HistoricalQuotes (
    Symbol NVARCHAR(10) PRIMARY KEY,
    [Close] MONEY,
    AfterHours MONEY,
    Volume BIGINT,
    QuoteDate DATE DEFAULT '2026-05-11'
);

CREATE TABLE InstitutionalHoldings (
    IssuerName NVARCHAR(100),
    SharesHeld BIGINT
);

-- DATA INJECTION (FROM NASDAQ CAPTURES)
INSERT INTO HistoricalQuotes (Symbol, [Close], AfterHours) VALUES 
('MSFT', 411.82, 412.66),
('TSLA', 444.19, 445.08),
('IBM',  223.55, 223.57),
('JPM',  299.92, 300.00),
('BAC',  50.53,  50.59),
('MS',   191.06, 191.25),
('BK',   130.69, 130.50),
('CVX',  184.76, 184.72),
('JEPQ', 59.72,  59.71),
('AAPL', 292.68, 292.68),
('AMZN', 268.99, 268.99),
('ITUB', 8.18,   8.18),
('NU',   11.85,  11.85),
('HSBC', 90.52,  90.52);

INSERT INTO InstitutionalHoldings VALUES 
('Microsoft Corp', 6200000000),
('Tesla Inc', 411000000),
('Amazon.com Inc', 710000000),
('Apple Inc', 915000000),
('JPMorgan Chase & Co', 270000000);
GO
