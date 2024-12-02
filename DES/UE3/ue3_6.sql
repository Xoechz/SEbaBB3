-- a
CREATE OR REPLACE VIEW UE03_06a
AS
WITH revenues AS (SELECT SUM(amount) AS Umsatz,
    c.name AS Kategorie,
    r.staff_id
FROM category c
INNER JOIN film_category
    USING (category_id)
INNER JOIN inventory i
    USING (film_id)
INNER JOIN rental r
    USING (inventory_id)
INNER JOIN payment
    USING (rental_id)
GROUP BY c.name, r.staff_id)
SELECT Kategorie, "1_UMSATZ", "2_UMSATZ", ROUND("1_UMSATZ" / "2_UMSATZ", 2) AS Verhältnis
FROM revenues r
    PIVOT (
    SUM(Umsatz) AS UMSATZ
    FOR staff_id IN ('1' AS "1", '2' AS "2")
    )
ORDER BY Kategorie;

SELECT *
FROM UE03_06a;

--b
CREATE MATERIALIZED VIEW UE03_06b
    REFRESH COMPLETE ON DEMAND
AS
SELECT *
FROM UE03_06a;

SELECT *
FROM UE03_06b;

-- c
CREATE MATERIALIZED VIEW UE03_06c
    REFRESH COMPLETE START WITH TRUNC(SYSDATE) + 23.5 / 24 NEXT SYSDATE + 1
AS
SELECT *
FROM UE03_06b;

SELECT *
FROM UE03_06c;

-- cleanup
DROP VIEW UE03_06a;
DROP MATERIALIZED VIEW UE03_06b;
DROP MATERIALIZED VIEW UE03_06c;
