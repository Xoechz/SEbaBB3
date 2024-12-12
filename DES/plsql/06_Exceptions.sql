-- EXCEPTIONS

SET SERVEROUTPUT ON
DECLARE
	lname VARCHAR2(15);
BEGIN
	SELECT last_name INTO lname FROM employees WHERE employee_id BETWEEN 100 AND 110;
	DBMS_OUTPUT.PUT_LINE ('last name is : ' ||lname);
END;
/

-- Abfangen vordefinierter Ausnahmen (vordefinierte Oracle-Server-Fehler):
DECLARE
	lname VARCHAR2(15);
BEGIN            
	SELECT last_name INTO lname FROM employees WHERE employee_id BETWEEN 100 AND 110;
	DBMS_OUTPUT.PUT_LINE ('last name is : ' ||lname);
EXCEPTION
	WHEN TOO_MANY_ROWS THEN	
		DBMS_OUTPUT.PUT_LINE (' Your select statement retrieved multiple rows. Consider using a	cursor.');
	WHEN NO_DATA_FOUND THEN	
		DBMS_OUTPUT.PUT_LINE (' Your select statement retrieved no rows.');
END;
/

-- Nicht vordefinierte Fehler:                                     
-- (z.B. Fehler: kann NULL nicht einfügen, ein Constraint ist auf department_name definiert).                                                                            
DECLARE
	insert_excep EXCEPTION;
	PRAGMA EXCEPTION_INIT (insert_excep, -01400);
BEGIN
	INSERT INTO departments (department_id, department_name) 
	VALUES (280, NULL);
EXCEPTION
	WHEN insert_excep THEN
		DBMS_OUTPUT.PUT_LINE('INSERT OPERATION auf department_name nicht möglich');
END;
/

-- Benutzerdefinierte Exceptions auslösen und abfangen

-- Erzeugen einer Tabelle errors zum Protokollieren von nicht spezifizierten Exceptions
CREATE TABLE errors (
	err_num NUMBER,
	err_msg VARCHAR2(100)
);


SET VERIFY OFF
DECLARE
	invalid_department EXCEPTION;	
	name VARCHAR2(20):='&name';
	deptno NUMBER :=&deptno;
	err_num NUMBER;
	err_msg VARCHAR2(100);
BEGIN	
	UPDATE departments
	SET department_name = name
	WHERE department_id = deptno;

    -- TODO: Auslösen der benutzerdefinierten Ausnahme, wenn die angegebene Abteilungsnummer nicht vorhanden ist.
    IF SQL%NOTFOUND THEN

    END IF;	
	
	-- führt zu einer Exception, wenn zB die Abteilungsnummer bereits vorhanden ist
	INSERT INTO departments VALUES (deptno,name,NULL,NULL);
	COMMIT;
EXCEPTION
	WHEN invalid_department THEN	-- Referenzieren der benutzerdefinierten Exception (Fangen der Exception)
		DBMS_OUTPUT.PUT_LINE('No such department id.');
	WHEN OTHERS THEN				-- Referenzieren von nicht spezifizierten Exceptions
		DBMS_OUTPUT.PUT_LINE('Insert message in error-table.');	
		-- SQLCODE: gibt den numerischen Wert für den Fehlercode zurück.
		err_num := SQLCODE;		
		-- SQLERRM: gibt die der Fehlernummer zugeordnete Meldung zurück.
		err_msg := SUBSTR(SQLERRM, 1, 100);
		-- speichern der unbekannten Exception in der Tabelle errors
		INSERT INTO errors VALUES (err_num, err_msg);
END;
/

SELECT * FROM errors;

DROP TABLE errors;

-- Absetzen von benutzerdefinierten Fehlermeldungen
-- Prozedur: RAISE_APPLICATION_ERROR(err_number, err_message)

-- Absetzen von benutzerdefinierten Fehlermeldungen im ausführbaren Bereich:
BEGIN
	DELETE FROM employees
	WHERE manager_id = 1;	-- gibt keine Fehlermeldung aus

	IF SQL%NOTFOUND THEN
		--Ausgabe einer benutzerdefinierten Oracle-Server-Fehlermeldung
		RAISE_APPLICATION_ERROR(-20202,'This is not a valid manager');
	END IF;
END;
/

-- Absetzen von benutzerdefinierten Fehlermeldungen im Exception-Bereich:
DECLARE
	depId NUMBER;
BEGIN
	SELECT department_id INTO depId FROM employees
	WHERE employee_id = 1;

	DBMS_OUTPUT.PUT_LINE('Die Abteilungsnummer des  Angestellten ist '|| depId);

EXCEPTION
	WHEN NO_DATA_FOUND THEN	   
		-- Der vordefinierte Fehler (ORA-001403: keine Daten gefunden) 
		-- wird durch einen benutzerdefinierten Fehler ersetzt.
		RAISE_APPLICATION_ERROR (-20201,'No valid employee_id!');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Unspecified error catched in OTHERS');	

END;
/

--weitere Verwendung von RAISE_APPLICATION_ERROR
DECLARE
	e_name EXCEPTION;
	-- Umleiten der benutzerdefinierten Exception auf eine benutzerdefinierte Fehlernummer
	PRAGMA EXCEPTION_INIT (e_name, -20999); 
BEGIN
	--Löschen des Angestellten mit dem Nachnamen 'Max'
	DELETE FROM employees
	WHERE last_name = 'Max';

	IF SQL%NOTFOUND THEN
		--Auslösen des benutzerdefinierten Fehlers
		RAISE_APPLICATION_ERROR(-20999,'This is not a valid last name');
	END IF;
EXCEPTION
	--Abfangen der benutzerdefinierten Exceptions ausgelöst durch einen
	--benutzerdefinierten Fehler
	WHEN e_name THEN
		DBMS_OUTPUT.PUT_LINE('Max not found in employees');		
END;
/