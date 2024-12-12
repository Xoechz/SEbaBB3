DROP TABLE top_salaries;

-- 1
CREATE TABLE top_salaries
(
    salary     NUMBER(8, 2),
    emp_cnt    NUMBER(3) DEFAULT NULL,
    createdBy  VARCHAR2(100),
    dateCreated  TIMESTAMP,
    modifiedBy VARCHAR2(100),
    dateModified TIMESTAMP
);

ALTER TABLE top_salaries
    ADD CONSTRAINT top_salaries_pk PRIMARY KEY (salary);
ALTER TABLE top_salaries
    ADD CONSTRAINT top_salaries_emp_cnt_gt0 CHECK (emp_cnt > 0);

TRUNCATE TABLE top_salaries;

-- 2
CREATE OR REPLACE PROCEDURE InsertTopSalaries(
    pSalary IN NUMBER,
    pEmp_cnt IN NUMBER)
    IS
BEGIN
    INSERT INTO top_salaries (salary, emp_cnt, createdBy, dateCreated, modifiedBy, dateModified)
    VALUES (pSalary, pEmp_cnt, USER, CURRENT_TIMESTAMP, USER, CURRENT_TIMESTAMP);
END;

-- 3
DECLARE
    num NUMBER(3) := 3;
    sal employees.salary%TYPE;
    vEmp_cnt top_salaries.emp_cnt%TYPE;
    CURSOR emp_cursor IS
        SELECT salary, COUNT(*)
        FROM employees
        GROUP BY salary
        ORDER BY salary DESC
        FETCH FIRST num ROWS ONLY;
BEGIN
    OPEN emp_cursor;
    FETCH emp_cursor INTO sal, vEmp_cnt;
    WHILE emp_cursor%FOUND
        LOOP
            InsertTopSalaries(sal, vEmp_cnt);
            FETCH emp_cursor INTO sal, vEmp_cnt;
        END LOOP;
    CLOSE emp_cursor;
END;

ALTER SESSION SET NLS_DATE_FORMAT = 'dd.mm.yyyy hh24:mi:ss';
SELECT *
FROM top_salaries;


