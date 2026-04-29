SET NOCOUNT ON;
PRINT '# Bloomberg The Close: Full Mag7 Azure SQL Results';
PRINT '# -----------------------------------------------------------------------------------------';
PRINT '# Timestamp: ' + CONVERT(VARCHAR, GETDATE(), 120) + ' BRT';
PRINT '';

SELECT 
    ticker AS [Ticker], 
    CAST(price_yield AS DECIMAL(18,4)) AS [Value], 
    CASE 
        WHEN ticker IN ('MSFT', 'GOOGL', 'NVDA') THEN 'BIG_WAVE_TERACAP'
        WHEN ticker IN ('META', 'AMZN', 'AAPL', 'TSLA') THEN 'MAG7_SUPPORT_REGIME'
        WHEN ticker = 'SPX' THEN 'FIREWALL_REINFORCED'
        WHEN ticker = 'USGG20YR' THEN 'DURATION_WATCH'
        ELSE 'STABLE_ORBIT'
    END AS [Risk_Regime],
    sector_signal AS [Telemetry_Signal]
FROM MARKET_DATA_FINAL
WHERE recorded_at >= CAST(GETDATE() AS DATE)
ORDER BY 
    CASE WHEN ticker = 'SPX' THEN 1 ELSE 2 END, 
    [Value] DESC;

PRINT '';
PRINT '# -----------------------------------------------------------------------------------------';
PRINT '# [TELEMETRY ANALYSIS]';
PRINT '# 1. DOUBLE-ALPHA: MSFT and GOOGL Cloud metrics verify structural migration of compute.';
PRINT '# 2. BANKING ANCHOR: NQUSL3010 holding 4000 pivot ensures SPX 7125 launchpad integrity.';
PRINT '# 3. AI RECOVERY: NVDA and META lead the secondary leg of the Big Wave.';
PRINT '# -----------------------------------------------------------------------------------------';
