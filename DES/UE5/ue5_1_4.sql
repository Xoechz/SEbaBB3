ALTER TABLE payment
    ADD user_modified VARCHAR2(50);

CREATE OR REPLACE TRIGGER LOG_PAYMENT
    BEFORE UPDATE OF AMOUNT
    ON PAYMENT
    FOR EACH ROW
BEGIN
    :NEW.user_modified := USER;
    :NEW.last_update := SYSDATE;
END;

-- Ausgabe 1_4_1
SELECT *
FROM PAYMENT
WHERE PAYMENT_ID IN (6500, 3000, 1200);

-- fails, no log
-- Ausgabe 1_4_2
UPDATE payment
SET amount = 25
WHERE payment_id = 6500;

-- works, logs
-- Ausgabe 1_4_3
UPDATE payment
SET amount = 1
WHERE payment_id = 3000;

-- works, no trigger fired => no log
-- Ausgabe 1_4_4
UPDATE payment
SET PAYMENT_DATE = TO_DATE('2020-03-19', 'YYYY-MM-DD')
WHERE payment_id = 1200;

-- Ausgabe 1_4_5
SELECT *
FROM PAYMENT
WHERE PAYMENT_ID IN (6500, 3000, 1200);

ROLLBACK;

ALTER TABLE PAYMENT
    DROP COLUMN user_modified;

DROP TRIGGER LOG_PAYMENT;