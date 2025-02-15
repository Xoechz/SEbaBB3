-- Annahme: Eine der Bedingungen muss gegeben sein, Min und Max würden sonst imme eine leere Zeile ergeben.
SELECT s.STORE_ID, m.FIRST_NAME, m.LAST_NAME, COUNT(DISTINCT i.INVENTORY_ID) AS InventoryCount
FROM STORE s
LEFT JOIN STAFF m
    ON s.MANAGER_STAFF_ID = m.STAFF_ID
LEFT JOIN INVENTORY i
    ON s.STORE_ID = i.STORE_ID
LEFT JOIN STAFF e
    ON e.STORE_ID = s.STORE_ID
GROUP BY s.STORE_ID, m.FIRST_NAME, m.LAST_NAME
HAVING COUNT(DISTINCT e.STAFF_ID) > 1
    OR COUNT(DISTINCT e.STAFF_ID) = 0
    OR COUNT(DISTINCT i.INVENTORY_ID) = MAX(DISTINCT i.INVENTORY_ID)
    OR COUNT(DISTINCT i.INVENTORY_ID) = MIN(DISTINCT i.INVENTORY_ID);

-- INSERT INTO STORE (STORE_ID, MANAGER_STAFF_ID, ADDRESS_ID, LAST_UPDATE)
-- VALUES (7, 1, 223, CURRENT_TIMESTAMP);
--
-- DELETE
-- FROM STORE
-- WHERE STORE_ID = 7;