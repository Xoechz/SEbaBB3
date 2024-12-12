-- 2
DROP TYPE top_store_tab;
DROP TYPE top_store_row;

-- 2
CREATE TYPE top_store_row AS OBJECT
(
    storeId   NUMBER,
    storeCity VARCHAR2(100),
    revenue   NUMBER
);

-- 2
CREATE TYPE top_store_tab IS TABLE OF top_store_row;

CREATE OR REPLACE PACKAGE get_sales_volume_pkg AS
    -- 1
    FUNCTION GetRevenue(store IN NUMBER)
        RETURN NUMBER;
    -- 2
    FUNCTION GetTop3Stores
        RETURN top_store_tab PIPELINED;
    -- 3
    FUNCTION GetTopNStores(n IN NUMBER := 3)
        RETURN top_store_tab PIPELINED;
END;

CREATE OR REPLACE PACKAGE BODY get_sales_volume_pkg AS
    -- 1
    FUNCTION GetRevenue(store IN NUMBER)
        RETURN NUMBER
        IS
        sum_payments NUMBER;
    BEGIN
        SELECT SUM(amount)
        INTO sum_payments
        FROM payment p
        INNER JOIN staff s
            USING (staff_id)
        WHERE s.store_id = store;
        RETURN sum_payments;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;

    -- 2
    FUNCTION GetTop3Stores
        RETURN top_store_tab PIPELINED
        IS
        CURSOR storeCursor IS SELECT s.STORE_ID, c.CITY, COALESCE((GetRevenue(s.STORE_ID)), 0) AS revenue
        FROM STORE s
        INNER JOIN ADDRESS a
            ON s.ADDRESS_ID = a.ADDRESS_ID
        INNER JOIN CITY c
            ON a.CITY_ID = c.CITY_ID
        ORDER BY revenue DESC
            FETCH FIRST 3 ROWS ONLY; -- you could also use with ties to include 2 third places for example
    BEGIN
        FOR storeRec IN storeCursor
            LOOP
                PIPE ROW (top_store_row(storeRec.STORE_ID, storeRec.CITY, storeRec.revenue));
            END LOOP;
    END;

    -- 3
    FUNCTION GetTopNStores(n IN NUMBER := 3)
        RETURN top_store_tab PIPELINED
        IS
        CURSOR storeCursor IS SELECT s.STORE_ID, c.CITY, COALESCE((GetRevenue(s.STORE_ID)), 0) AS revenue
        FROM STORE s
        INNER JOIN ADDRESS a
            ON s.ADDRESS_ID = a.ADDRESS_ID
        INNER JOIN CITY c
            ON a.CITY_ID = c.CITY_ID
        ORDER BY revenue DESC
            FETCH FIRST n ROWS ONLY; -- you could also use with ties to include 2 third places for example
    BEGIN
        FOR storeRec IN storeCursor
            LOOP
                PIPE ROW (top_store_row(storeRec.STORE_ID, storeRec.CITY, storeRec.revenue));
            END LOOP;
    END;
END;

-- 1
SELECT get_sales_volume_pkg.GetRevenue(2)
FROM dual;

-- 2
SELECT *
FROM TABLE (get_sales_volume_pkg.GetTop3Stores());

-- 3
SELECT *
FROM TABLE (get_sales_volume_pkg.GetTopNStores());

-- 3
SELECT *
FROM TABLE (get_sales_volume_pkg.GetTopNStores(5));

