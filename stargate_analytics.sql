-- STARGATE PROJECT: ANALYTICS & REVENUE BRIDGE
ALTER SESSION SET CURRENT_SCHEMA = STARGATE_ADMIN;

-- 1. Revenue Bridge Materialized View
CREATE MATERIALIZED VIEW MV_STARGATE_REVENUE_BRIDGE
REFRESH COMPLETE ON DEMAND
AS
SELECT 
    b.bank_name,
    b.partner_lead,
    CASE 
        WHEN b.implementation_phase LIKE '%Phase 4%' THEN 2.5 
        WHEN b.implementation_phase LIKE '%Phase 2%' THEN 4.8 
        WHEN b.implementation_phase LIKE '%Phase 1%' THEN 1.2 
        ELSE 2.0
    END AS estimated_consortium_earnings_bn,
    nvda.market_cap_bn AS nvda_current_valuation,
    msft.market_cap_bn AS msft_current_valuation
FROM STARGATE_US_BANK_GAINS b
CROSS JOIN (SELECT market_cap_bn FROM ST_MARKET_ASSETS WHERE ticker = 'NVDA') nvda
CROSS JOIN (SELECT market_cap_bn FROM ST_MARKET_ASSETS WHERE ticker = 'MSFT') msft;

-- 2. 18-Month Mission Elasticity Query
SELECT 
    partner_lead,
    SUM(estimated_consortium_earnings_bn) AS current_rev_bn,
    ROUND(SUM(estimated_consortium_earnings_bn) * POWER(1.14, 1.5), 2) AS est_18m_revenue_bn,
    ROUND((SUM(estimated_consortium_earnings_bn) * POWER(1.14, 1.5)) * 0.05, 2) AS future_5pct_drift_impact_bn
FROM MV_STARGATE_REVENUE_BRIDGE
GROUP BY partner_lead;
