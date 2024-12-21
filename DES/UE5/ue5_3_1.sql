CREATE TABLE USER_LOGGING
(
    session_id NUMBER PRIMARY KEY,
    db_user    VARCHAR2(30),
    login_time TIMESTAMP,
    os_user    VARCHAR2(30),
    host_name  VARCHAR2(30),
    ip         VARCHAR2(40)
);