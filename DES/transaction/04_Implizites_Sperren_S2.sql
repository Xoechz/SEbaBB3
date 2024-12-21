/*SESSION 2*/
/*Skript NICHT als gesamtes ausführen*/
/*Ausführung in Abstimmung mit Session 1 bzw. Partner*in*/

/* Anleitung für die Durchführung dieses Demo-Skripts:
2 Möglichkeiten:
A) 1 Benutzer greift mit zwei Sessions auf die Datenbank zu (dazu wird die gleiche Tabelle verwendet);
   für Session 2 wird ein Synonym erstellt
B) 2 Benutzer greifen auf eine Tabelle zu, dazu wird ein GRANT verwendet und der Partner erstellt ein Synonym.
*/
/*
Transaktionen in Oracle: 

i.A.: Oracle sperrt alle benötigten Daten automatisch;
Ob eine Sperre implizit angefordert wird und wie lange 
sie dann der Transaktion zugeordnet bleibt, hängt vom
Isolation_Level der Session ab. 

explizite Angaben: 

COMMIT [WORK]: dauerhafte Speicherung der bisherigen Änderungen, 
Lösen aller Sperren, Löschen aller Savepoints der Transaktion, 
Start einer neuen Transaktion; vor u. nach jedem DDL-Befehl: 
automatisches COMMIT 

ROLLBACK [WORK]: Rücksetzen aller Änderungen seit dem letzten 
Transaktionsbeginn, Beenden der Transaktion, Löschen aller Savepoints 
der Transaktion, Lösen aller Sperren;
 
ROLLBACK [WORK] TO [SAVEPOINT] spname: Rollback der aktuellen 
Transaktion bis zum Savepoint spname, Löschen aller Savepoints 
nach spname, Lösen aller Sperren seit dem Savepoint spname
 
SAVEPOINT spname: Setzen eines Savepoints namens spname 

SET TRANSACTION READ ONLY | READ WRITE | ISOLATION LEVEL SERIALIZABLE | 
ISOLATION LEVEL READ COMMITTED |USE ROLLBACK SEGMENT rb_seg_name: 
setzt den Modus der aktuellen Transaktion (gilt nur bis zum nächsten 
COMMIT, ROLLBACK, DDL-Kommando), Voreinstellung: READ WRITE 

LOCK TABLE relname1 [,relname2,..] IN modus MODE [NOWAIT]: Sperren 
von Relation(en) oder View(s); überschreibt automatische Sperren; 
erlaubte Modi: 
ROW SHARE, SHARE UPDATE: erlaubt gleichzeitigen lesenden Zugriff, 
verbietet Updates; kein anderer Benutzer kann EXCLUSIVE-Modus auf 
Relation setzen

ROW EXCLUSIVE: erlaubt gleichzeitigen lesenden Zugriff, verhindert 
SHARE-Sperren durch andere; automatisch gewählter Modus bei 
UPDATE, INSERT, DELETE

SHARE: erlaubt gleichzeitigen lesenden Zugriff, verbietet Updates; 
kann von verschiedenen Benutzern auf gleicher Relation gegeben werden

EXCLUSIVE:erlaubt lesenden Zugriff, verbietet jede andere Aktivität anderer
-> keine Relation kann gegen Lesen anderer gesperrt werden! 

SELECT ...FOR UPDATE [NOWAIT]: expl. Sperren einer Relation/von Tupeln, 
Sperre gilt bis COMMIT/ROLLBACK 

Wird NOWAIT spezifiziert, wird nicht auf die Freigabe einer Sperre 
durch eine andere Transaktion gewartet, sondern im Fall einer Sperrkollision 
ein Fehler gemeldet. Liegt keine Kollision vor, wird die gewünschte Sperre gesetzt. 

Wenn nicht NOWAIT angegeben ist, wird bei einer Sperrkollision auf die Freigabe 
von Sperren maximal so lange gewartet, wie der Installationsparameter
REQUEST TIMEOUT im Oracle Datenbankserver angibt.
*/

/* Anleitung für die Durchführung dieses Demo-Skripts:
2 Möglichkeiten:
A) 1 Benutzer greift mit zwei Sessions auf die Datenbank zu (dazu wird die gleiche Tabelle verwendet); 
   für Session 2 wird ein Synonym erstellt
B) 2 Benutzer greifen auf eine Tabelle zu, dazu wird ein GRANT verwendet und der Partner erstellt ein Synonym.
*/

-- DB-Session S1 starten
-- Isolationsstufe READ COMMITTED (= DEFAULT)
-- Demo-Relation anlegen
--create table test (a number, b number);

-- Session 1: Zugriff auf Tabelle f. User 2 (Session 2) erteilen (nur wenn 2 User!)
--GRANT SELECT, INSERT, UPDATE, DELETE ON test TO <<PARTNER_USER>>;
-- Session 2: mit anderem User, Synonym erstellen (wenn nur 1 User: Synonym auf eigene Tabelle!)
CREATE SYNONYM partner_test FOR <<NORMAL_USER>>.test;

-- Demo-Relation mit Daten füllen
--insert into test values (1,10);
--insert into test values (2,20);

-- DB-Session S2 starten (CTRL+SHIFT+N in SQL developer)
-- Isolationsstufe READ COMMITTED (= DEFAULT)
select * from partner_test;
-- Es werden keine Datensätze angezeigt, da S1 noch kein Commit abgesetzt hat

-- S1
--commit;

-- S2
select * from partner_test;
-- Datensätze werden angezeigt, da Isolationsstufe READ COMMITTED

-- S1
--insert into test values (3, 30);
--select * from test;
-- Aktualisierung erscheint in S1

-- S2
select * from partner_test;
-- Aktualisierung erscheint in S2 nicht,
-- da Isolationsstufe READ COMMITTED eingestellt ist

-- S1
--commit;

-- S2
select * from partner_test;
-- Aktualisierung erscheint in S2. 
-- Non-repeatable read sowie phantom-Problem
-- werden bei der Isolationsstufe READ COMMITTED nicht behandelt!

-- S1
--update test set b = 3000 where a = 3;

-- S2
select * from partner_test where a = 3;
-- bei select wird keine Sperre gesetzt, aufgrund
-- von MVCC wird lesekonsistente Version geliefert,
-- d.h. b=30! Neuer Wert von b wird nicht geliefert,
-- da S1 noch kein Commit abgesetzt hat.

-- S2
select * from partner_test where a = 3 FOR UPDATE;
-- Hierarchische Sperren werden gesetzt
-- Sperre auf Tabelle: RS, Sperre auf Datensatz: X
-- S2 blockiert, da S1 bereits eine Schreibsperre auf den Datensatz hält!

-- Alternative gegen Blockierung
select * from partner_test where a = 3 FOR UPDATE NOWAIT;
-- Prüft vorher, ob es bereits eine Sperre auf diesem
-- Datensatz gibt. Falls dies der Fall ist, wird 
-- Fehlermeldung "ORA-00054: Versuch, mit NOWAIT eine 
-- bereits belegte Ressource anzufordern" ausgegeben.
-- Nun weiß S2, dass sie momentan nicht in der Lage
-- ist, diesen Datensatz zu verändern. 

-- S1 
--commit;

-- S2
-- Blockierung wird aufgehoben, Sperre wird gesetzt
-- FOR UPDATE: 
-- The Select For Update statement allows you to lock 
-- the records in the cursor result set. You are not 
-- required to make changes to the records in order 
-- to use this statement. The record locks are released 
-- when the next commit or rollback statement is issued.

-- S1
--update test set b = 2000 where a = 2;
--select * from test;
-- Änderung sofort in S1 sichtar

-- S2
select * from partner_test;
-- Änderung nicht sichtbar

-- S1
--commit;

-- S2
select * from partner_test;
-- Änderung sichtbar; non-repeatable read!
-- kein konsistentes Lesen; konsistentes Lesen
-- kann z.B. durch set transaction read only
-- erreicht werden.

-- S2
commit;
SET TRANSACTION READ ONLY;
-- READ ONLY garantiert, dass die Ergebnis-Daten mehrerer
-- Selects innerhalb einer Transaktion bezüglich des Transaktions-
-- beginnzeitpunktes konsistent sind (Repeatable Reads).
-- Keine DML-Statements in READ ONLY-Transaktion erlaubt.
-- Sollte der Effekt ausbleiben, Session neu starten.
select * from partner_test;

-- S1
--update test set b = 1000 where a = 1;
--select * from test;
--commit;

-- S2
select * from partner_test;
-- konsistentes Lesen gewährleistet --> b=10


-- S2
commit; -- Start neue Transaktion

-- Serialisierbare Schedules (in Oracle als Isolation Snapshot
-- bezeichnet) gewährleisten
-- S1
--commit;
--ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;
-- Mit ALTER SESSION werden alle Transaktionen der
-- Session mit SERIALIZABLE ausgeführt!
-- Mit SET TRANSACTION ISOLATION LEVEL SERIALIZABLE wird
-- die Isolationsstufe nur für die nachfolgende Transaktion
-- gesetzt.
--select * from test;

-- S2
update partner_test set b = 10000 where a = 1;

-- S1
--update test set b = 100000 where a = 1;
-- DB wartet

-- S2
commit;
-- Datensatz wurde von S2 gesperrt und geändert
-- Transaktion bricht ab und liefert folgenden Fehler
-- "ORA-08177: Zugriff für diese Transaktion kann nicht 
-- serialisiert werden"
-- D.h. es werden nur serialisierbare Schedules zugelassen!


---- CLEANUP (oder weiter mit Skript Explizites_Sperren_DataDictionary) -----------
-- S1
--DROP TABLE test;
-- S2
DROP SYNONYM partner_test;

