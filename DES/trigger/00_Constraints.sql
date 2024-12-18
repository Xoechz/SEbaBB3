-- Examples CONSTRAINTS
-- from https://docs.oracle.com/cd/B19306_01/server.102/b14200/clauses002.htm

-- CHECK constraint
CREATE TABLE divisions  
   (
    div_no    NUMBER  
              CONSTRAINT check_divno -- constraint name (optional)
              CHECK (div_no BETWEEN 10 AND 99), 

    div_name  VARCHAR2(9)  CONSTRAINT check_divname
              CHECK (div_name = UPPER(div_name)),

    office    VARCHAR2(10)  CONSTRAINT check_office
              CHECK (office IN ('DALLAS', 'BOSTON', 'PARIS', 'TOKYO'))
    
    ); 

INSERT INTO divisions VALUES (10, 'FIRST', 'HAGENBERG'); -- CHECK-Constraint (<USER>.CHECK_OFFICE) verletzt
INSERT INTO divisions VALUES (10, 'first', 'DALLAS'); -- CHECK-Constraint (<USER>.CHECK_DIVNAME) verletzt
INSERT INTO divisions VALUES (9, 'FIRST', 'DALLAS'); -- CHECK-Constraint (<USER>.CHECK_DIVNO) verletzt

-- CHECK constraint, multiple columns
CREATE TABLE dept_20
   (employee_id     NUMBER(4) PRIMARY KEY, 
    last_name       VARCHAR2(10), 
    job_id          VARCHAR2(9), 
    manager_id      NUMBER(4), 
    salary          NUMBER(7,2), 
    commission_pct  NUMBER(7,2), 
    department_id   NUMBER(2),
    CONSTRAINT check_sal CHECK (salary * commission_pct <= 5000));

-- ======================================================================
-- FOREIGN KEY Constraint
-- The following statement creates the dept_20 table and defines and enables a foreign key on the 
--   department_id column that references the primary key on the department_id column of the departments table
--   and a ON DELETE CASCADE option if a referenced department is deleted in the departments table
CREATE TABLE dept_20 
   (employee_id     NUMBER(4), 
    last_name       VARCHAR2(10), 
    job_id          VARCHAR2(9), 
    manager_id      NUMBER(4), 
    hire_date       DATE, 
    salary          NUMBER(7,2), 
    commission_pct  NUMBER(7,2), 
    department_id   CONSTRAINT fk_deptno 
                    REFERENCES departments(department_id)
                    ON DELETE CASCADE ); 

-- ======================================================================
-- UNIQUE constraint
-- table games with a INITIALLY IMMEDIATE NOT DEFERRABLE (=default) constraint check on the scores column
CREATE TABLE games (scores NUMBER CHECK (scores >= 0));

-- I) UNIQUE constraint DEFERRABLE and INITIALLY DEFERRED
-- To define a unique constraint on a column as INITIALLY DEFERRED DEFERRABLE
CREATE TABLE games
  (scores NUMBER, CONSTRAINT unq_num UNIQUE (scores)
   INITIALLY DEFERRED DEFERRABLE); -- [REMARK] It can be better to think it through the other way arround: DEFFERABLE (Can it be deferred?), INITIALLY DEFERRED (What is the initial state?)
   -- DEFERRED TO END OF TRANSACTION (COMMIT)
   -- IMMEDIATE ON ACTION: INSERT/UPDATE
/
INSERT INTO games VALUES (100);
INSERT INTO games VALUES (100); -- possible due to unq_num being in state DEFERRED; check is placed to the end of the transaction
/
SET CONSTRAINT unq_num IMMEDIATE; -- shows error message
/
COMMIT; -- (end of transaction) checks for the constraint and rejects inserted data / back to last consistent state

-- ==========================================================
-- DROP TABLE games;
-- II) UNIQUE constraint DEFERRABLE and INITIALLY DEFERRED
-- To define a unique constraint on a column as INITIALLY IMMEDIATE NOT DEFERRABLE (=default)
CREATE TABLE games
  (scores NUMBER, CONSTRAINT unq_num UNIQUE (scores));
/
INSERT INTO games VALUES (100);
INSERT INTO games VALUES (100); -- unq_num constraint rejects the insert