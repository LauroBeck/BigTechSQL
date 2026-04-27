-- ===============================================================
-- STARGATE CLUSTER: VECTOR INTELLIGENCE & AGENTIC LAYER
-- ENVIRONMENT: ORACLE AI DATABASE 26ai
-- ===============================================================

SET FEEDBACK OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
ALTER SESSION SET CONTAINER = FREEPDB1;

-- 1. SQL DOMAIN: Enforce Stargate Data Standards (New 26ai Feature)
CREATE DOMAIN IF NOT EXISTS STARGATE_ADMIN.ST_VALUATION AS NUMBER(18,2)
    CHECK (VALUE > 0)
    DISPLAY 'Valuation: $' || TO_CHAR(VALUE, '999,999.00') || ' BN';

-- 2. VECTOR ENHANCEMENT: Adding Semantic Intelligence
ALTER TABLE STARGATE_ADMIN.STARGATE_TELEMETRY 
ADD (
    SENTIMENT_VECTOR VECTOR(1536, FLOAT32), -- Optimized for Open-Source Embedding Models
    MARKET_INSIGHT CLOB
);

-- 3. THE AGENTIC SYNC: Update MSFT/IBM with Intelligence Data
-- Using the native 26ai TO_VECTOR for semantic mapping
UPDATE STARGATE_ADMIN.STARGATE_TELEMETRY
SET MARKET_INSIGHT = 'Microsoft Australia Pivot: Sovereignty monopoly secured. High-frequency advantage detected.',
    SENTIMENT_VECTOR = VECTOR('[0.12, -0.04, 0.89, ...]') -- Representation of the "Big Winner" logic
WHERE ticker = 'MSFT';

UPDATE STARGATE_ADMIN.STARGATE_TELEMETRY
SET MARKET_INSIGHT = 'IBM DB2 Gravity Well: Legacy data integration successful. Qubit transition optimal.',
    SENTIMENT_VECTOR = VECTOR('[0.05, 0.45, 0.72, ...]')
WHERE ticker = 'IBM';

COMMIT;

-- 4. VECTOR SIMILARITY REPORT (Finding the "Next Big Winner")
-- This query uses the new <-> (Vector Distance) operator
DECLARE
    v_line VARCHAR2(100) := RPAD('-', 85, '-');
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_line);
    DBMS_OUTPUT.PUT_LINE('      BLOOMBERG: SEMANTIC MARKET ANALYSIS | VECTOR SEARCH 26ai');
    DBMS_OUTPUT.PUT_LINE(v_line);
    DBMS_OUTPUT.PUT_LINE(RPAD('TICKER', 12) || RPAD('SIMILARITY TO MSFT', 25) || 'MARKET INSIGHT');
    DBMS_OUTPUT.PUT_LINE(v_line);

    FOR r IN (
        SELECT 
            t2.ticker,
            VECTOR_DISTANCE(t1.SENTIMENT_VECTOR, t2.SENTIMENT_VECTOR, COSINE) as dist,
            t2.MARKET_INSIGHT
        FROM STARGATE_ADMIN.STARGATE_TELEMETRY t1, STARGATE_ADMIN.STARGATE_TELEMETRY t2
        WHERE t1.ticker = 'MSFT' AND t2.ticker != 'MSFT'
        ORDER BY dist ASC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(r.ticker, 12) || 
            RPAD(TO_CHAR(1 - r.dist, '0.999'), 25) || 
            DBMS_LOB.SUBSTR(r.MARKET_INSIGHT, 45, 1) || '...'
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_line);
    DBMS_OUTPUT.PUT_LINE('STATUS: VECTOR SEARCH ACTIVE | SCHEME: QUANTUM-READY | MISSION 2026: SECURED');
    DBMS_OUTPUT.PUT_LINE(v_line);
END;
/
