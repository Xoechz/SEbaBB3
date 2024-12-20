
CREATE OR REPLACE TRIGGER log_user_session
    AFTER LOGON
    ON SCHEMA
BEGIN
    INSERT INTO USER_LOGGING (session_id, db_user, login_time, os_user, host_name, ip)
    VALUES (SYS_CONTEXT('USERENV', 'SESSIONID'), USER, SYSTIMESTAMP, SYS_CONTEXT('USERENV', 'OS_USER'),
            SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS'));
END;

-- Ausgabe 3_2
SELECT * FROM USER_LOGGING;