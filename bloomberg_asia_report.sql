-- BLOOMBERG ASIA ORACLE REPORT: EXECUTIVE DASHBOARD
SET FEEDBACK OFF
SET PAGESIZE 50
SET LINESIZE 140
COLUMN BRAND_NAME FORMAT A15
COLUMN STATUS FORMAT A10
COLUMN STRATEGIC_INFLECTION FORMAT A45

PROMPT ----------------------------------------------------------------------------------------------------
PROMPT                                BLOOMBERG ASIA ORACLE REPORT
PROMPT                                    EXECUTIVE DASHBOARD
PROMPT ----------------------------------------------------------------------------------------------------

SELECT 
    BRAND_NAME,
    APR_2026 as "APR 2026 ($B)",
    OCT_2028_PROJ as "OCT 2028 PROJ ($B)",
    STATUS,
    CASE 
        WHEN BRAND_NAME = 'Tesla'          THEN '$25B AI CapEx / India Y-L'
        WHEN BRAND_NAME = 'BYD'            THEN 'Malaysia Hub / Vertical Int.'
        WHEN BRAND_NAME = 'JP Morgan'      THEN 'AI-Treasury / Systemic Lead'
        WHEN BRAND_NAME = 'NextEra Energy' THEN 'AI Power / Nuclear Pivot'
        WHEN BRAND_NAME = 'BNY Mellon'     THEN '$59.4T AUC/A / Record Q1'
        ELSE 'Hybrid/Energy Stability'
    END AS STRATEGIC_INFLECTION
FROM TERACAP_TELEMETRY_VIEW
ORDER BY OCT_2028_PROJ DESC;

PROMPT ----------------------------------------------------------------------------------------------------
PROMPT Telemetry Refresh: April 26, 2026 | Source: BNY Q1 Earnings / MS Tech Diffusion
PROMPT ----------------------------------------------------------------------------------------------------
