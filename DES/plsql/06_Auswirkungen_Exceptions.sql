-- EXCEPTIONS: Demo-Skript zu Auswirkungen von Exceptions auf vorangegangene und nachfolgende Operationen

-- Erstellung einer temporären Tabelle
CREATE TABLE new_emps AS
SELECT *
FROM employees
WHERE employee_id < 102;

SELECT *
FROM new_emps;

-- Exception nicht fangen
BEGIN
    -- INSERT funktioniert
    INSERT INTO new_emps
    SELECT *
    FROM employees
    WHERE employee_id = 200;
    
    -- INSERT führt zu einer Exception
    INSERT INTO new_emps (employee_id)
    SELECT employee_id
    FROM employees;
END;
/

-- keine Datenänderung in der Tabelle new_emps, die Exception wurde im Block nicht gefangen,
-- folglich wird der gesamte Block nicht ausgeführt (bzw. zurückgenommen - kein ROLLBACK!)
SELECT *
FROM new_emps;

-- Exception fangen
BEGIN
    -- INSERT funktioniert
    INSERT INTO new_emps
    SELECT *
    FROM employees
    WHERE employee_id = 200;
    
    -- INSERT führt zu einer Exception
    INSERT INTO new_emps (employee_id)
    SELECT employee_id
    FROM employees;
    
    -- INSERT nach Exception
    INSERT INTO new_emps
    SELECT *
    FROM employees
    WHERE employee_id = 201;
EXCEPTION
    WHEN OTHERS THEN
        NULL;   -- Exception wird gefangen, aber nicht weiter behandelt    
END;
/

-- wenn Exception gefangen wird, bleiben die Statements die davor ausführt wurden, vorhanden.
SELECT *
FROM new_emps;



-- DEMO: Auswirkungen von COMMIT und ROLLBACK in PL/SQL im Zusammenhang mit Exceptions
-- Faustregel: COMMIT und ROLLBACK im PL/SQL Block bzw. Funktion/Prozedur nur in Ausnahmefällen
-- sinnvoll. Die Transaktionskontrolle soll beim Aufrufer liegen - der entscheidet ob er die Änderung
-- festschreiben möchte.

ROLLBACK;

SELECT *
FROM new_emps;

-- Einfügen eines neuen Datensatzes
INSERT INTO new_emps VALUES (999, 'David', 'Knee', 'DKNEE', '112.123.123', SYSDATE, 'IT_PROG', 10000, NULL, 102, 60);

DECLARE
    emp employees%ROWTYPE;
BEGIN
    SELECT * INTO emp
    FROM employees
    WHERE employee_id = &employee_id;
    INSERT INTO new_emps VALUES emp;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;       -- falsches Rollback, greift in die Transaktion ein
END;
/

-- durch das falsch gesetzte Rollback, wird im Fall eines Problems beim Ausführen des Blocks auch das
-- vorangegangene INSERT (und ev. weitere Operationen) ebenfalls zurückgesetzt.
-- Es hängt also vom Aufruf (Benutzereingabe) ab, ob die Transaktion fortgesetzt oder abgebrochen wird.
-- Der Benutzer erhält keine Benachrichtigung, was passiert ist. 
SELECT *
FROM new_emps;


DROP TABLE new_emps;