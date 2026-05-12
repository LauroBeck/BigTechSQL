USE MarketData;
GO
CREATE OR ALTER VIEW vw_MarketSummary AS
SELECT 
    CAST(p.Symbol AS CHAR(6)) AS [Ticker],
    CAST(FORMAT(p.[Close], 'C2') AS CHAR(12)) AS [Price],
    (p.[Close] * h.SharesHeld) AS [RawValue],
    FORMAT(p.[Close] * h.SharesHeld, 'C0', 'en-US') AS [Market_Value],
    FORMAT((p.[Close] * h.SharesHeld) * 1.16, 'C0', 'en-US') AS [Proj_2028]
FROM HistoricalQuotes p
JOIN InstitutionalHoldings h ON 
    (p.Symbol = 'MSFT' AND h.IssuerName = 'Microsoft Corp') OR
    (p.Symbol = 'TSLA' AND h.IssuerName = 'Tesla Inc') OR
    (p.Symbol = 'AMZN' AND h.IssuerName = 'Amazon.com Inc') OR
    (p.Symbol = 'AAPL' AND h.IssuerName = 'Apple Inc') OR
    (p.Symbol = 'JPM'  AND h.IssuerName = 'JPMorgan Chase & Co');
GO
