-- STARGATE PROJECT: BLOOMBERG MISSION REPORT
SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK OFF

DECLARE
    CURSOR c_mission IS
        SELECT partner_lead, SUM(estimated_consortium_earnings_bn) AS rev_now,
               ROUND(SUM(estimated_consortium_earnings_bn) * POWER(1.14, 1.5), 2) AS rev_18m,
               MAX(nvda_current_valuation) AS anchor, COUNT(*) AS banks
        FROM MV_STARGATE_REVENUE_BRIDGE GROUP BY partner_lead;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
    DBMS_OUTPUT.PUT_LINE('BLOOMBERG TERMINAL | ORACLE MISSION INTELLIGENCE');
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
    DBMS_OUTPUT.PUT_LINE(RPAD('PARTNER', 15) || RPAD('NOW $BN', 12) || RPAD('18M $BN', 12) || RPAD('DRIFT +5%', 15) || 'INST');
    FOR r IN c_mission LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(r.partner_lead, 15) || RPAD(r.rev_now, 12) || RPAD(r.rev_18m, 12) || RPAD(r.rev_now*0.05, 15) || r.banks);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
END;
/
