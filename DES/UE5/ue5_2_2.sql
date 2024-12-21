CREATE OR REPLACE TRIGGER instead_of_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE
    ON premium_customer
    FOR EACH ROW
DECLARE
    new_customer_id NUMBER;
BEGIN
    IF DELETING THEN
        DELETE
        FROM NEW_RENTAL
        WHERE customer_id = :OLD.customer_id;
        DELETE
        FROM NEW_CUSTOMER
        WHERE customer_id = :OLD.customer_id;
    ELSIF INSERTING THEN
        IF :NEW.customer_id IS NULL THEN
            SELECT MAX(CUSTOMER_ID) + 1
            INTO new_customer_id
            FROM NEW_CUSTOMER;
        ELSE
            new_customer_id := :NEW.customer_id;
        END IF;
        INSERT INTO NEW_CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, CREATE_DATE, LAST_UPDATE)
        VALUES (new_customer_id, :NEW.FIRST_NAME, :NEW.LAST_NAME, SYSDATE, SYSDATE);
    ELSIF UPDATING ('numFilms') THEN
        RAISE_APPLICATION_ERROR(-20000, 'You cannot update the number of films');
    ELSIF UPDATING ('CUSTOMER_ID') THEN
        RAISE_APPLICATION_ERROR(-20000, 'You cannot update the primary key customer id');
    ELSIF UPDATING THEN
        UPDATE NEW_CUSTOMER
        SET FIRST_NAME  = :NEW.FIRST_NAME,
            LAST_NAME   = :NEW.LAST_NAME,
            LAST_UPDATE = SYSDATE
        WHERE CUSTOMER_ID = :NEW.CUSTOMER_ID;
    END IF;
END;