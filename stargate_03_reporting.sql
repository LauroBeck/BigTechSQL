USE MarketData;
GO
SELECT Ticker, FORMAT(Price, 'C2') AS [Live_Close], Market_Value, Proj_2028 
FROM vw_MarketSummary ORDER BY RawValue DESC;
SELECT 'AGGREGATE' AS [Sum], FORMAT(SUM(RawValue), 'C0', 'en-US') AS [Total_Port], 
FORMAT(SUM(RawValue * 1.16), 'C0', 'en-US') AS [Forecast_2028] FROM vw_MarketSummary;
SELECT Symbol AS [Ticker], FORMAT([Close], 'C2') AS [Mkt_Close], FORMAT(AfterHours, 'C2') AS [Late_Tape],
CAST(((AfterHours - [Close]) / [Close]) * 100 AS DECIMAL(10,4)) AS [Slippage_%]
FROM HistoricalQuotes WHERE AfterHours IS NOT NULL ORDER BY [Slippage_%] DESC;
GO
