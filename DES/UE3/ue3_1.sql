-- 1
SELECT *
FROM (SELECT f.title AS Titel, l1.name AS L, l2.name AS OL
FROM film f
INNER JOIN language l1
    ON (f.language_id = l1.language_id)
INNER JOIN language l2
    ON (f.original_language_id = l2.language_id)
WHERE f.release_year = 1993)
    UNPIVOT (name FOR language IN (L, OL))
ORDER BY Titel;

-- 2
SELECT *
FROM (SELECT c.name AS category, l.name, length AS length
FROM film
INNER JOIN film_category
    USING (film_id)
INNER JOIN category c
    USING (category_id)
INNER JOIN language l
    USING (language_id)
WHERE c.name IN ('Family', 'Children', 'Animation'))
    PIVOT (
    AVG(length) AS LENGTH
    FOR category IN ('Family' AS Family, 'Children' AS Children, 'Animation' AS Animation)
    );

-- 3
SELECT *
FROM (SELECT COUNT(*) AS Anzahl,
    CASE WHEN GROUPING(name) = 1 THEN 'Gesamt' ELSE name END AS Kategorie,
    CASE WHEN GROUPING(store_id) = 1 THEN 'Gesamt' ELSE TO_CHAR(store_id) END AS Filiale
FROM inventory
INNER JOIN film_category
    USING (film_id)
INNER JOIN category
    USING (category_id)
GROUP BY CUBE (store_id, name))
    PIVOT (
    SUM(Anzahl)
    FOR filiale IN ('1' AS Filiale1, '2' AS Filiale2, '3' AS Filiale3,'4' AS Filiale4, '5' AS Filiale5, '6' AS Filiale6, 'Gesamt' AS Gesamt)
    );