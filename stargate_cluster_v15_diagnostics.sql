USE MarketData;
GO
SELECT 
    Symbol AS [Ticker], 
    FORMAT([Close], 'C2') AS [Mkt_Close], 
    FORMAT(AfterHours, 'C2') AS [Late_Tape],
    FORMAT(AfterHours - [Close], 'C2') AS [AH_Delta],
    CAST(((AfterHours - [Close]) / [Close]) * 100 AS DECIMAL(10,4)) AS [Slippage_Pct]
FROM HistoricalQuotes 
WHERE AfterHours IS NOT NULL
ORDER BY [Slippage_Pct] DESC;
GO
