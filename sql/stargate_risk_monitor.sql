SET NOCOUNT ON;
SELECT 
    ticker AS [Asset],
    [Value] = price_yield,
    [Risk_Factor] = CASE 
        WHEN ticker = 'USGG20YR' AND price_yield > 5.000 THEN 'CRITICAL_BREAK'
        WHEN ticker = 'NQUSL3010' AND price_yield < 3990 THEN 'LIQUIDITY_DRAIN'
        WHEN ticker = 'SPX' AND price_yield > 7125 THEN 'BULL_LAUNCH'
        ELSE 'STABLE_ORBIT'
    END,
    [System_Action] = CASE
        WHEN ticker = 'USGG20YR' AND price_yield > 5.000 THEN 'ALERT: TERMINATE DURATION EXPOSURE'
        WHEN ticker = 'SPX' AND price_yield > 7125 THEN 'EXECUTE: STAIRCASE ACCUMULATION'
        ELSE 'HOLD: SOVEREIGN POSITIONING'
    END
FROM MARKET_DATA_FINAL
WHERE ticker IN ('USGG20YR', 'NQUSL3010', 'SPX')
ORDER BY [Value] DESC;
