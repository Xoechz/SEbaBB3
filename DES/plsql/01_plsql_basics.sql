SET SERVEROUTPUT ON;

-- Erstellen Sie einen PL/SQL Block der eine Variable emp_id deklariert und den Vor- und Nachnamen des Mitarbeiters mit jener employeeid ausgibt.

DECLARE
    emp_id EMPLOYEES.EMPLOYEE_ID%TYPE;
    fname EMPLOYEES.FIRST_NAME%TYPE;
    lname EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    emp_id := 100;
    SELECT FIRST_NAME, LAST_NAME
    INTO fname, lname
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = emp_id;
    DBMS_OUTPUT.PUT_LINE('Employee ' || emp_id || ' is ' || fname || ' ' || lname);
END;


-- TODO

-- =========================================================================================================

-- Erstellen Sie eine Function 'CelsiusToFahrenheit', die einen Celsius-Betrag in Fahrenheit umrechnet.
-- TemperatureFahrenheit := TemperatureCelsius * 1.8 + 32;

CREATE OR REPLACE FUNCTION CelsiusToFahrenheit(TemperatureCelsius NUMBER) RETURN NUMBER
    IS
BEGIN
    RETURN TemperatureCelsius * 1.8 + 32;
END;

BEGIN
    dbms_output.put_line(CelsiusToFahrenheit(0));
END;
-- 32

-- =========================================================================================================

-- Erstellen Sie eine Prozedur 'WaterState', die je nach übergebener Temperatur in Celsius ausgibt, in welchem Aggregatszustand sich Wasser befinden würde.
-- EXECUTE WaterState(-10); --> 'Bei einer Temperatur von -10 Grad ist Wasser auf Meereshöhe fest.'
-- EXECUTE WaterState(0); --> 'Bei einer Temperatur von 0 Grad ist Wasser auf Meereshöhe fest.'
-- EXEC WaterState(10); --> 'Bei einer Temperatur von 10 Grad ist Wasser auf Meereshöhe flüssig.'
-- EXEC WaterState(100); --> 'Bei einer Temperatur von 100 Grad ist Wasser auf Meereshöhe gasförmig.'

CREATE OR REPLACE PROCEDURE WaterState(TempCelsius NUMBER)
    IS
BEGIN
    CASE
        WHEN TempCelsius <= 0 THEN dbms_output.put_line('Bei einer Temperatur von ' || TempCelsius ||
                                                        ' Grad ist Wasser auf Meereshöhe fest.');
        WHEN TempCelsius < 100 THEN dbms_output.put_line('Bei einer Temperatur von ' || TempCelsius ||
                                                         ' Grad ist Wasser auf Meereshöhe flüssig.');
        ELSE dbms_output.put_line('Bei einer Temperatur von ' || TempCelsius ||
                                  ' Grad ist Wasser auf Meereshöhe gasförmig.');
        END CASE;
END;



CALL WaterState(-10);
CALL WaterState(0);
CALL WaterState(10);
CALL WaterState(100);
CALL WaterState(1000);


-- =========================================================================================================

-- Erstellen Sie eine Procedure Fibonacci, die alle Fibonacci-Zahlen bis zur übergebenen Position ausgibt.
-- Verwenden Sie eine FOR Schleife
-- EXEC fibonacci(7); -- Output: '0 1 1 2 3 5 8'
-- Folge: a[1] = 0, a[2] = 1, a[n] = a[n-1] + a[n-2]

-- TODO

CREATE OR REPLACE PROCEDURE Fibonacci(n NUMBER)
    IS
    a NUMBER := 0;
    b NUMBER := 1;
    c NUMBER;
BEGIN
    dbms_output.put(a || ' ');
    dbms_output.put(b || ' ');
    FOR i IN 3..n
        LOOP
            c := a + b;
            dbms_output.put(c || ' ');
            a := b;
            b := c;
        END LOOP;
    dbms_output.new_line;
END;

CALL Fibonacci(0);


-- =========================================================================================================
-- Erstellen Sie eine Function `Exchange`, die folgende Tabelle nutzt, um einen Betrag von einer Währung in eine andere zu konvertieren.
-- Fehlerbehandlung kann vernachlässigt werden.
CREATE TABLE DEF_Currency
(
    CurrencyISOCode VARCHAR(3) PRIMARY KEY,
    ExchangeRateEUR NUMBER(19, 4) NOT NULL
);
INSERT INTO DEF_Currency
VALUES ('EUR', 1.0000);
INSERT INTO DEF_Currency
VALUES ('USD', 0.8500); -- 1 USD = 0.85 EUR
INSERT INTO DEF_Currency
VALUES ('CHF', 0.9300);
INSERT INTO DEF_Currency
VALUES ('GBP', 1.1100);
INSERT INTO DEF_Currency
VALUES ('RUB', 0.0110);
/
CREATE OR REPLACE FUNCTION Exchange(amount NUMBER, inCurrency VARCHAR, toCurrency VARCHAR) RETURN NUMBER
    IS
    exchangeRateEur NUMBER;
    exchangeRateTo NUMBER;
    euroAmount NUMBER;
BEGIN
    SELECT ExchangeRateEUR INTO exchangeRateEur FROM DEF_Currency WHERE CurrencyISOCode = inCurrency;
    SELECT ExchangeRateEUR INTO exchangeRateTo FROM DEF_Currency WHERE CurrencyISOCode = toCurrency;

    euroAmount := amount * exchangeRateEur;
    RETURN euroAmount / exchangeRateTo;
END;
/
SELECT Exchange(100, 'EUR', 'USD')
FROM DUAL;

SELECT Exchange(100, 'USD', 'EUR')
FROM DUAL;

SELECT Exchange(100, 'USD', 'GBP')
FROM DUAL;

-- =========================================================================================================

-- Erstellen Sie eine Funktion EvaluateOffer, welche Quadratmeter, Anzahl der Räume und den Preis (asking price) übernimmt und einen einfachen Entscheidungsbaum erstellt, welcher
-- 1 für ein Sehr gutes Angebot, wenn der Preis pro Quadratmeter unter 1500 liegt
-- 4 für ein eher teures Angebot, wenn der Preis pro Quadratmeter über 3000 liegt
-- 2 wenn der Quadratmeterpreis zwischen den oberen Schranken liegt, aber die Immobilie mehr als 3 Räume hat
-- 3 für alle anderen Fälle.

CREATE TABLE RealEstate
(
    RealEstateID INTEGER PRIMARY KEY,
    SquareMeters INTEGER,
    Floors       INTEGER,
    BathRooms    INTEGER,
    Rooms        INTEGER,
    AskingPrice  INTEGER
);
/
INSERT INTO RealEstate
VALUES (1, 100, 1, 2, 4, 220000);
INSERT INTO RealEstate
VALUES (2, 65, 1, 1, 3, 120000);
INSERT INTO RealEstate
VALUES (3, 160, 2, 2, 6, 500000);
INSERT INTO RealEstate
VALUES (4, 80, 1, 2, 4, 200000);
INSERT INTO RealEstate
VALUES (5, 55, 1, 1, 3, 120000);
INSERT INTO RealEstate
VALUES (6, 150, 1, 1, 3, 180000);
INSERT INTO RealEstate
VALUES (7, 110, 2, 2, 4, 220000);
COMMIT;
/

CREATE OR REPLACE FUNCTION EvaluateOffer(squareMeters NUMBER, rooms NUMBER, askingPrice NUMBER) RETURN NUMBER
    IS
    pricePerSquareMeter NUMBER;
BEGIN
    pricePerSquareMeter := askingPrice / squareMeters;
    IF pricePerSquareMeter < 1500 THEN
        RETURN 1;
    ELSIF pricePerSquareMeter > 3000 THEN
        RETURN 4;
    ELSIF pricePerSquareMeter >= 1500 AND pricePerSquareMeter <= 3000 AND rooms > 3 THEN
        RETURN 2;
    ELSE
        RETURN 3;
    END IF;
END;

/

SELECT RealEstateID, SquareMeters, Rooms, AskingPrice, EvaluateOffer(SquareMeters, Rooms, AskingPrice) AS Evaluation
FROM RealEstate;