SELECT * from PAYMENT where PAYMENT_ID in (6500, 3000, 1200);

-- works
UPDATE payment
SET amount = 25
WHERE payment_id = 6500;

-- fails
UPDATE payment
SET amount = 1
WHERE payment_id = 3000;

-- works
UPDATE payment
SET amount = -10
WHERE payment_id = 1200;

-- works, no trigger fired
UPDATE payment
SET PAYMENT_DATE = TO_DATE('2020-03-19', 'YYYY-MM-DD')
WHERE payment_id = 1200;

ROLLBACK;