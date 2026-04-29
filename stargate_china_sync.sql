-- BLOOMBERG CHINA LIVE SYNC
-- SOURCE: 23:36 BRT BROADCAST (WINNIE HSU)
-- DATE: APRIL 27, 2026

-- 1. Precision Update for SK Hynix (APAC Node)
UPDATE Stargate_Projection_2029
SET Base_Val_2026 = 35.4 * 1.0155 -- Applying the +1.55% live gain
WHERE Ticker = 'SK_HYN';

-- 2. Precision Update for APAC Efficiency Index
-- KOSPI at 6,675.10 (+0.91%) warrants an efficiency buffer bump
UPDATE Stargate_Projection_2029
SET Efficiency_Buff = 1.045
WHERE Region = 'APAC';

COMMIT;

-- 3. Live Validation Select
PROMPT --- [LIVE SYNC STATUS: BLOOMBERG CHINA] ---
SELECT 
    Ticker, 
    CAST(Base_Val_2026 AS DECIMAL(10,2)) AS "LIVE_BASE_BN",
    CAST(Base_Val_2026 * POWER(CAGR_Alpha, 3) * Efficiency_Buff AS DECIMAL(10,2)) AS "REAL_TIME_PROJ_2029"
FROM Stargate_Projection_2029
WHERE Ticker = 'SK_HYN';
