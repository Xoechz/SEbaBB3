-- INSTEAD OF-Trigger: 
-- werden verwendet, um Daten zu ändern, bei denen eine DML-Anweisung 
--   für eine View abgesetzt wird, die implizit nicht aktualisierbar ist.
-- Der Oracle-Server führt nicht das Ereignis aus, sondern führt statt dessen den Trigger aus.
-- INSTEAD OF Trigger sind immer Row-Trigger

-- INSERT/UPDATE/DELETE wäre auf komplexe, virtuelle View/Sicht sonst nicht erlaubt
-- Instead of Trigger wird anstelle der INSERT/UPDATE/DELETE Anweisung auf die View ausgeführt.
-- Dabei werden die Aktionen je nach Änderungsart (INSERT, UPDATE, DELETE) ausgeführt
-- Ein Instead-of Trigger ist immer ein ROW-Trigger
--   d.h. er wird einmal für jede vom auslösenden Ereignis betroffene Zeile ausgeführt.
-- Mit Hilfe von Korrelationsnamen (:OLD, :NEW) kann auf die alten und neuen Spaltenwerte der
--   Zeile zugegriffen werden, die durch den Trigger verarbeitet wird.
CREATE TABLE table_x ( 
  column1 INT, 
  column2 INT
);

INSERT INTO table_x VALUES (1, 10);
INSERT INTO table_x VALUES (1, 20);

CREATE OR REPLACE VIEW view_x AS -- durch Gruppierung eine komplexe, virtuelle View/Sicht
  SELECT x.column1, SUM(x.column2) AS SumColumn2
    FROM table_x x
    GROUP BY x.column1;

INSERT INTO view_x VALUES (1, 1); -- Fehler, kein Einfügen auf komplexe View (komplex, da sie Gruppierung beinhaltet) möglich

--TODO
--CREATE OR REPLACE TRIGGER trigger_view_x




--/

-- Test again
SET SERVEROUTPUT ON;
-- INSTEAD OF Trigger trigger_view_x schleust INSERT nun zu table_x durch
INSERT INTO view_x VALUES (1, 1);

SELECT * FROM table_x;
SELECT * FROM view_x;

DROP VIEW view_x;
DROP TABLE table_x;