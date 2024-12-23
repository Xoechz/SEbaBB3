CREATE TABLE temp_employees AS
SELECT *
FROM employees;

-- Ausgabe 4_1
SELECT *
FROM temp_employees
WHERE JOB_ID LIKE '%MAN'
   OR JOB_ID LIKE '%MGR'
   OR SALARY < 5000
   OR SALARY = 6100;

UPDATE temp_employees
SET salary = salary * 1.05
WHERE JOB_ID LIKE '%MAN'
   OR JOB_ID LIKE '%MGR';
COMMIT;

-- Ausgabe 4_2
SELECT *
FROM temp_employees
WHERE JOB_ID LIKE '%MAN'
   OR JOB_ID LIKE '%MGR'
   OR SALARY < 5000
   OR SALARY = 6100;

UPDATE temp_employees
SET salary = 6100
WHERE SALARY < 5000;

SAVEPOINT sp1;

-- Ausgabe 4_3
SELECT *
FROM temp_employees
WHERE JOB_ID LIKE '%MAN'
   OR JOB_ID LIKE '%MGR'
   OR SALARY < 5000
   OR SALARY = 6100;

DELETE
FROM temp_employees
WHERE 1 = 1;

-- Ausgabe 4_4
SELECT *
FROM temp_employees;

ROLLBACK TO sp1;

-- Ausgabe 4_5
SELECT *
FROM temp_employees
WHERE JOB_ID LIKE '%MAN'
   OR JOB_ID LIKE '%MGR'
   OR SALARY < 5000
   OR SALARY = 6100;

COMMIT;

DROP TABLE temp_employees;
