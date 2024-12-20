-- 1
SELECT INITCAP(TITLE) AS CapitalizedTitle
FROM FILM
WHERE TITLE LIKE '___A%';

-- 2
SELECT INVENTORY_ID
FROM INVENTORY i
WHERE NOT EXISTS (SELECT r.RENTAL_ID FROM RENTAL r WHERE r.INVENTORY_ID = i.INVENTORY_ID);

-- 3
SELECT COUNT(*)
FROM RENTAL
WHERE RENTAL_DATE >= TO_DATE('2015-01-01', 'YYYY-MM-DD')
  AND RENTAL_DATE <= TO_DATE('2015-12-31', 'YYYY-MM-DD');

-- 4
SELECT s.STORE_ID, c.CITY, COALESCE(m.LAST_NAME, 'no staff') AS ManagerLastName
FROM STORE s
INNER JOIN ADDRESS A
    ON s.ADDRESS_ID = A.ADDRESS_ID
INNER JOIN CITY c
    ON a.CITY_ID = c.CITY_ID
LEFT JOIN STAFF m
    ON s.MANAGER_STAFF_ID = m.STAFF_ID;

-- 5
SELECT DISTINCT a.FIRST_NAME, a.LAST_NAME
FROM ACTOR a
INNER JOIN FILM_ACTOR fa
    ON a.ACTOR_ID = fa.ACTOR_ID
INNER JOIN FILM f
    ON fa.FILM_ID = f.FILM_ID AND
       f.RELEASE_YEAR > 2006
INNER JOIN FILM_ACTOR fa2
    ON f.FILM_ID = fa2.FILM_ID AND fa2.ACTOR_ID IN (10, 20, 30);

-- 6
SELECT p.AMOUNT,
    INITCAP(TO_CHAR(r.RENTAL_DATE, 'DY, dd. MONTH YYYY', 'NLS_DATE_LANGUAGE = german')),
    INITCAP(TO_CHAR(r.RENTAL_DATE, 'DY, ddth MONTH YYYY', 'NLS_DATE_LANGUAGE = english'))
FROM RENTAL r
JOIN PAYMENT p
    ON r.RENTAL_ID = p.RENTAL_ID
WHERE r.CUSTOMER_ID = 250;