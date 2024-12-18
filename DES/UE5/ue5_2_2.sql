CREATE OR REPLACE TRIGGER instead_of_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE
    ON premium_customer
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        DELETE
        FROM NEW_RENTAL
        WHERE customer_id = :OLD.customer_id;
        DELETE
        FROM NEW_CUSTOMER
        WHERE customer_id = :OLD.customer_id;
    END IF;
END;