-- STORED PROCEDURE
-- Verwendung der FOR UPDATE- und WHERE CURRENT OF-Klausel in einer Stored Procedure
-- Gehaltserhühung für best. Abteilung um best. Prozentsatz
-- TODO: Prozedur definieren (Abteilungsnr dnum und Prozent percent (0.5 als default) als Eingabe-Parameter)
-- übergabemodus: IN (default), OUT und IN OUT
CREATE OR REPLACE PROCEDURE raise_salary(dnum IN NUMBER, percent IN REAL DEFAULT 0.5)
IS
  --TODO: CURSOR mit übergabeparameter dept_no (zum Updaten von Salary in best. Department)
  CURSOR emp_cur (dept_no NUMBER) IS
    SELECT salary FROM employees WHERE department_id = dept_no
    
	-- Wenn mehrere Sessions für eine einzelne Datenbank vorhanden sind, besteht die Müglichkeit, 
	-- dass die Zeilen einer bestimmten Tabelle aktualisiert wurden, nachdem Sie den Cursor geüffnet haben. 
	-- Sie sehen die aktualisierten Daten nur, wenn Sie den Cursor erneut üffnen. 
	-- Es ist daher günstiger, die Zeilen zu sperren, bevor Sie Zeilen aktualisieren oder lüschen. 
	-- Sie künnen zum Sperren der Zeilen die FOR-UPDATE-Klausel in der Cursor-Abfrage verwenden.
	FOR UPDATE OF salary;			-- bewirkt das Sperren der Spalte salary aus der Tabelle employees
  result NUMBER;
BEGIN
	-- Anzahl der Abteilungen bestimmen, in denen das Gehalt erhüht wird
	SELECT count(*) INTO result				 
	FROM departments 
	WHERE department_id = dnum;	
	
	-- Wenn eine Abteilung vorhanden ist, soll das Gehalt für alle Angestellten erhüht werden.
	IF (result > 0) THEN					 -- Prüfen ob Abteilung vorhanden ist
	
		-- TODO Verwendung des CURSOR mittels FOR-LOOP
		-- die Schleifenvariable the_emp entspricht automatisch dem Zeilentyp des Cursors 
		-- und erspart das OPEN, FETCH und CLOSE
		FOR the_emp IN emp_cur(dnum)
		LOOP
			-- TODO: Achtung, WHERE bei Update nicht vergessen! 
			-- Bestimmen, welche Datensütze zu aktualisieren sind
			-- CURRENT OF-Klausel ermüglicht den aktuellen Datensatz zu ündern
			-- und wird in Verbindung mit der FOR-UPDATE-Klausel verwendet
			UPDATE employees 
			SET salary = the_emp.salary * ((100 + percent)/100)
			WHERE CURRENT OF emp_cur;		 
			
		END LOOP;
	END IF;
END; --raise_salary
/


--Aufruf der Stored Procedure raise_salary: Gehalt der Mitarbeiter aus Abteilung 20 um 10 Prozent erhühen
SELECT last_name, salary, department_id FROM employees WHERE department_id = 50;
-- TODO: Aufruf der Stored Procedure mit 10% für Abteilung 50
EXECUTE raise_salary(50,10); 
SELECT last_name, salary, department_id FROM employees WHERE department_id = 50;


SELECT last_name, salary, department_id FROM employees WHERE department_id = 50;
-- TODO Aufruf von raise_salary in einem PL/SQL-Block: Erhühung des Gehalts um den Defaultwert (0.5%)
BEGIN
	raise_salary(50);  
END;
/
SELECT last_name, salary, department_id FROM employees WHERE department_id = 50;


-- Abfragen der gespeicherten Prozedur aus dem DataDictionary
SELECT object_name FROM user_objects where object_name LIKE 'R%';

ROLLBACK;

-- TODO Lüschen der Prozedur;
DROP PROCEDURE raise_salary;




-- STORED FUNCTIONS
-- überprüft, ob das Gehalt des angegebenen Angestellten mehr als das durchschnittliche Gehalt betrügt
CREATE OR REPLACE FUNCTION check_sal_gt_avg(empno employees.employee_id%TYPE)
RETURN Boolean --Angabe des Rückgabewertes
IS	
	dept_id employees.department_id%TYPE;
	sal employees.salary%TYPE;
	avg_sal employees.salary%TYPE;
BEGIN
	--Bestimmen des entsprechenden Gehalts eines Angestellten
	SELECT salary, department_id INTO sal, dept_id
	FROM employees WHERE employee_id=empno;
	
	--Berechnen des durchschnittlichen Gehalts der Abteilung
	SELECT avg(salary) INTO avg_sal FROM employees
	WHERE department_id=dept_id;

	--überprüfen, ob das Gehalt des angegebenen Angestellten mehr als das durchschnittliche Gehalt betrügt
	IF sal > avg_sal THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
/

--Aufruf der gespeicherten Funktion
BEGIN
	DBMS_OUTPUT.PUT_LINE('Checking salary of employee with id 205');
	-- TODO Aufruf der gespeicherten Funktion check_sal_gt_avg für employee 205
	IF (check_sal_gt_avg(205)) 
	THEN
		DBMS_OUTPUT.PUT_LINE('Salary > average');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Salary < average');
	END IF;
END;
/

-- Lüschen der Funktion
DROP FUNCTION check_sal_gt_avg;


-- Packages: Zusammenfassung von Prozeduren und/oder Funktionen zu einem gemeinsamen Paket(Unit).
-- Definition der Paket-Schnittstelle/Spezifikation
-- TODO: Erstellung eines Packages für die Prozedur raise_salary und die Funktion check_sal_gt_avg
CREATE OR REPLACE PACKAGE salary_pkg AS
	PROCEDURE raise_salary(dnum IN NUMBER, percent IN REAL DEFAULT 0.5);
	FUNCTION check_sal_gt_avg(empno employees.employee_id%TYPE) RETURN BOOLEAN;
END;
/

-- TODO Definition des Paktet-Rumpfes/Implementierung
CREATE OR REPLACE PACKAGE BODY salary_pkg AS
	--TODO Prozedur hineinkopieren
	PROCEDURE raise_salary(dnum IN NUMBER, percent IN REAL DEFAULT 0.5)
	IS
	  CURSOR emp_cur (dept_no NUMBER) IS
		SELECT salary FROM employees WHERE department_id = dept_no
		FOR UPDATE OF salary;	
	  result NUMBER;					
	BEGIN
		SELECT count(*) INTO result 
		FROM departments WHERE department_id = dnum;	
		IF (result > 0) THEN
			FOR the_emp IN emp_cur(dnum)		 
			LOOP
				UPDATE employees SET salary = the_emp.salary * ((100 + percent)/100)
				WHERE CURRENT OF emp_cur;		 
			END LOOP;
		END IF;
	END;	
	--TODO Funktion hineinkopieren
	FUNCTION check_sal_gt_avg(empno employees.employee_id%TYPE)
	RETURN Boolean 
	IS 
		dept_id employees.department_id%TYPE;
		sal employees.salary%TYPE;
		avg_sal employees.salary%TYPE;
	BEGIN
		SELECT salary,department_id INTO sal,dept_id
		FROM employees WHERE employee_id=empno;
		SELECT avg(salary) INTO avg_sal FROM employees
		WHERE department_id=dept_id;
		IF sal > avg_sal THEN RETURN TRUE;
						 ELSE RETURN FALSE;
		END IF;
	END;
END;
/


--Aufruf
BEGIN
	DBMS_OUTPUT.PUT_LINE('Checking salary of employee with id 205');
  -- TODO: Aufruf der Funktion check_sal_gt_avg im Package
	IF (salary_pkg.check_sal_gt_avg(205)) 
	THEN
		DBMS_OUTPUT.PUT_LINE('Salary > average');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Salary < average');
	END IF;
END;
/

-- Lüschen des Datenpaketes
DROP PACKAGE salary_pkg; 
