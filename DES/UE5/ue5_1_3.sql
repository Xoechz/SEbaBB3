-- Ausgabe 1_3_1
SELECT *
FROM PAYMENT
WHERE PAYMENT_ID IN (6500, 3000, 1200);

-- fails
-- Ausgabe 1_3_2
UPDATE payment
SET amount = 25
WHERE payment_id = 6500;

-- works
-- Ausgabe 1_3_3
UPDATE payment
SET amount = 1
WHERE payment_id = 3000;

-- works
-- Ausgabe 1_3_4
UPDATE payment
SET amount = -10
WHERE payment_id = 1200;

-- works, no trigger fired
-- Ausgabe 1_3_5
UPDATE payment
SET PAYMENT_DATE = TO_DATE('2020-03-19', 'YYYY-MM-DD')
WHERE payment_id = 1200;

-- Ausgabe 1_3_6
SELECT * from PAYMENT where PAYMENT_ID in (6500, 3000, 1200);

ROLLBACK;