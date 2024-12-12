----------- PIPELINED TABLE FUNCTIONS -----------
-- 'Table Functions' k�nnen wie eine Tabelle im FROM-Teil einer Abfrage angef�hrt werden.
-- Dadurch k�nnen komplexe Abfragen in eine PL/SQL-Funktion gepackt und mit Parametern versehen werden.
-- Die so erstellten Abfragen k�nnen oft in gleicher Weise durch eine VIEW abgebildet werden, 
-- unter Umst�nden allerdings mit einem deutlich komplexeren Query. Die Performance muss je nach
-- Einsatz ermittelt bzw. verglichen werden.
-- Normale 'Table Functions' bef�llen zuerst eine Collection und geben diese erst nach Abschluss
-- der Funktion im FROM-Teil der Abfrage zur�ck. Das Schl�sselwort PIPELINED erm�glich allerdings
-- eine laufende R�ckgabe in den FROM-Teil (�hnlich Streaming), das erh�ht die Performance,
-- da bereits Zeilen zur�ckgegeben werden, auch wenn die Funktion selbst noch l�uft. Dadurch eignen
-- sich diese Funktionen auch zum Einsatz in einem ETL-Job zum Beladen von DataWarehouses.


-- Zuerst m�ssen wir den Typ und die Collection erstellen, die von der Function und vom SELECT genutzt werden k�nnen.
DROP TYPE film_length_tab;
DROP TYPE film_length_row;

CREATE TYPE film_length_row AS OBJECT (
  film_id      NUMBER,
  title        VARCHAR2(100),
  length       NUMBER,
  info         VARCHAR2(50)
);
/

CREATE TYPE film_length_tab IS TABLE OF film_length_row;
/

DROP FUNCTION get_min_max_film; 

-- sucht die k�rzesten und l�ngsten Filme zu einer Kategorie und gibt diese mit einer Zusatzinformation aus.
CREATE OR REPLACE FUNCTION get_min_max_film (p_category IN VARCHAR2) 
RETURN film_length_tab PIPELINED AS
    min_length NUMBER := 0;
    max_length NUMBER := 9999999;
    info       VARCHAR2(60) := NULL;
    
    CURSOR film_cursor (min_l NUMBER, max_l NUMBER) IS
        SELECT film_id, title, length
        FROM film
            INNER JOIN film_category USING (film_id)
            INNER JOIN category USING (category_id)
        WHERE length IN (min_l, max_l)
          AND category.name = p_category;
BEGIN
    SELECT MIN(length), MAX(length) INTO min_length, max_length
    FROM film
        INNER JOIN film_category USING (film_id)
        INNER JOIN category USING (category_id)
    WHERE category.name = p_category;
    
    FOR film_rec IN film_cursor(min_length, max_length) LOOP
        IF film_rec.length = min_length THEN
            info := 'k�rzester';
        ELSE
            info := 'l�ngster';
        END IF;
        info := info || ' Film in der Kategorie ' || p_category;
        -- hier erfolgt die laufende �bergabe an das aufrufende Query
        PIPE ROW(film_length_row(film_rec.film_id, film_rec.title, film_rec.length, info));
    END LOOP;
    
  RETURN;       -- RETURN ist leer, da nichts mehr zur�ckgegeben wird
END;
/

-- Abfrage mit Parameter
SELECT *
FROM TABLE(get_min_max_film('Children'));       -- ab Oracle 12.2 braucht man das Schl�sselwort TABLE nicht mehr

-- wird die Funktion vor R�ckgabe aller Eintr�ge abgebrochen (zB durch ein WHERE), so f�llt innerhalb der 
-- Funktion eine NO_DATA_NEEDED Exception; diese braucht nicht behandelt zu werden, im Gegenteil
-- enth�lt die Funktion ein Exception-Handling (zB mit "OTHERS") k�nnte das zu unerw�nschten Nebeneffekten f�hren.
-- In so einem Fall soll f�r NO_DATA_NEEDED eine eigene Catch-Clause verwendet werden und diese weitergeworfen (RAISE) werden.
SELECT *
FROM TABLE(get_min_max_film('Children'))
WHERE ROWNUM < 2;


-- Bereinigung
DROP FUNCTION get_min_max_film; 
DROP TYPE film_length_tab;
DROP TYPE film_length_row;

-- weiterf�hrende Infos und noch mehr Beispiele sh. https://oracle-base.com/articles/misc/pipelined-table-functions
