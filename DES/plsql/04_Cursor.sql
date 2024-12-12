-- SQL Cursor

--Beispiel 1: Verwendung eines impliziten Cursors,
--			  der automatisch f�r die Ausf�hrung einer SQL-Anweisung erstellt wird.

VARIABLE rows_deleted VARCHAR2(30);
DECLARE
    empno employees.employee_id%TYPE := 104;
BEGIN
    -- SQL-Anweisung, auf deren impliziten Cursor zugegriffen werden soll.
    DELETE
    FROM employees
    WHERE employee_id = empno;

    -- TODO: Verwendung des impliziten Cursors, der automatisch f�r die o.a. SQL-Anweisung erstellt wurde.
    -- Zugriff auf Host-Variable mit :varName
    -- Zugriff auf impliziten Cursor mit 'SQL' und '%ROWCOUNT' f�r die Zeilenanzahl
    -- '%FOUND' oder '%NOTFOUND' wenn Zeilen gefunden bzw. nicht gefunden werden

    IF SQL%FOUND THEN

    ELSE
        DBMS_OUTPUT.PUT_LINE('No rows found.');
    END IF;

END; --Beispiel 1: Verwendung eines impliziten Cursors, 
/
-- Anzeigen der Host-Variable: PRINT ist ein Oracle (bzw. SQLPLUS) spezifischer Befehl!
PRINT rows_deleted;


-- Beispiel 2: Verwendung eines expliziten Cursors
SET SERVEROUTPUT ON;
DECLARE
    -- Deklaration eines Cursor
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = 50;
    empno employees.employee_id%TYPE;
    lname employees.last_name%TYPE;

-- Das Ergebnis der SQL-Anweisung soll hinausgeschrieben werden.	
BEGIN
    -- TODO: Cursor �ffnen und auf erste Zeile positionieren.

    OPEN emp_cursor;
    DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);

    -- TODO: Das Ergebnis der SQL-Anweisung soll hinausgeschrieben werden.
    --		Abrufen einer Zeile aus dem Cursor (2 Variablen!) u. Weiterschalten auf die n�chste Zeile
    --		Abfragen auf das Cursor-Attribut %NOTFOUND

    LOOP
        FETCH emp_cursor INTO empno, lname;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE(empno || ' ' || lname);
    END LOOP;

    IF emp_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows selected in emp_cursor!');
    END IF;

    CLOSE emp_cursor;
    -- TODO: Schlie�en des Cursor und Freigabe der aktiven Menge


END; -- Beispiel 2: Verwendung eines expliziten Cursors
/


-- Beispiel 3: Expliziter CURSOR mit Parameter und Cursor-Record
DECLARE
    -- Deklaration eines Cursor mit Parameter
    CURSOR emp_cursor (deptno NUMBER) IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = deptno;

    -- TODO: Record emp_rec vom Typ des Cursors anlegen (Attribute des Cursor mit deren Typen)
    emp_rec emp_cursor%ROWTYPE; -- Cursor-Record

BEGIN
    -- TODO: Cursor f�r department = 50 �ffnen.
OPEN emp_cursor(50);
    -- TODO: Pr�fung ob emp_cursor richtig ge�ffnet wurde.
    IF emp_cursor%ISOPEN THEN
        LOOP
            FETCH emp_cursor INTO emp_rec;
            EXIT WHEN emp_cursor%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE(emp_rec.employee_id || ' ' || emp_rec.last_name);
        END LOOP;

        IF emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No rows selected in emp_cursor!');
        END IF;
    END IF;
CLOSE emp_cursor;
END; -- Beispiel 3: Expliziter CURSOR mit Parameter und Cursor-Record
/


-- Beispiel 4: Verwendung eines expliziten CURSORs in Kombination mit FOR-Schleifen 
DECLARE
    -- Deklaration eines Cursor
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = 50;
BEGIN

    -- TODO: expliziten CURSOR in Kombination mit FOR-Schleife verwenden
    -- Das �ffnen und Schlie�en des Cursor und das Fetchen der einzelnen Zeilen
    -- passiert implizit in der FOR-Schleife in Verbindung des Cursor mit dem Record
    -- Das Record emp_record wird ebenfalls implizit erzeugt u. muss nicht deklariert werden.
for emp_record in emp_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id || ' ' || emp_record.last_name);
    END LOOP;

END; -- Beispiel 4: Verwendung eines expliziten CURSORs in Kombination mit FOR-Schleifen 
/

-- Beispiel 5: Verwendung eines impliziten CURSORs in Kombination mit FOR-Schleifen 
SET SERVEROUTPUT ON;

DECLARE
    i INTEGER := 0;
BEGIN
    -- TODO: Die SELECT-Anweisung kann durch den indirekten Cursor direkt in die FOR-Schleife eingebettet werden

    SELECT employee_id, last_name
    FROM employees
    WHERE department_id = 50

    LOOP
        i := i + 1;
        DBMS_OUTPUT.PUT_LINE('Anzahl: ' || i);
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id || ' ' || emp_record.last_name);
    END LOOP;
END; -- Beispiel 5: Verwendung eines impliziten CURSORs in Kombination mit FOR-Schleifen 
/

