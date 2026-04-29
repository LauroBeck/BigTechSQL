-- MISSION 2026: STARGATE AZURE SQL DOCKER SCHEMA
IF OBJECT_ID('MARKET_DATA_FINAL', 'U') IS NULL
BEGIN
    CREATE TABLE MARKET_DATA_FINAL (
        ticker VARCHAR(20) PRIMARY KEY,
        price_yield DECIMAL(18,4),
        oracle_regime VARCHAR(50),
        sector_signal VARCHAR(255),
        recorded_at DATETIME DEFAULT GETDATE()
    );
END
GO

TRUNCATE TABLE MARKET_DATA_FINAL;
INSERT INTO MARKET_DATA_FINAL (ticker, price_yield, oracle_regime, sector_signal) VALUES 
('SPX', 7128.73, 'FIREWALL_REINFORCED', 'Launchpad 7125; Target 8251.94'),
('NQUSL3010', 4020.31, 'BANKING_FIREWALL', 'Pivot 4000 Support Active'),
('MSFT', 431.67, 'BIG_WAVE_TERACAP', 'Azure +40%; Q3 EPS $4.27'),
('GOOGL', 174.25, 'BIG_WAVE_TERACAP', 'Div 22c; Cloud +48%; Rev $106.88B'),
('NVDA', 885.42, 'BIG_WAVE_TERACAP', 'Blackwell Scaling; AI Sovereign Leadership'),
('META', 491.23, 'MAG7_SUPPORT_REGIME', 'Llama 3 Efficiency; Ad-Rev Breakout'),
('AMZN', 189.50, 'MAG7_SUPPORT_REGIME', 'AWS Re-acceleration; Logistics Alpha'),
('AAPL', 173.12, 'MAG7_SUPPORT_REGIME', 'Services Pivot; Buyback Strength'),
('TSLA', 168.45, 'MAG7_SUPPORT_REGIME', 'FSD V12 Convergence; Energy Storage +22%'),
('USGG20YR', 4.986, 'DURATION_WATCH', 'Yield 4.986%; Duration Ceiling');
GO
