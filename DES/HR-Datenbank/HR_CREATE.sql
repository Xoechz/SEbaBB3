-- create all tables, views and other database objects
-- ********************************************************************
-- Create the REGIONS table to hold region information for locations
-- HR.LOCATIONS table has a foreign key to this table.
--******  Creating REGIONS TABLE ....
CREATE TABLE regions
   ( region_id      NUMBER 
      CONSTRAINT  region_id_nn NOT NULL 
   , region_name    VARCHAR2(25) 
   );
CREATE UNIQUE INDEX reg_id_pk
ON regions (region_id);
ALTER TABLE regions
ADD ( CONSTRAINT reg_id_pk
         PRIMARY KEY (region_id)
   );
-- ********************************************************************
-- Create the COUNTRIES table to hold country information for company locations. 
-- HR.LOCATIONS has a foreign key to this table.
--******  Creating COUNTRIES TABLE ....
CREATE TABLE countries 
   ( country_id      CHAR(2) 
      CONSTRAINT  country_id_nn NOT NULL 
   , country_name    VARCHAR2(40) 
   , region_id       NUMBER 
   , CONSTRAINT     country_c_id_pk 
             PRIMARY KEY (country_id) 
   ) 
   ORGANIZATION INDEX;  
-- ORGANIZATION INDEX erzeugt eine indexorganisierte Tabelle, in der
-- alle Daten (Spalten) einer Tabelle in einem Index gespeichert sind.
-- Ein normaler Index speichert nur die indizierten Spalten, w�hrend
-- eine indexorganisierte Tabelle s�mtliche Spalten im Index ablegt.
-- Generell eignen sich indexorganisierte Tabellen am besten, wenn der
-- Prim�rschl�ssel einen Gro�teil der Spalten in einer Tabelle ausmacht.

ALTER TABLE countries
ADD ( CONSTRAINT countr_reg_fk
         FOREIGN KEY (region_id)
            REFERENCES regions(region_id) 
   );
   
-- ********************************************************************
-- Create the LOCATIONS table to hold address information for company departments.
-- HR.DEPARTMENTS has a foreign key to this table.
-- ******  Creating LOCATIONS TABLE ....
CREATE TABLE locations
   ( location_id    NUMBER(4)
   , street_address VARCHAR2(40)
   , postal_code    VARCHAR2(12)
   , city       VARCHAR2(30)
CONSTRAINT     loc_city_nn  NOT NULL
   , state_province VARCHAR2(25)
   , country_id     CHAR(2)
   );
CREATE UNIQUE INDEX loc_id_pk
ON locations (location_id);
ALTER TABLE locations
ADD ( CONSTRAINT loc_id_pk
         PRIMARY KEY (location_id)
      );

--  Useful for any subsequent addition of rows to locations table
--  Starts with 3300
--  e.g. INSERT INTO locations VALUES ( locations_seq.nextval, ... 
CREATE SEQUENCE locations_seq
START WITH     3300
INCREMENT BY   100
MAXVALUE       9900
NOCACHE
NOCYCLE;

-- ********************************************************************
-- Create the DEPARTMENTS table to hold company department information.
-- HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.
-- ******  Creating DEPARTMENTS TABLE ....
CREATE TABLE departments
   ( department_id    NUMBER(4)
   , department_name  VARCHAR2(30)
CONSTRAINT  dept_name_nn  NOT NULL
   , manager_id       NUMBER(6)
   , location_id      NUMBER(4)
   );
CREATE UNIQUE INDEX dept_id_pk
ON departments (department_id);
ALTER TABLE departments
ADD ( CONSTRAINT dept_id_pk
         PRIMARY KEY (department_id)
   , CONSTRAINT dept_loc_fk
         FOREIGN KEY (location_id)
          REFERENCES locations (location_id)
    );

--  Useful for any subsequent addition of rows to departments table
--  Starts with 280 
CREATE SEQUENCE departments_seq
START WITH     280
INCREMENT BY   10
MAXVALUE       9990
NOCACHE
NOCYCLE;

-- ********************************************************************
-- Create the JOBS table to hold the different names of job roles within the company.
-- HR.EMPLOYEES has a foreign key to this table.
-- ******  Creating JOBS TABLE ....
CREATE TABLE jobs
   ( job_id         VARCHAR2(10)
   , job_title      VARCHAR2(35)
CONSTRAINT     job_title_nn  NOT NULL
   , min_salary     NUMBER(6)
   , max_salary     NUMBER(6)
   );
CREATE UNIQUE INDEX job_id_pk 
ON jobs (job_id);
ALTER TABLE jobs
ADD ( CONSTRAINT job_id_pk
        PRIMARY KEY(job_id)
   );
   
-- ********************************************************************
-- Create the EMPLOYEES table to hold the employee personnel 
-- information for the company.
-- HR.EMPLOYEES has a self referencing foreign key to this table.
-- ******  Creating EMPLOYEES TABLE ....
CREATE TABLE employees
   ( employee_id    NUMBER(6)
   , first_name     VARCHAR2(20)
   , last_name      VARCHAR2(25)
 CONSTRAINT     emp_last_name_nn  NOT NULL
   , email          VARCHAR2(25)
CONSTRAINT     emp_email_nn  NOT NULL
   , phone_number   VARCHAR2(20)
   , hire_date      DATE
CONSTRAINT     emp_hire_date_nn  NOT NULL
   , job_id         VARCHAR2(10)
CONSTRAINT     emp_job_nn  NOT NULL
   , salary         NUMBER(8,2)
   , commission_pct NUMBER(2,2)
   , manager_id     NUMBER(6)
   , department_id  NUMBER(4)
   , CONSTRAINT     emp_salary_min
                    CHECK (salary > 0) 
   , CONSTRAINT     emp_email_uk
                    UNIQUE (email)
   );                   

CREATE UNIQUE INDEX emp_emp_id_pk
ON employees (employee_id);


ALTER TABLE employees
ADD ( CONSTRAINT     emp_emp_id_pk
                    PRIMARY KEY (employee_id)
   , CONSTRAINT     emp_dept_fk
                    FOREIGN KEY (department_id)
                     REFERENCES departments
   , CONSTRAINT     emp_job_fk
                    FOREIGN KEY (job_id)
                     REFERENCES jobs (job_id)
   , CONSTRAINT     emp_manager_fk
                    FOREIGN KEY (manager_id)
                     REFERENCES employees
   );

ALTER TABLE departments
ADD ( CONSTRAINT dept_mgr_fk
        FOREIGN KEY (manager_id)
         REFERENCES employees (employee_id)
   );
-- Useful for any subsequent addition of rows to employees table
--  Starts with 207 
CREATE SEQUENCE employees_seq
START WITH     207
INCREMENT BY   1
NOCACHE
NOCYCLE;

-- ********************************************************************
-- Create the JOB_HISTORY table to hold the history of jobs that 
-- employees have held in the past.
-- HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.
-- ******  Creating JOB_HISTORY TABLE ....
CREATE TABLE job_history
   ( employee_id   NUMBER(6)
 CONSTRAINT    jhist_employee_nn  NOT NULL
   , start_date    DATE
CONSTRAINT    jhist_start_date_nn  NOT NULL
   , end_date      DATE
CONSTRAINT    jhist_end_date_nn  NOT NULL
   , job_id        VARCHAR2(10)
CONSTRAINT    jhist_job_nn  NOT NULL
   , department_id NUMBER(4)
   , CONSTRAINT    jhist_date_interval
                   CHECK (end_date > start_date)
   );
CREATE UNIQUE INDEX jhist_emp_id_st_date_pk 
ON job_history (employee_id, start_date);
ALTER TABLE job_history
ADD ( CONSTRAINT jhist_emp_id_st_date_pk
     PRIMARY KEY (employee_id, start_date)
   , CONSTRAINT     jhist_job_fk
                    FOREIGN KEY (job_id)
                    REFERENCES jobs
   , CONSTRAINT     jhist_emp_fk
                    FOREIGN KEY (employee_id)
                    REFERENCES employees
   , CONSTRAINT     jhist_dept_fk
                    FOREIGN KEY (department_id)
                    REFERENCES departments
   );
-- ********************************************************************
-- Create the EMP_DETAILS_VIEW that joins the employees, jobs, 
-- departments, jobs, countries, and locations table to provide details
-- about employees.

-- ******  Creating EMP_DETAILS_VIEW VIEW ...

CREATE OR REPLACE VIEW emp_details_view
 (employee_id,
  job_id,
  manager_id,
  department_id,
  location_id,
  country_id,
  first_name,
  last_name,
  salary,
  commission_pct,
  department_name,
  job_title,
  city,
  state_province,
  country_name,
  region_name)
AS SELECT
 e.employee_id, 
 e.job_id, 
 e.manager_id, 
 e.department_id,
 d.location_id,
 l.country_id,
 e.first_name,
 e.last_name,
 e.salary,
 e.commission_pct,
 d.department_name,
 j.job_title,
 l.city,
 l.state_province,
 c.country_name,
 r.region_name
FROM
 employees e,
 departments d,
 jobs j,
 locations l,
 countries c,
 regions r
WHERE e.department_id = d.department_id
 AND d.location_id = l.location_id
 AND l.country_id = c.country_id
 AND c.region_id = r.region_id
 AND j.job_id = e.job_id 
WITH READ ONLY;

--
-- job-grades table
--
CREATE TABLE JOB_GRADES
(GRADE_LEVEL VARCHAR2(3) PRIMARY KEY,
LOWEST_SAL NUMBER(6),
HIGHEST_SAL NUMBER(6));

COMMIT;



