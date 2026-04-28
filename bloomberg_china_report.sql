-- BLOOMBERG CHINA: SOVEREIGN AGGREGATE REPORT
-- REPORT_ID: BBN_CHN_2026_Q2_SYNC
-- ARCHITECT: LAURO SERGIO VASCONCELLOS BECK

SET SERVEROUTPUT ON;
SET FEEDBACK OFF;
SET PAGESIZE 60;
SET LINESIZE 160;

PROMPT --- [BLOOMBERG CHINA] INDIVIDUAL NODE ANALYSIS (APAC FOCUS) ---

SELECT 
    Ticker AS "NODE", 
    Region AS "CLUSTER", 
    Base_Val_2026 AS "CAP_BASE_BN",
    -- Bloomberg China Yield Model: Base * (CAGR^3) * Efficiency
    CAST(Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff AS DECIMAL(10,2)) AS "PROJ_2029_VAL",
    -- Displaying Efficiency Multiplier for Transparency
    CAST(Efficiency_Buff AS DECIMAL(4,2)) AS "EFF_INDEX"
FROM Stargate_Projection_2029
ORDER BY 
    CASE WHEN Region = 'APAC' THEN 1 ELSE 2 END, -- APAC Priority for China Report
    PROJ_2029_VAL DESC;

PROMPT
PROMPT --- [BLOOMBERG CHINA] CLUSTER AGGREGATE SUMMARY ---

SELECT 
    COUNT(*) AS "TOTAL_NODES",
    SUM(Base_Val_2026) AS "AGG_BASE_BN",
    -- Projected Value at 2029 Maturity
    CAST(SUM(Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff) AS DECIMAL(10,2)) AS "TOTAL_PROJ_BN",
    -- Net Alpha Gain in Sovereign Billions
    CAST(SUM(Base_Val_2026 * (POWER(CAGR_Alpha, 3) * Efficiency_Buff - 1)) AS DECIMAL(10,2)) AS "ALPHA_SURPLUS",
    -- Weighted Cluster Yield
    CAST((SUM(Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff) / SUM(Base_Val_2026) - 1) * 100 AS DECIMAL(5,2)) || '%' AS "YIELD_RATIO"
FROM Stargate_Projection_2029;

