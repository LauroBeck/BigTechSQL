-- ==========================================================
-- STARGATE GOLD: FULL SPECTRUM BI CONSOLIDATION
-- ARCHITECT: LAURO SERGIO VASCONCELLOS BECK (SR. ENTERPRISE ARCHITECT)
-- ENGINE: SQL SERVER 2025 | MISSION: EMPLOYMENT 2026
-- ==========================================================

USE Stargate_Gold;
GO

SET NOCOUNT ON;

-- 1. ESTRUTURA CORE (DROPS & CREATES)
IF OBJECT_ID('dbo.usp_Generate_Surveillance_Report', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Generate_Surveillance_Report;
IF OBJECT_ID('dbo.VW_19_Months_Gains_Analysis', 'V') IS NOT NULL DROP VIEW dbo.VW_19_Months_Gains_Analysis;
IF OBJECT_ID('dbo.Entity_Historical_Performance', 'U') IS NOT NULL DROP TABLE dbo.Entity_Historical_Performance;
GO

CREATE TABLE dbo.Entity_Historical_Performance (
    Entity_Symbol VARCHAR(10),
    Month_Ref DATE,
    Price_Close DECIMAL(18,2),
    Total_BN_Exposure DECIMAL(18,2)
);
GO

-- 2. INJEÇÃO DE DADOS: FULL NASDAQ SCAN (SEP 2024 - APR 2026)
-- Inclui todas as entidades captadas na telemetria da imagem Nasdaq
INSERT INTO dbo.Entity_Historical_Performance (Entity_Symbol, Month_Ref, Price_Close, Total_BN_Exposure)
VALUES 
('NDX', '2024-09-01', 19800.00, 5.20), ('NDX', '2026-04-25', 27435.00, 8.71),
('CVX', '2024-09-01', 158.40, 1.10), ('CVX', '2026-04-25', 185.21, 1.45),
('IBM', '2024-09-01', 172.10, 0.90), ('IBM', '2026-04-25', 215.40, 1.25),
('ITUB', '2024-09-01', 28.50, 0.40), ('ITUB', '2026-04-25', 36.80, 0.55),
('TSLA', '2024-09-01', 195.40, 0.40), ('TSLA', '2026-04-25', 242.10, 0.69),
('JPM', '2024-09-01', 192.10, 0.80), ('JPM', '2026-04-25', 205.40, 1.20),
('BAC', '2024-09-01', 38.20, 0.30),  ('BAC', '2026-04-25', 44.50, 0.45),
('MS', '2024-09-01', 94.10, 0.25),   ('MS', '2026-04-25', 108.30, 0.38),
('JEPQ', '2024-09-01', 51.40, 0.50),  ('JEPQ', '2026-04-25', 56.10, 0.85);
GO

-- 3. ANALYTICS ENGINE (VIEW)
CREATE VIEW dbo.VW_19_Months_Gains_Analysis AS
WITH Metrics AS (
    SELECT 
        S.Entity_Symbol,
        S.Price_Close as Start_Price,
        E.Price_Close as End_Price,
        S.Total_BN_Exposure as Start_BN,
        E.Total_BN_Exposure as End_BN
    FROM (SELECT * FROM dbo.Entity_Historical_Performance WHERE Month_Ref = '2024-09-01') S
    JOIN (SELECT * FROM dbo.Entity_Historical_Performance WHERE Month_Ref = '2026-04-25') E 
      ON S.Entity_Symbol = E.Entity_Symbol
)
SELECT 
    CAST(Entity_Symbol AS VARCHAR(10)) as [ENTITY],
    CAST(Start_Price AS DECIMAL(18,2)) as [SEP_24],
    CAST(End_Price AS DECIMAL(18,2)) as [APR_26],
    CAST(((End_Price - Start_Price) / Start_Price) * 100 AS DECIMAL(18,2)) as [GAIN_PCT],
    CAST(End_BN - Start_BN AS DECIMAL(18,2)) as [EXPANSION_BN],
    CASE 
        WHEN ((End_Price - Start_Price) / Start_Price) * 100 > 30 THEN 'OUTPERFORM'
        WHEN ((End_Price - Start_Price) / Start_Price) * 100 BETWEEN 15 AND 30 THEN 'RESILIENT'
        ELSE 'HEDGE'
    END AS [STATUS]
FROM Metrics;
GO

-- 4. BLOOMBERG SURVEILLANCE REPORT (PROCEDURE)
CREATE PROCEDURE dbo.usp_Generate_Surveillance_Report
AS
BEGIN
    PRINT '================================================================================';
    PRINT '        BLOOMBERG SURVEILLANCE - FULL ENTITY ANALYSIS (19-MONTHS)             ';
    PRINT '================================================================================';
    SELECT * FROM dbo.VW_19_Months_Gains_Analysis ORDER BY GAIN_PCT DESC;
    
    PRINT '';
    PRINT '--- CONSOLIDATED RISK EXPOSURE ---';
    SELECT 
        'TOTAL STARGATE ASSETS' as Metric,
        CAST(SUM(Total_BN_Exposure) AS DECIMAL(18,2)) as [Value_BN],
        (SELECT CAST(AVG(GAIN_PCT) AS DECIMAL(18,2)) FROM dbo.VW_19_Months_Gains_Analysis) as [Avg_Yield]
    FROM dbo.Entity_Historical_Performance WHERE Month_Ref = '2026-04-25';
    PRINT '================================================================================';
END;
GO

-- 5. FINAL EXECUTION (CAT/OEF)
EXEC dbo.usp_Generate_Surveillance_Report;
