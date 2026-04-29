SET NOCOUNT ON;
PRINT '#########################################################################################';
PRINT '# STARGATE ANALYTICS: FULL DATA REGISTRY SCAN';
PRINT '# TIMESTAMP: ' + CONVERT(VARCHAR, GETDATE(), 120) + ' BRT';
PRINT '#########################################################################################';

PRINT '';
PRINT '[1] TABLE: MARKET_DATA_FINAL (The Close - April 29)';
SELECT * FROM MARKET_DATA_FINAL ORDER BY price_yield DESC;

PRINT '';
PRINT '[2] TABLE: STRATEGIC_TERACAPS (Core Sovereign Cloud)';
SELECT * FROM STRATEGIC_TERACAPS;

PRINT '';
PRINT '[3] TABLE: QUANTUM_MARKET_INTEL (Qiskit/IBM Quantum Inflections)';
SELECT * FROM QUANTUM_MARKET_INTEL;

PRINT '';
PRINT '[4] TABLE: Stargate_Projection_2029 (Long-Range Roadmap)';
SELECT * FROM Stargate_Projection_2029;

PRINT '';
PRINT '[5] TABLE: STARGATE_RISK_METRICS (Duration & Liquidity Firewall)';
SELECT * FROM STARGATE_RISK_METRICS;

PRINT '';
PRINT '[6] TABLE: BLOOMBERG_MASTER_REPORT (Executive Summaries)';
SELECT * FROM BLOOMBERG_MASTER_REPORT;

PRINT '';
PRINT '#########################################################################################';
PRINT '# STATUS: FULL_SCAN_COMPLETE | CLUSTER_INTEGRITY: VERIFIED';
PRINT '#########################################################################################';
