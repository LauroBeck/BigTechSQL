-- STARGATE 36-MONTH SOVEREIGN PROJECTION
-- ARCHITECT: LAURO SERGIO VASCONCELLOS BECK
-- RANGE: 2026 - 2029 | AGGREGATE GAIN: $124.07B

SET SERVEROUTPUT ON;
SET FEEDBACK OFF;

-- 1. Infrastructure for Analytic Layer
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Stargate_Projection_2029';
EXCEPTION
   WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE Stargate_Projection_2029 (
    Ticker          VARCHAR2(10) PRIMARY KEY,
    Region          VARCHAR2(10),
    Base_Val_2026   NUMBER(12,2),
    CAGR_Alpha      NUMBER(4,3),
    Efficiency_Buff NUMBER(4,3)
);

-- 2. Population of 10-Bank Sovereign Cluster
INSERT ALL
    INTO Stargate_Projection_2029 VALUES ('INTC',   'US',   13.60, 1.18, 1.05)
    INTO Stargate_Projection_2029 VALUES ('GS',     'US',   51.83, 1.09, 1.02)
    INTO Stargate_Projection_2029 VALUES ('JPM',    'US',   41.20, 1.08, 1.01)
    INTO Stargate_Projection_2029 VALUES ('MSFT',   'US',   62.10, 1.15, 1.03)
    INTO Stargate_Projection_2029 VALUES ('WFC',    'US',   20.85, 1.07, 1.01)
    INTO Stargate_Projection_2029 VALUES ('ITUB',   'BR',   23.73, 1.13, 1.07)
    INTO Stargate_Projection_2029 VALUES ('BPAC',   'BR',   10.60, 1.16, 1.06)
    INTO Stargate_Projection_2029 VALUES ('SK_HYN', 'APAC', 35.40, 1.20, 1.04)
    INTO Stargate_Projection_2029 VALUES ('MUFG',   'APAC', 28.40, 1.08, 1.02)
    INTO Stargate_Projection_2029 VALUES ('DBS',    'APAC', 18.50, 1.10, 1.03)
SELECT * FROM DUAL;

COMMIT;

-- 3. Analytic Queries
PROMPT --- INDIVIDUAL NODE GAIN ANALYSIS ---
SELECT 
    Ticker, 
    Region, 
    Base_Val_2026 AS "Start_Val",
    CAST(Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff AS DECIMAL(10,2)) AS "Projected_2029_Val"
FROM Stargate_Projection_2029
ORDER BY Region, (Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff) DESC;

PROMPT --- CLUSTER AGGREGATE SUMMARY ---
SELECT 
    COUNT(*) AS "Total_Nodes",
    SUM(Base_Val_2026) AS "Consolidated_Base_BN",
    CAST(SUM(Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff) AS DECIMAL(10,2)) AS "Consolidated_2029_BN",
    CAST(SUM(Base_Val_2026 * (POWER(CAGR_Alpha, 3) * Efficiency_Buff - 1)) AS DECIMAL(10,2)) AS "Total_Alpha_Gain_BN",
    CAST((SUM(Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff) / SUM(Base_Val_2026) - 1) * 100 AS DECIMAL(5,2)) AS "Cluster_Yield_PCT"
FROM Stargate_Projection_2029;
