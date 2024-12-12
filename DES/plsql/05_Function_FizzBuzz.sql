-- CREATE FIZZBUZZ to get the OUTPUT below
-- hints: 
-- MOD(x, y) returns the remainder of x divided by y. (Returns x if y is 0.)
-- example: MOD(5, 3) -> 2
-- RETURN STRING and use to_char(...) in RETURN
-- SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION FIZZBUZZ(i IN NUMBER) RETURN VARCHAR2
    IS
BEGIN
--     IF MOD(i, 3) = 0 AND MOD(i, 5) = 0 THEN
--         RETURN 'fizzbuzz';
--     ELSIF MOD(i, 3) = 0 THEN
--         RETURN 'fizz';
--     ELSIF MOD(i, 5) = 0 THEN
--         RETURN 'buzz';
--     ELSE
--         RETURN TO_CHAR(i);
--     END IF;
    RETURN
        CASE
            WHEN (MOD(i, 3) = 0 AND MOD(i, 5) = 0) THEN 'fizzbuzz'
            WHEN MOD(i, 3) = 0 THEN 'fizz'
            WHEN MOD(i, 5) = 0 THEN 'buzz'
            ELSE TO_CHAR(i)
            END;
END;

BEGIN
    FOR i IN 1..16
        LOOP
            DBMS_OUTPUT.PUT_LINE(i || ' ' || FIZZBUZZ(i));
        END LOOP;
END;

-- OUTPUT
-- 1       '1'
-- 2       '2'
-- 3       'fizz'
-- 4       '4'
-- 5       'buzz'
-- 6       'fizz'
-- 7       '7'
-- 8       '8'
-- 9       'fizz'
-- 10      'buzz'
-- 11      '11'
-- 12      'fizz'
-- 13      '13'
-- 14      '14'
-- 15      'fizzbuzz'
-- 16      '16'