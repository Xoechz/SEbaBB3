-- populate all tables
-- ***************************insert data into the REGIONS table
-- ******  Populating REGIONS TABLE ....
INSERT INTO regions VALUES 
       ( 1
       , 'Europe' 
       );
INSERT INTO regions VALUES 
       ( 2
       , 'America' 
       );
INSERT INTO regions VALUES 
       ( 3
       , 'Asia' 
       );
INSERT INTO regions VALUES 
       ( 4
       , 'Middle East and Africa' 
       );
-- ***************************insert data into the COUNTRIES table
-- ******  Populating COUNTIRES TABLE ....
INSERT INTO countries VALUES 
       ( 'US'
       , 'United States of America'
       , 2 
       );
INSERT INTO countries VALUES 
       ( 'CA'
       , 'Canada'
       , 2 
       );
INSERT INTO countries VALUES 
       ( 'UK'
       , 'United Kingdom'
       , 1 
       );
INSERT INTO countries VALUES 
       ( 'DE'
       , 'Germany'
       , 1 
       );
-- ***************************insert data into the LOCATIONS table
-- ******  Populating LOCATIONS TABLE ....
INSERT INTO locations VALUES 
       ( 1400 
       , '2014 Jabberwocky Rd'
       , '26192'
       , 'Southlake'
       , 'Texas'
       , 'US'
       );
INSERT INTO locations VALUES 
       ( 1500 
       , '2011 Interiors Blvd'
       , '99236'
       , 'South San Francisco'
       , 'California'
       , 'US'
       );
INSERT INTO locations VALUES 
       ( 1700 
       , '2004 Charade Rd'
       , '98199'
       , 'Seattle'
       , 'Washington'
       , 'US'
       );
INSERT INTO locations VALUES 
       ( 1800 
       , '147 Spadina Ave'
       , 'M5V 2L7'
       , 'Toronto'
       , 'Ontario'
       , 'CA'
       );
INSERT INTO locations VALUES 
       ( 2500 
       , 'Magdalen Centre, The Oxford Science Park'
       , 'OX9 9ZB'
       , 'Oxford'
       , 'Oxford'
       , 'UK'
       );
-- ****************************insert data into the DEPARTMENTS table
-- ******  Populating DEPARTMENTS TABLE ....
-- disable integrity constraint to EMPLOYEES to load data
ALTER TABLE departments 
 DISABLE CONSTRAINT dept_mgr_fk;
INSERT INTO departments VALUES 
       ( 10
       , 'Administration'
       , 200
       , 1700
       );
INSERT INTO departments VALUES 
       ( 20
       , 'Marketing'
       , 201
       , 1800
       );                          
INSERT INTO departments VALUES 
       ( 50
       , 'Shipping'
       , 121
       , 1500
       );               
INSERT INTO departments VALUES 
       ( 60 
       , 'IT'
       , 103
       , 1400
       );   
INSERT INTO departments VALUES 
       ( 80 
       , 'Sales'
       , 145
       , 2500
       );                
INSERT INTO departments VALUES 
       ( 90 
       , 'Executive'
       , 100
       , 1700
       );                
INSERT INTO departments VALUES 
       ( 110 
       , 'Accounting'
       , 205
       , 1700
       );
INSERT INTO departments VALUES 
       ( 190 
       , 'Contracting'
       , NULL
       , 1700
       );
-- ***************************insert data into the JOBS table
-- ******  Populating JOBS TABLE ....
INSERT INTO jobs VALUES 
       ( 'AD_PRES'
       , 'President'
       , 20000
       , 40000
       );
INSERT INTO jobs VALUES 
       ( 'AD_VP'
       , 'Administration Vice President'
       , 15000
       , 30000
       );
INSERT INTO jobs VALUES 
       ( 'AD_ASST'
       , 'Administration Assistant'
       , 3000
       , 6000
       );
INSERT INTO jobs VALUES 
       ( 'AC_MGR'
       , 'Accounting Manager'
       , 8200
       , 16000
       );
INSERT INTO jobs VALUES 
       ( 'AC_ACCOUNT'
       , 'Public Accountant'
       , 4200
       , 9000
       );
INSERT INTO jobs VALUES 
       ( 'SA_MAN'
       , 'Sales Manager'
       , 10000
       , 20000
       );
INSERT INTO jobs VALUES 
       ( 'SA_REP'
       , 'Sales Representative'
       , 6000
       , 12000
       );
INSERT INTO jobs VALUES 
       ( 'ST_MAN'
       , 'Stock Manager'
       , 5500
       , 8500
       );
INSERT INTO jobs VALUES 
       ( 'ST_CLERK'
       , 'Stock Clerk'
       , 2000
       , 5000
       );
INSERT INTO jobs VALUES 
       ( 'SH_CLERK'
       , 'Shipping Clerk'
       , 2500
       , 5500
       );
INSERT INTO jobs VALUES 
       ( 'IT_PROG'
       , 'Programmer'
       , 4000
       , 10000
       );
INSERT INTO jobs VALUES 
       ( 'MK_MAN'
       , 'Marketing Manager'
       , 9000
       , 15000
       );
INSERT INTO jobs VALUES 
       ( 'MK_REP'
       , 'Marketing Representative'
       , 4000
       , 9000
       );
-- ***************************insert data into the EMPLOYEES table
-- ******  Populating EMPLOYEES TABLE ....
INSERT INTO employees VALUES 
       ( 100
       , 'Steven'
       , 'King'
       , 'SKING'
       , '515.123.4567'
       , TO_DATE('17-JUN-1987', 'dd-MON-yyyy')
       , 'AD_PRES'
       , 24000
       , NULL
       , NULL
       , 90
       );
INSERT INTO employees VALUES 
       ( 101
       , 'Neena'
       , 'Kochhar'
       , 'NKOCHHAR'
       , '515.123.4568'
       , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
       , 'AD_VP'
       , 17000
       , NULL
       , 100
       , 90
       );
INSERT INTO employees VALUES 
       ( 102
       , 'Lex'
       , 'De Haan'
       , 'LDEHAAN'
       , '515.123.4569'
       , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
       , 'AD_VP'
       , 17000
       , NULL
       , 100
       , 90
       );
INSERT INTO employees VALUES 
       ( 103
       , 'Alexander'
       , 'Hunold'
       , 'AHUNOLD'
       , '590.423.4567'
       , TO_DATE('03-JAN-1990', 'dd-MON-yyyy')
       , 'IT_PROG'
       , 9000
       , NULL
       , 102
       , 60
       );
       


ALTER SESSION SET NLS_LANGUAGE  = 'American';

ALTER SESSION SET NLS_TERRITORY = 'America';
       
       
INSERT INTO employees VALUES 
       ( 104
       , 'Bruce'
       , 'Ernst'
       , 'BERNST'
       , '590.423.4568'
       , TO_DATE('21-MAY-1991', 'dd-MON-yyyy')
       , 'IT_PROG'
       , 6000
       , NULL
       , 103
       , 60
       );
INSERT INTO employees VALUES 
       ( 107
       , 'Diana'
       , 'Lorentz'
       , 'DLORENTZ'
       , '590.423.5567'
       , TO_DATE('07-FEB-1999', 'dd-MON-yyyy')
       , 'IT_PROG'
       , 4200
       , NULL
       , 103
       , 60
       );
INSERT INTO employees VALUES 
       ( 124
       , 'Kevin'
       , 'Mourgos'
       , 'KMOURGOS'
       , '650.123.5234'
       , TO_DATE('16-NOV-1999', 'dd-MON-yyyy')
       , 'ST_MAN'
       , 5800
       , NULL
       , 100
       , 50
       );
INSERT INTO employees VALUES 
       ( 141
       , 'Trenna'
       , 'Rajs'
       , 'TRAJS'
       , '650.121.8009'
       , TO_DATE('17-OCT-1995', 'dd-MON-yyyy')
       , 'ST_CLERK'
       , 3500
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 142
       , 'Curtis'
       , 'Davies'
       , 'CDAVIES'
       , '650.121.2994'
       , TO_DATE('29-JAN-1997', 'dd-MON-yyyy')
       , 'ST_CLERK'
       , 3100
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 143
       , 'Randall'
       , 'Matos'
       , 'RMATOS'
       , '650.121.2874'
       , TO_DATE('15-MAR-1998', 'dd-MON-yyyy')
       , 'ST_CLERK'
       , 2600
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 144
       , 'Peter'
       , 'Vargas'
       , 'PVARGAS'
       , '650.121.2004'
       , TO_DATE('09-JUL-1998', 'dd-MON-yyyy')
       , 'ST_CLERK'
       , 2500
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 149
       , 'Eleni'
       , 'Zlotkey'
       , 'EZLOTKEY'
       , '011.44.1344.429018'
       , TO_DATE('29-JAN-2000', 'dd-MON-yyyy')
       , 'SA_MAN'
       , 10500
       , .2
       , 100
       , 80
       );
INSERT INTO employees VALUES 
       ( 174
       , 'Ellen'
       , 'Abel'
       , 'EABEL'
       , '011.44.1644.429267'
       , TO_DATE('11-MAY-1996', 'dd-MON-yyyy')
       , 'SA_REP'
       , 11000
       , .30
       , 149
       , 80
       );
INSERT INTO employees VALUES 
       ( 176
       , 'Jonathon'
       , 'Taylor'
       , 'JTAYLOR'
       , '011.44.1644.429265'
       , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
       , 'SA_REP'
       , 8600
       , .20
       , 149
       , 80
       );
INSERT INTO employees VALUES 
       ( 178
       , 'Kimberely'
       , 'Grant'
       , 'KGRANT'
       , '011.44.1644.429263'
       , TO_DATE('24-MAY-1999', 'dd-MON-yyyy')
       , 'SA_REP'
       , 7000
       , .15
       , 149
       , NULL
       );
INSERT INTO employees VALUES 
       ( 200
       , 'Jennifer'
       , 'Whalen'
       , 'JWHALEN'
       , '515.123.4444'
       , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
       , 'AD_ASST'
       , 4400
       , NULL
       , 101
       , 10
       );
INSERT INTO employees VALUES 
       ( 201
       , 'Michael'
       , 'Hartstein'
       , 'MHARTSTE'
       , '515.123.5555'
       , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
       , 'MK_MAN'
       , 13000
       , NULL
       , 100
       , 20
       );
INSERT INTO employees VALUES 
       ( 202
       , 'Pat'
       , 'Fay'
       , 'PFAY'
       , '603.123.6666'
       , TO_DATE('17-AUG-1997', 'dd-MON-yyyy')
       , 'MK_REP'
       , 6000
       , NULL
       , 201
       , 20
       );
INSERT INTO employees VALUES 
       ( 205
       , 'Shelley'
       , 'Higgins'
       , 'SHIGGINS'
       , '515.123.8080'
       , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
       , 'AC_MGR'
       , 12000
       , NULL
       , 101
       , 110
       );
INSERT INTO employees VALUES 
       ( 206
       , 'William'
       , 'Gietz'
       , 'WGIETZ'
       , '515.123.8181'
       , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
       , 'AC_ACCOUNT'
       , 8300
       , NULL
       , 205
       , 110
       );
COMMIT;
-- ********* insert data into the JOB_HISTORY table
-- ******  Populating JOB_HISTORY TABLE ....
INSERT INTO job_history
VALUES (102
      , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
      , TO_DATE('24-JUL-1998', 'dd-MON-yyyy')
      , 'IT_PROG'
      , 60);
INSERT INTO job_history
VALUES (101
      , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
      , TO_DATE('27-OCT-1993', 'dd-MON-yyyy')
      , 'AC_ACCOUNT'
      , 110);
INSERT INTO job_history
VALUES (101
      , TO_DATE('28-OCT-1993', 'dd-MON-yyyy')
      , TO_DATE('15-MAR-1997', 'dd-MON-yyyy')
      , 'AC_MGR'
      , 110);
INSERT INTO job_history
VALUES (201
      , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
      , TO_DATE('19-DEC-1999', 'dd-MON-yyyy')
      , 'MK_REP'
      , 20);
INSERT INTO job_history
VALUES  (200
       , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
       , TO_DATE('17-JUN-1993', 'dd-MON-yyyy')
       , 'AD_ASST'
       , 90
       );
INSERT INTO job_history
VALUES  (176
       , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
       , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
       , 'SA_REP'
       , 80
       );
INSERT INTO job_history
VALUES  (176
       , TO_DATE('01-JAN-1999', 'dd-MON-yyyy')
       , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
       , 'SA_MAN'
       , 80
       );
INSERT INTO job_history
VALUES  (200
       , TO_DATE('01-JUL-1994', 'dd-MON-yyyy')
       , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
       , 'AC_ACCOUNT'
       , 90
       );
-- ***********Populating JOB_GRADES TABLE****************
INSERT INTO JOB_GRADES VALUES
('A',1000,2999);
INSERT INTO JOB_GRADES VALUES
('B',3000,5999);
INSERT INTO JOB_GRADES VALUES
('C',6000,9999);
INSERT INTO JOB_GRADES VALUES
('D',10000,14999);
INSERT INTO JOB_GRADES VALUES
('E',15000,24999);
INSERT INTO JOB_GRADES VALUES
('F',25000,40000);
COMMIT;

-- ********* constraint dept_mgr_fk not enabled
-- ********* because manager_id from departments 
-- ********* contains 145 and 121 which are not 
-- ********* keys in table employees
-- ****** CONSTRAINT dept_mgr_fk NOT ENABLED *******
-- ********* ALTER TABLE departments
-- ********* ENABLE CONSTRAINT dept_mgr_fk;
-- ********* ORA-02298: (DEPT_MGR_FK) kann nicht validiert werden - 
-- ********* �bergeordnete Schl�ssel nicht gefunden
-- ********* Update manager_id in table departments to guarantee referential integrity
UPDATE DEPARTMENTS SET MANAGER_ID = 149 WHERE DEPARTMENT_ID=80;
UPDATE DEPARTMENTS SET MANAGER_ID = 124 WHERE DEPARTMENT_ID=50;
-- ********* Enable constraint to check referential integrity
ALTER TABLE DEPARTMENTS ENABLE CONSTRAINT DEPT_MGR_FK;
-- ********* There should be no referential integrity violations
/


