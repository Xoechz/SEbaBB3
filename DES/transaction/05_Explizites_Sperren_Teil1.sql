/* Anleitung für die Durchführung dieses Demo-Skripts:
2 Möglichkeiten:
A) 1 Benutzer greift mit zwei Sessions auf die Datenbank zu (dazu wird die gleiche Tabelle verwendet);
   für Session 2 wird ein Synonym erstellt
B) 2 Benutzer greifen auf eine Tabelle zu, dazu wird ein GRANT verwendet und der Partner erstellt ein Synonym.
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YY';
ALTER SESSION SET NLS_LANGUAGE = 'German';

-- Session 1 (Vorbereitung)
DROP TABLE emp CASCADE CONSTRAINTS;
DROP TABLE dept CASCADE CONSTRAINTS;

CREATE TABLE dept (
 deptno              NUMBER(2) NOT NULL,
 dname               VARCHAR2(14),
 loc                 VARCHAR2(13),
 CONSTRAINT dept_primary_key PRIMARY KEY (deptno));

INSERT INTO dept VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO dept VALUES (20,'RESEARCH','DALLAS');
INSERT INTO dept VALUES (30,'SALES','CHICAGO');
INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON');
COMMIT; 

CREATE TABLE emp (
 empno               NUMBER(4) NOT NULL,
 ename               VARCHAR2(10),
 job                 VARCHAR2(9),
 mgr                 NUMBER(4) CONSTRAINT emp_self_key REFERENCES emp (empno),
 hiredate            DATE,
 sal                 NUMBER(7,2),
 comm                NUMBER(7,2),
 deptno              NUMBER(2) NOT NULL,
 CONSTRAINT emp_foreign_key FOREIGN KEY (deptno) REFERENCES dept (deptno),
 CONSTRAINT emp_primary_key PRIMARY KEY (empno));

INSERT INTO emp VALUES (7839,'KING','PRESIDENT',NULL,'17-NOV-81',5000,NULL,10);
INSERT INTO emp VALUES (7698,'BLAKE','MANAGER',7839,'1-MAI-81',2850,NULL,30);
INSERT INTO emp VALUES (7782,'CLARK','MANAGER',7839,'9-JUN-81',2450,NULL,10);
INSERT INTO emp VALUES (7566,'JONES','MANAGER',7839,'2-APR-81',2975,NULL,20);
INSERT INTO emp VALUES (7654,'MARTIN','SALESMAN',7698,'28-SEP-81',1250,1400,30);
INSERT INTO emp VALUES (7499,'ALLEN','SALESMAN',7698,'20-FEB-81',1600,300,30);
INSERT INTO emp VALUES (7844,'TURNER','SALESMAN',7698,'8-SEP-81',1500,0,30);
INSERT INTO emp VALUES (7900,'JAMES','CLERK',7698,'3-DEZ-81',950,NULL,30);
INSERT INTO emp VALUES (7521,'WARD','SALESMAN',7698,'22-FEB-81',1250,500,30);
INSERT INTO emp VALUES (7902,'FORD','ANALYST',7566,'3-DEZ-81',3000,NULL,20);
INSERT INTO emp VALUES (7369,'SMITH','CLERK',7902,'17-DEZ-80',800,NULL,20);
INSERT INTO emp VALUES (7788,'SCOTT','ANALYST',7566,'09-DEZ-82',3000,NULL,20);
INSERT INTO emp VALUES (7876,'ADAMS','CLERK',7788,'12-JAN-83',1100,NULL,20);
INSERT INTO emp VALUES (7934,'MILLER','CLERK',7782,'23-JAN-82',1300,NULL,10);
COMMIT;

-- Session 1: Zugriff auf Tabelle f. User 2 (Session 2) erteilen (nur wenn 2 User!)
GRANT SELECT, INSERT, UPDATE, DELETE ON emp  TO <<PARTNER_USER>>;
GRANT SELECT, INSERT, UPDATE, DELETE ON dept TO <<PARTNER_USER>>;
-- Session 2: mit anderem User, Synonym erstellen (wenn nur 1 User: Synonym auf eigene Tabelle!)
CREATE SYNONYM partner_emp  FOR <<NORMAL_USER>>.emp;
CREATE SYNONYM partner_dept FOR <<NORMAL_USER>>.dept;


-- S1
LOCK TABLE dept
 IN ROW SHARE MODE; -- es wird eine intensionale Lesesperre auf die Tabelle DEPT gesetzt
-- Tabelle(n) wurde(n) gesperrt.

-- S2 (nur wenn USER = OWNER, 2. Session für NORMAL_USER öffnen; kann nicht von Partner-User ausgeführt werden)
DROP TABLE dept CASCADE CONSTRAINTS; 
-- SQL-Fehler: ORA-00054: Ressource belegt und Anforderung mit NOWAIT angegeben oder Timeout abgelaufen

-- S2
LOCK TABLE partner_dept
 IN EXCLUSIVE MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...
SELECT loc
 FROM partner_dept
 WHERE deptno = 20
 FOR UPDATE OF loc; 

-- S1
UPDATE dept
 SET loc = 'NEW YORK'
 WHERE deptno = 20; 
-- wartet

-- S2
ROLLBACK;

-- S1
-- Zeile wurde aktualisiert
ROLLBACK; 

LOCK TABLE dept
 IN ROW EXCLUSIVE MODE; 

-- S2
LOCK TABLE partner_dept
 IN EXCLUSIVE MODE NOWAIT;
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN SHARE ROW 
 EXCLUSIVE MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN SHARE MODE NOWAIT;
-- SQL-Fehler: ORA-00054: Ressource belegt...
 
UPDATE partner_dept
 SET loc = 'NEW YORK'
 WHERE deptno = 20; 
-- 1 Zeile aktualisiert

ROLLBACK;

-- S1
SELECT loc
FROM dept
WHERE deptno = 20
FOR UPDATE OF loc; 

-- S2
UPDATE partner_dept
SET loc = 'NEW YORK'
WHERE deptno = 20; 
-- wartet

-- S1
ROLLBACK;

-- S2
-- 1 Zeile aktualisiert
ROLLBACK;

-- S1
LOCK TABLE dept
 IN SHARE MODE;

-- S2
LOCK TABLE partner_dept
 IN EXCLUSIVE MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN SHARE ROW 
 EXCLUSIVE MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN SHARE MODE; 
-- Lock erfolgreich

-- S2
SELECT loc
 FROM partner_dept
 WHERE deptno = 20; 
 
SELECT loc
 FROM partner_dept
 WHERE deptno = 20
 FOR UPDATE OF loc; 
-- wartet

-- alternativ:
UPDATE partner_dept
 SET loc = 'NEW YORK'
 WHERE deptno = 20; 
-- wartet

-- S1
ROLLBACK;

-- S2
-- 1 Zeile aktualisiert
ROLLBACK;


-- S1
LOCK TABLE dept
 IN SHARE ROW 
 EXCLUSIVE MODE; 

-- S2
LOCK TABLE partner_dept
 IN EXCLUSIVE MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN SHARE ROW 
 EXCLUSIVE MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN SHARE MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN ROW EXCLUSIVE 
 MODE NOWAIT; 
-- SQL-Fehler: ORA-00054: Ressource belegt...

LOCK TABLE partner_dept
 IN ROW SHARE MODE; 
-- Lock erfolgreich

SELECT loc
 FROM partner_dept
 WHERE deptno = 20; 

SELECT loc
 FROM partner_dept
 WHERE deptno = 20
 FOR UPDATE OF loc;
-- wartet

-- alternativ:
UPDATE partner_dept
 SET loc = 'NEW YORK'
 WHERE deptno = 20; 
-- wartet

-- S1
UPDATE dept
 SET loc = 'NEW YORK'
 WHERE deptno = 20; 
-- 1 Zeile aktualisiert.

ROLLBACK;

-- S2
ROLLBACK;


-- ############### CLEANUP ###############
-- S1
DROP TABLE dept;
DROP TABLE emp;

-- S2
DROP SYNONYM partner_dept;
DROP SYNONYM partner_emp;

