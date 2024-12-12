-- EXCEPTIONS: Demo-Skript zu Auswirkungen von Exceptions auf vorangegangene und nachfolgende Operationen

-- Erstellung einer tempor�ren Tabelle
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
    
    -- INSERT f�hrt zu einer Exception
    INSERT INTO new_emps (employee_id)
    SELECT employee_id
    FROM employees;
END;
/

-- keine Daten�nderung in der Tabelle new_emps, die Exception wurde im Block nicht gefangen,
-- folglich wird der gesamte Block nicht ausgef�hrt (bzw. zur�ckgenommen - kein ROLLBACK!)
SELECT *
FROM new_emps;

-- Exception fangen
BEGIN
    -- INSERT funktioniert
    INSERT INTO new_emps
    SELECT *
    FROM employees
    WHERE employee_id = 200;
    
    -- INSERT f�hrt zu einer Exception
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

-- wenn Exception gefangen wird, bleiben die Statements die davor ausf�hrt wurden, vorhanden.
SELECT *
FROM new_emps;



-- DEMO: Auswirkungen von COMMIT und ROLLBACK in PL/SQL im Zusammenhang mit Exceptions
-- Faustregel: COMMIT und ROLLBACK im PL/SQL Block bzw. Funktion/Prozedur nur in Ausnahmef�llen
-- sinnvoll. Die Transaktionskontrolle soll beim Aufrufer liegen - der entscheidet ob er die �nderung
-- festschreiben m�chte.

ROLLBACK;

SELECT *
FROM new_emps;

-- Einf�gen eines neuen Datensatzes
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

-- durch das falsch gesetzte Rollback, wird im Fall eines Problems beim Ausf�hren des Blocks auch das
-- vorangegangene INSERT (und ev. weitere Operationen) ebenfalls zur�ckgesetzt.
-- Es h�ngt also vom Aufruf (Benutzereingabe) ab, ob die Transaktion fortgesetzt oder abgebrochen wird.
-- Der Benutzer erh�lt keine Benachrichtigung, was passiert ist. 
SELECT *
FROM new_emps;


DROP TABLE new_emps;