DROP TABLE copyEmps;

CREATE TABLE copyEmps AS
SELECT *
FROM employees;

ALTER TABLE copyEmps ADD PRIMARY KEY (employee_id);

DECLARE
  maxEmp NUMBER;
BEGIN
  SELECT MAX(employee_id) INTO maxEmp
  FROM employees;
  
  FOR i IN 1..100000 LOOP
    INSERT INTO copyEmps (employee_id, last_name, first_name, email, hire_date, job_id, salary, commission_pct, department_id)
    VALUES (maxEmp + i, 'Test' || i, 'Firstname', 'MAIL', SYSDATE, 'JOB', ABS(MOD(DBMS_RANDOM.RANDOM, 10000)), 0.05, MOD(DBMS_RANDOM.RANDOM, 10) * 10);
  END LOOP;
END;
/

SAVEPOINT insertSP;

-- direct UPDATE
DECLARE
  starttime NUMBER;
  total NUMBER;
BEGIN
  starttime := DBMS_UTILITY.GET_TIME();
  UPDATE copyEmps
  SET salary = ROUND(salary + NVL(commission_pct * salary, 0) + POWER(department_id, 3), 2) / 100;
  total := DBMS_UTILITY.GET_TIME() - starttime;
  DBMS_OUTPUT.PUT_LINE('direkt: ' || total / 100 || ' seconds'); 
END;
/

ROLLBACK TO insertSP;

-- UPDATE in loop
DECLARE
  newSalary NUMBER;
  starttime NUMBER;
  total NUMBER;
BEGIN
  starttime := DBMS_UTILITY.GET_TIME();
  FOR c IN (SELECT employee_id, salary, commission_pct, department_id FROM copyEmps) LOOP
    newSalary := ROUND(c.salary + NVL(c.commission_pct * c.salary, 0) + POWER(c.department_id, 3), 2) / 100;
    UPDATE copyEmps
    SET salary = newSalary
    WHERE employee_id = c.employee_id;
  END LOOP;
  total := DBMS_UTILITY.GET_TIME() - starttime;
  DBMS_OUTPUT.PUT_LINE('loop: ' || total / 100 || ' seconds'); 
END;
/

DROP TABLE copyEmps;

