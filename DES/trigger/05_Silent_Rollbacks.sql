-- Silent Rollbacks können im Mehrbenutzerbetrieb auftreten und werden
-- von der Datenbank für Serialisierung von mehreren Sessions verwendet
-- https://asktom.oracle.com/Misc/something-different-part-i-of-iii.html
-- https://asktom.oracle.com/Misc/part-ii-seeing-restart.html
-- https://asktom.oracle.com/Misc/part-iii-why-is-restart-important-to.html
-- https://asktom.oracle.com/Misc/that-old-restart-problem-again.html
DROP TABLE t;

CREATE TABLE t ( 
  x INT, 
  y INT 
);

INSERT INTO t VALUES ( 1, 1 );

CREATE OR REPLACE TRIGGER t_buffer
BEFORE UPDATE ON t
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE ('OLD.x = ' || :OLD.x || ', OLD.y = ' || :OLD.y);
  DBMS_OUTPUT.PUT_LINE ('NEW.x = ' || :NEW.y || ', NEW.y = ' || :NEW.y);
END;
/

-- Session 1
UPDATE t
SET x = x + 1;

-- Session 2 (Strg+Shift+n)
UPDATE t
SET x = x + 1
WHERE x > 0;
-- Statement blockiert in Session 2

-- Session 1
COMMIT;

-- Session 2: doppelte Ausgabe, zuerst für 1. Änderung (die im Hintergrund zurückgerollt wurde), dann für die
-- 2. Änderung basierend auf den Werten von Session 1
-- hier sieht man, dass der Trigger tatsächlich 2x gefeuert hat
-- Achtung bei DBMS+UTL-Paketen, solche Funktionen (Schreiben in Datei, Versand von Mail) werden vom
-- Trigger ausgeführt, können allerdings im Falle eines Rollbacks nicht rückgängig gemacht werden.

-- Auf Design achten - ist ein Trigger die richtige Wahl für diese Aufgabe? Ist der Trigger transaktionssicher?
-- Möglichkeit für Implementierung wäre über Materialisierte Sichten (UPDATE on COMMIT) bzw. Datenbank-Job.
