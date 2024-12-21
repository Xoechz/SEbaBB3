CREATE OR REPLACE PROCEDURE CHECK_AMOUNT(RENTED_FILM_ID FILM.FILM_ID%TYPE, PAID_AMOUNT FILM.RENTAL_RATE%TYPE,
                                         RENTAL_DURATION NUMBER, CORRECTED_AMOUNT OUT FILM.RENTAL_RATE%TYPE) AS
    FILM_RENTAL_RATE FILM.RENTAL_RATE%TYPE;
BEGIN
    SELECT RENTAL_RATE INTO FILM_RENTAL_RATE FROM FILM WHERE RENTED_FILM_ID = FILM_ID;

    IF FILM_RENTAL_RATE * RENTAL_DURATION < PAID_AMOUNT THEN
        RAISE_APPLICATION_ERROR(-20001,
                                'Invalid amount for film ' || RENTED_FILM_ID || ', maximum for ' || RENTAL_DURATION ||
                                ' days is ' || RENTAL_DURATION * FILM_RENTAL_RATE || '.');
    END IF;

    IF PAID_AMOUNT < 0 THEN
        CORRECTED_AMOUNT := 0;
    ELSE
        CORRECTED_AMOUNT := PAID_AMOUNT;
    END IF;
END;

-- Ausgabe 1_1
DECLARE
    amount NUMBER;
BEGIN
    amount := 17;
    dbms_output.put_line('Test 200, 5, 3');
    CHECK_AMOUNT(200, 5, 3, amount);
    DBMS_OUTPUT.PUT_LINE('Out Amount: ' || amount);

    dbms_output.put_line('Test 200, -20, 3');
    CHECK_AMOUNT(200, -20, 3, amount);
    DBMS_OUTPUT.PUT_LINE('Out Amount: ' || amount);

    dbms_output.put_line('Test 200, 20, 3');
    CHECK_AMOUNT(200, 20, 3, amount);
    DBMS_OUTPUT.PUT_LINE('Out Amount: ' || amount);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || SQLERRM);
END;