SET NOCOUNT ON;
PRINT '# Stargate Cluster: SQL Server Table Inventory';
PRINT '# -----------------------------------------------------------------------------------------';
PRINT '# Database: STARGATE_ANALYTICS';
PRINT '# Timestamp: ' + CONVERT(VARCHAR, GETDATE(), 120) + ' BRT';
PRINT '# -----------------------------------------------------------------------------------------';
PRINT '';

SELECT 
    s.name AS [Schema], 
    t.name AS [Table_Name], 
    t.create_date AS [Creation_Date],
    p.rows AS [Row_Count]
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id < 2 -- Filters for Heap or Clustered indexes to avoid duplicate row counts
ORDER BY [Schema], [Table_Name];

PRINT '';
PRINT '# -----------------------------------------------------------------------------------------';
PRINT '# STATUS: INVENTORY_COMPLETE | REGIME: BLOOMBERG_NASDAQ_CONTEXT';
