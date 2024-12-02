-- a
CREATE OR REPLACE VIEW partners AS
SELECT fa1.actor_id, fa2.actor_id AS partner_id, fa1.film_id
FROM film_actor fa1
INNER JOIN film_actor fa2
    ON fa1.film_id = fa2.film_id AND fa1.actor_id != fa2.actor_id
WHERE fa1.FILM_ID <= 13
ORDER BY fa1.actor_id;

SELECT *
FROM partners;

SELECT DISTINCT partner_id AS Vorschlag
FROM partners
WHERE level = 2
START WITH actor_id = (SELECT actor_id FROM ACTOR WHERE FIRST_NAME = 'JULIANNE' AND LAST_NAME = 'DENCH')
CONNECT BY NOCYCLE PRIOR partner_id = actor_id
       AND PRIOR film_id != film_id
ORDER BY Vorschlag;