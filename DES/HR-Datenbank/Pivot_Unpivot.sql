-- PIVOT und UNPIVOT

-- Zählt die Anzahl der Angestellten in den Abteilungen und gibt diese
-- in einer Zeile aus.
SELECT *
FROM (SELECT department_id
FROM employees)
    PIVOT
    ( COUNT(*)
    FOR department_id
    IN (10,20,30,40) );


-- Minimum- und Maximum-Gehälter verschiedener Job-IDs (grouped!) nach Abteilungen.
-- IN-Clause in Pivot ist nicht dynamisch, muss bei Bedarf im vorangehenden SQL ausgeführt werden,
-- gilt auch für zB Zusammenfassung von Altersgruppen).
SELECT *
FROM (SELECT department_id,
    salary,
    CASE
        WHEN job_id LIKE 'SA%' THEN 'SA'
        WHEN job_id LIKE '%MAN' OR job_id LIKE '%MGR' THEN 'MAN'
        ELSE 'OTH'
        END AS job_desc
FROM employees)
    PIVOT
    (
    MIN(salary) AS min_sal,
        MAX(salary) AS max_sal
    FOR job_desc
    IN ('SA' AS Sales, -- Vergabe von Alias mit AS damit auf Spalten zugegriffen werden kann
        'MAN' AS Manager,
        'OTH' AS Others)
    );


-- Erstellen Sie eine Tabelle, die die Kontaktdaten der Angestellten zusammenfasst.
-- Die Tabelle soll als Spalten den Nachnamen (last_name), die Kontakt-Art (contact_method = email, phone_number)
-- und den Wert (die E-Mail-Adresse, Telefonnummer) enthalten.
SELECT *
FROM (SELECT last_name, email, phone_number
FROM employees)
    UNPIVOT
    ( value -- neuer Spaltenname (der Werte enthält)
    FOR contact_method -- neuer Spaltenname (der Spalten-Überschriften enthält)
    IN (email, phone_number) ); -- Spalten-Überschriften, die (in contact_method) verwendet werden sollen

;
-- PIVOT und UNPIVOT (HR Datenbank)

-- Aufgabe 1
-- Erstellen Sie eine Pivot-Tabelle, die angibt, wie viele und welche Jobs es in welcher Abteilung gibt.
-- Listen Sie die Job-IDs zeilenweise auf und verwenden Sie die Abteilungen in den Spalten.
-- Sie können einschränken auf die Abteilungen Shipping, Marketing, Sales, Executive, Accounting.

SELECT *
FROM
    (SELECT e.JOB_ID, d.DEPARTMENT_NAME
    FROM EMPLOYEES e
    INNER JOIN DEPARTMENTS d
        ON e.DEPARTMENT_ID = d.DEPARTMENT_ID)
        PIVOT
        (
        COUNT(*) AS num_employees
        FOR department_name
        IN ('Shipping' AS Shipping, 'Marketing' AS Marketing, 'Sales' AS Sales, 'Executive' AS Executive, 'Accounting' AS Accounting));

-- Aufgabe 2
-- Erstellen Sie eine Unpivot-Tabelle für die vorherige Abfrage, nennen Sie die Spalten
-- num_employees und department_name und geben Sie nur jene Zeilen an, deren
-- Anzahl an Angestellter größer als 0 sind.
-- Tipp: Abfrage aus 1 mit Common Table Expression (WITH) deklarieren

WITH assignment_1 AS
    (SELECT *
    FROM
        (SELECT e.JOB_ID, d.DEPARTMENT_NAME
        FROM EMPLOYEES e
        INNER JOIN DEPARTMENTS d
            ON e.DEPARTMENT_ID = d.DEPARTMENT_ID)
            PIVOT
            (
            COUNT(*) AS num_employees
            FOR department_name
            IN ('Shipping' AS Shipping, 'Marketing' AS Marketing, 'Sales' AS Sales, 'Executive' AS Executive, 'Accounting' AS Accounting)))
SELECT *
FROM assignment_1
    UNPIVOT
    (num_employees FOR department_name IN (SHIPPING_NUM_EMPLOYEES AS 'Shipping', Marketing_NUM_EMPLOYEES AS 'Marketing', Sales_NUM_EMPLOYEES AS 'Sales', Executive_NUM_EMPLOYEES AS 'Executive', Accounting_NUM_EMPLOYEES AS 'Accounting'))
WHERE num_employees > 0;

