-- Constraints mit unterschiedlichen Überprüfungs- und Verzögerungsmodi
-- Verzögerungsmodus: DEFERRABLE / NOT DEFERRABLE (Verzögerbar / nicht verzögerbar)
-- (Initialer) Überprüfungsmodus: IMMEDIATE / DEFERRED (sofort / verzögert)

--               | IMMEDIATE   | DEFERRED
--------------------------------------------               
--DEFERRABLE     |   ok        |    ok      -- <-IMMEDIATE- SET CONTRAINT[S] -DEFERRED-> 
--NOT DEFERRABLE |   ok        |    -

-- Erstellung von Beispieltabellen für die Demo
   DROP TABLE emp; 
   DROP TABLE dept;

   CREATE TABLE dept (
       deptno             NUMBER(2) NOT NULL
     , dname              CHAR(14)
     , loc                CHAR(13)
     , CONSTRAINT dept_pk PRIMARY KEY (deptno)
   );

   INSERT INTO dept VALUES (10,'FINANCE','PITTSBURGH');
   INSERT INTO dept VALUES (20,'SALES','NEW YORK');
   INSERT INTO dept VALUES (30,'OPERATIONS','BOSTON');

   COMMIT;  

   CREATE TABLE emp (
       empno               NUMBER(4) NOT NULL
     , ename               CHAR(10)
     , job                 CHAR(9)
     , deptno              NUMBER(2) NOT NULL
     , CONSTRAINT emp_fk1  FOREIGN KEY (deptno)
                  REFERENCES dept (deptno)
                  DEFERRABLE 
                  INITIALLY IMMEDIATE
     , CONSTRAINT emp_pk PRIMARY KEY (empno)
   );

   INSERT INTO emp VALUES (1001, 'JEFF', 'PRESIDENT', 10);
   INSERT INTO emp VALUES (1002, 'MELODY', 'MANAGER', 30);
   INSERT INTO emp VALUES (1003, 'MARK', 'MANAGER', 10);
   INSERT INTO emp VALUES (1004, 'MARTIN', 'MANAGER', 20);

   COMMIT;
   
---------------------------------
-- Überprüfungs-/Verzögerungsmodus eines Constraints aus Data Dictionary abfragen
   SELECT 
       constraint_name
      , deferrable
      , deferred
   FROM user_constraints
   WHERE table_name = 'EMP';

--    CONSTRAINT_NAME   DEFERRABLE      DEFERRED
--    ----------------  --------------  ---------
--    SYS_C0067650      NOT DEFERRABLE  IMMEDIATE  --> NOT NULL - system generated
--    SYS_C0067651      NOT DEFERRABLE  IMMEDIATE  --> NOT NULL - system generated
--    EMP_PK            NOT DEFERRABLE  IMMEDIATE 
--    EMP_FK1           DEFERRABLE      IMMEDIATE 

-- Default-mäßig ist ein Constraint als NOT DEFERRABLE (nicht verzögerbar) deklariert, 
-- d.h. Oracle wird sofort melden (notify immediately), wenn eine Constraint-Verletzung vorliegt
   
-- Wird ein verzögerbares Constraint auf verzögert gesetzt,
-- überprüft Oracle das Constraint erst (nur) beim Commit am Ende der Transaktion


-- Test: Löschen von der Elterntabelle
   DELETE FROM dept WHERE deptno = 10;

-- -------------------------------
-- ERROR at line 1:
-- ORA-02292: Integritäts-Constraint (<User>.EMP_FK1) verletzt - untergeordneter Datensatz gefunden
-- dept tuple with deptno = 10 still in table dept
-- -------------------------------

-- ---------------------------------------------------------
-- Alle verzögerbaren Transaktionen werden verzögert geprüft
-- ---------------------------------------------------------
   SET CONSTRAINTS ALL DEFERRED;
-- or
-- SET CONSTRAINT EMP_FK1 DEFERRED
-- SET CONSTRAINTS erfolgreich.
   
-- Versuch: Constraint EMP_PK als deferred deklarieren 
   SET CONSTRAINT EMP_PK DEFERRED;
-- Fehler: ORA-02447: Nicht verzögerbares Constraint kann nicht verzögert werden

   DELETE FROM dept WHERE deptno = 10;

-- 1 row deleted.
   
-- dept tuple with deptno = 10 deleted from table dept
   
   COMMIT;

-- -------------------------------
-- ERROR at line 1:
-- ORA-02091: Transaktion wurde zurückgesetzt
-- ORA-02292: Integritäts-Constraint (<USER>.EMP_FK1) verletzt - untergeordneter Datensatz gefunden
-- 02091. 00000 -  "transaction rolled back"
   
   
-- -------------------------------
-- Zusammenfassung: DEFERRABLE+DEFERRED: überprüft Constraint Integrity nur vor dem Commit.
-- Somit hat der Entwickler mehr Flexibilität beim Programmieren und muss sich 
-- erst gegen Ende der Transaktion hinsichtlich Verstößen gegen Constraints Gedanken machen.
-- Nachteil: ev. ungültige Änderungen wurden bereits durchgeführt und werden zurückgerollt.