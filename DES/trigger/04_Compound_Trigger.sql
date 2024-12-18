-- Compound Trigger zur Vermeidung von Mutating Tables (seit Oracle 11g)
-- Es kommt immer wieder vor, dass bei einem DML-Trigger für Überprüfungen oder Protokollierungen 
-- Daten aus der zu ändernden Tabelle benötigt werden. Ein Row Trigger scheidet dann in der Regel aus, 
-- weil man sonst in das Problem mit Mutating Tables läuft.
-- =====================================================================================================
-- Ein Beispiel dazu: Stellen Sie sich vor, eine Geschäftsregel besagt, dass niemand innerhalb einer
-- Berufsgruppe mehr als 50% über dem Durchschnittsgehalt verdienen darf. Der einfachste Ansatz 
-- dazu sieht folgendermaßen aus:

CREATE OR REPLACE TRIGGER check_sal
  AFTER UPDATE OF salary ON employees
  FOR EACH ROW
DECLARE
  v_avgsal NUMBER;
BEGIN
  SELECT AVG(salary) INTO v_avgsal
  FROM employees
  WHERE job_id = :NEW.job_id;
  
  IF :NEW.salary > 1.5 * v_avgsal THEN
    RAISE_APPLICATION_ERROR(-20000, 'Verdienst liegt zu weit über dem Durchschnitt');
  END IF;
END;
/

-- Ein Update führt zu einem Fehler aufgrund von Mutating Tables
UPDATE employees
   SET salary = 50000
WHERE employee_id = 100;

--SQL-Fehler: ORA-04091: Tabelle <USER>.EMPLOYEES wird gerade geändert, 
--Trigger/Funktion sieht dies möglicherweise nicht
--ORA-06512: in "<USER>.CHECK_SAL", Zeile 4
--ORA-04088: Fehler bei der Ausführung von Trigger '<USER>.CHECK_SAL'
--04091. 00000 -  "table %s.%s is mutating, trigger/function may not see it"
--*Cause:    A trigger (or a user defined plsql function that is referenced in
--           this statement) attempted to look at (or modify) a table that was
--           in the middle of being modified by the statement which fired it.
--*Action:   Rewrite the trigger (or function) so it does not read that table.

-- Ein Workaround dazu könnte so aussehen, dass man über einen BEFORE STATEMENT 
-- Trigger zuerst den Durchschnitt aller Berufsgruppen einliest und beispielsweise 
-- in einer Tabelle zwischenspeichert. Der Row Trigger kann dann auf diese Werte zugreifen, 
-- ohne die zu ändernde Tabelle lesen zu müssen. Das ist machbar, aber umständlich.

-- Seit Oracle 11g gibt es eine einfachere Lösung: Compound Trigger haben 
-- Abschnitte für bisher unterschiedliche Triggertypen und bieten die Möglichkeit, Werte 
-- für die Dauer der Durchführung des DML-Befehls zu speichern. Obiges Beispiel könnte 
-- mit einem Compound Trigger folgendermaßen aussehen:

CREATE OR REPLACE TRIGGER check_sal
  FOR UPDATE OF salary ON employees
  COMPOUND TRIGGER
  TYPE t_number IS TABLE OF NUMBER INDEX BY pls_integer;
  TYPE t_varchar IS TABLE OF VARCHAR2(30) INDEX BY pls_integer;
  TYPE t_avgsal IS TABLE OF NUMBER INDEX BY VARCHAR2(30);
  
  v_avgsal t_number;
  v_job t_varchar;
  v_avgJob t_avgsal;
  v_index VARCHAR2(30);
  
  BEFORE STATEMENT IS
  BEGIN
    --BULK COLLECT erlaubt es, mehrere Zeilen in eine oder mehrere Collections einzulesen
    -- (mit nur einem einzigen Kontext-Switch bei der Kommunikation zwischen PL/SQL engine und SQL engine) 
    SELECT AVG(salary), job_id BULK COLLECT INTO v_avgsal, v_job
      FROM employees e
    GROUP BY e.job_id;
    FOR i IN 1..v_avgsal.COUNT LOOP
      v_avgJob(v_job(i)) := v_avgsal(i);
    END LOOP;
  END BEFORE STATEMENT;
  
  AFTER EACH ROW IS
  BEGIN
    IF v_avgJob.EXISTS(:NEW.job_id)
    THEN
      IF :NEW.salary > 1.5 * v_avgJob(:NEW.job_id)
      THEN
        RAISE_APPLICATION_ERROR(-20000,
          'Verdienst liegt zu weit über dem Durchschnitt');
      END IF;
    END IF;
  END AFTER EACH ROW;
END;
/

-- Erlaubtes Update
UPDATE employees
   SET salary = 5000
 WHERE employee_id = 100;
--1 row updated.

-- Verbotenes Update
UPDATE employees
   SET salary = 500000
 WHERE employee_id = 100;
-- ORA-20000: Zu weit über Durchschnitt
-- ORA-06512: in "SCOTT.CHECK_SAL", Zeile 29
-- ORA-04088: Fehler bei der Ausführung von Trigger 'SCOTT.CHECK_SAL'

ROLLBACK;

DROP TRIGGER check_sal;