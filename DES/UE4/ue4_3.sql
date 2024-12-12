CREATE OR REPLACE PACKAGE top_salary_pkg AS
    PROCEDURE GetTopSalaries(pLowSalary IN NUMBER, pHighSalary IN NUMBER);
    PROCEDURE DoubleTopSalaries(pLowSalary IN NUMBER, pHighSalary IN NUMBER);
    PROCEDURE FillTopSalaries(pNum IN NUMBER);
END;

CREATE OR REPLACE PACKAGE BODY top_salary_pkg AS
    PROCEDURE GetTopSalaries(pLowSalary IN NUMBER, pHighSalary IN NUMBER)
        IS
        CURSOR cTopSalaries IS
            SELECT 'Salary:' || TO_CHAR(SALARY) || '. EmpCnt:' || TO_CHAR(EMP_CNT) ||
                   '. Erstellt:' || TO_CHAR(CREATEDBY) || '/' || TO_CHAR(DATECREATED) ||
                   '. Geändert:' || TO_CHAR(MODIFIEDBY) || '/' || TO_CHAR(DATEMODIFIED) || '.' text
            FROM top_salaries
            WHERE SALARY BETWEEN pLowSalary AND pHighSalary
            ORDER BY SALARY DESC;
    BEGIN
        FOR vTopSalaries IN cTopSalaries
            LOOP
                DBMS_OUTPUT.PUT_LINE(vTopSalaries.text);
            END LOOP;
    END;
    PROCEDURE DoubleTopSalaries(
        pLowSalary IN NUMBER,
        pHighSalary IN NUMBER)
        IS
        CURSOR cTopSalaries IS
            SELECT salary, MODIFIEDBY, DATEMODIFIED
            FROM top_salaries
            WHERE salary BETWEEN pLowSalary AND pHighSalary
            FOR UPDATE OF salary, MODIFIEDBY, DATEMODIFIED NOWAIT;
    BEGIN
        FOR vTopSalaries IN cTopSalaries
            LOOP
                UPDATE top_salaries
                SET salary       = salary * 2,
                    MODIFIEDBY   = USER,
                    DATEMODIFIED = CURRENT_TIMESTAMP
                WHERE CURRENT OF cTopSalaries;
            END LOOP;
    END;
    PROCEDURE FillTopSalaries(pNum IN NUMBER)
        IS
        sal employees.salary%TYPE;
        vEmp_cnt top_salaries.emp_cnt%TYPE;
        CURSOR emp_cursor IS
            SELECT salary, COUNT(*)
            FROM employees
            GROUP BY salary
            ORDER BY salary DESC
            FETCH FIRST pNum ROWS ONLY;
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
END;

TRUNCATE TABLE top_salaries;
ALTER SESSION SET nls_date_format = 'dd.mm.yyyy hh24:mi:ss';
BEGIN
    top_salary_pkg.FillTopSalaries(3);
    dbms_output.put_line('....................');
    top_salary_pkg.GetTopSalaries(0, 100000);
    dbms_output.put_line('....................');
    top_salary_pkg.DoubleTopSalaries(11000, 13500);
    dbms_output.put_line('....................');
    top_salary_pkg.GetTopSalaries(0, 100000);
    dbms_output.put_line('....................');
END;

BEGIN
    top_salary_pkg.GetTopSalaries(0, 100000);
END;