-- ==========================================================
-- STARGATE GOLD: BLOOMBERG SURVEILLANCE BI SYSTEM
-- ARCHITECT: LAURO SERGIO VASCONCELLOS BECK (SR. ENTERPRISE ARCHITECT)
-- CLUSTER: SQL SERVER 2025 (RTM-CU3)
-- MISSION: EMPLOYMENT MISSION 2026 - SÃO PAULO
-- ==========================================================

USE Stargate_Gold;
GO

-- 1. DROP OBJECTS IF EXIST FOR CLEAN REBUILD
IF OBJECT_ID('dbo.VW_19_Months_Gains_Analysis', 'V') IS NOT NULL DROP VIEW dbo.VW_19_Months_Gains_Analysis;
IF OBJECT_ID('dbo.usp_Generate_Surveillance_Report', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_Generate_Surveillance_Report;
IF OBJECT_ID('dbo.Global_SRI_Telemetry', 'U') IS NOT NULL DROP TABLE dbo.Global_SRI_Telemetry;
IF OBJECT_ID('dbo.Entity_Historical_Performance', 'U') IS NOT NULL DROP TABLE dbo.Entity_Historical_Performance;
IF OBJECT_ID('dbo.Avanade_Accenture_Scheme', 'U') IS NOT NULL DROP TABLE dbo.Avanade_Accenture_Scheme;
IF OBJECT_ID('dbo.ST_Defense_Contracts', 'U') IS NOT NULL DROP TABLE dbo.ST_Defense_Contracts;
IF OBJECT_ID('dbo.Regional_Resiliency', 'U') IS NOT NULL DROP TABLE dbo.Regional_Resiliency;
GO

-- 2. CORE TABLES REBUILD
CREATE TABLE dbo.Avanade_Accenture_Scheme (
    Partner_Lead NVARCHAR(50),
    Bank_Source NVARCHAR(50),
    Projected_Rev_BN DECIMAL(18,2),
    VIX_Index DECIMAL(18,2),
    NDX_Level DECIMAL(18,2),
    Sync_Date DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.Regional_Resiliency (
    Region_Code NVARCHAR(20),
    Liquidity_BN DECIMAL(18,2),
    Sector_Status NVARCHAR(20)
);

CREATE TABLE dbo.ST_Defense_Contracts (
    Ticker NVARCHAR(10) PRIMARY KEY,
    Contract_Value_BN DECIMAL(18,2),
    Target_Price DECIMAL(18,2),
    Rating_Status NVARCHAR(20),
    Sector_Lead NVARCHAR(50)
);

CREATE TABLE dbo.Entity_Historical_Performance (
    Entity_Symbol VARCHAR(10),
    Month_Ref DATE,
    Price_Close DECIMAL(18,2),
    Total_BN_Exposure DECIMAL(18,2)
);

CREATE TABLE dbo.Global_SRI_Telemetry (
    Inst_ID NVARCHAR(20),
    Sector NVARCHAR(50),
    Amount_BN DECIMAL(18,2),
    Execution_Time DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET()
) WITH (DATA_COMPRESSION = PAGE);
GO

-- 3. DATA INGESTION (APRIL 2026 SNAPSHOT)
INSERT INTO dbo.Entity_Historical_Performance VALUES 
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

-- 4. ANALYTICS LAYER
CREATE VIEW dbo.VW_19_Months_Gains_Analysis AS
WITH StartPoints AS (
    SELECT Entity_Symbol, Price_Close as Start_Price, Total_BN_Exposure as Start_BN
    FROM dbo.Entity_Historical_Performance WHERE Month_Ref = '2024-09-01'
),
EndPoints AS (
    SELECT Entity_Symbol, Price_Close as End_Price, Total_BN_Exposure as End_BN
    FROM dbo.Entity_Historical_Performance WHERE Month_Ref = '2026-04-25'
)
SELECT 
    CAST(S.Entity_Symbol AS VARCHAR(10)) as [ENTITY],
    S.Start_Price as [VAL_SEP24],
    E.End_Price as [VAL_APR26],
    CAST(((E.End_Price - S.Start_Price) / S.Start_Price) * 100 AS DECIMAL(18,2)) as [GAIN_PCT],
    CAST(E.End_BN - S.Start_BN AS DECIMAL(18,2)) as [BN_GROWTH]
FROM StartPoints S
JOIN EndPoints E ON S.Entity_Symbol = E.Entity_Symbol;
GO

-- 5. SURVEILLANCE BI REPORT PROCEDURE
CREATE OR ALTER PROCEDURE dbo.usp_Generate_Surveillance_Report
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        ENTITY, VAL_SEP24, VAL_APR26, 
        CAST(GAIN_PCT AS VARCHAR(10)) + '%' as VELOCITY,
        BN_GROWTH,
        CASE WHEN GAIN_PCT > 30 THEN 'OUTPERFORM' ELSE 'STABLE' END AS STATUS
    FROM dbo.VW_19_Months_Gains_Analysis
    ORDER BY GAIN_PCT DESC;
END;
GO
