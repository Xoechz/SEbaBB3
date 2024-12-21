-- Test: Open two parallel Sessions
-- NORMAL_USER  = Pxxx
-- DEMO_USER    = DEMOxx 

-- as normal user                                   | -- as demo user
                                                    |
                                                      SELECT * FROM Pxx.employees;
                                                    |  -- fails
                                                    |
GRANT SELECT ON employees TO DEMOxx;                |
                                                    |
                                                      SELECT * FROM USER_TAB_PRIVS;
                                                      SELECT * FROM Pxx.employees;
                                                    | -- works
                                                      DELETE FROM Pxx.employees;
                                                      -- still fails
                                                    |
REVOKE ALL ON employees FROM DEMOxx;                |
                                                    |
                                                      SELECT * FROM NORMAL_USER.employees;
                                                      SELECT * FROM USER_TAB_PRIVS;
                                                    