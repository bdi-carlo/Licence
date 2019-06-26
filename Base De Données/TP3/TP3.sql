--Personne (id_pers, nom_pers, prenom_pers)
--Client (id_client, nom_client, prenom_client, adresse, caution)
--Genre (id_genre, nom_genre, type_public)
--Magasin (id_magasin, nom_magasin, adresse)
--Film (id_film, titre, duree, #id_pers, #id_genre)
--Acteur (#id_pers, #id_film)
--Dvd (id_dvd, etat, date_mes, #id_film, #id_magasin)
--Emprunt (#id_dvd, date_deb, date_retour, #id_client)

-- CREATION TABLES

\i ~/BaseDeDonnees/TP3/Script_VideoClub.txt

-- MODIFICATION SEARCH PATH

--1
CREATE SCHEMA videoclub;
SET search_path TO "videoclub","u_l3info009","$user";
DROP SCHEMA public;

-- COMMANDES DDL

--2
ALTER TABLE client ADD statut varchar(6) CHECK (statut IN ('ok','banni','sursis')) DEFAULT 'ok';

--3
ALTER TABLE emprunt DROP CONSTRAINT emprunt_id_dvd_fkey;
ALTER TABLE emprunt ADD CONSTRAINT emprunt_id_dvd_fkey FOREIGN KEY (id_dvd) REFERENCES dvd(id_dvd) ON DELETE CASCADE ON UPDATE CASCADE;

-- COMANDES SQL

--4
SELECT COUNT(*) FROM Film WHERE id_pers IN (select id_pers from acteur where id_film IN (select id_film from film where id_genre IN (select id_genre from genre where nom_genre='Drame')));

--5
CREATE VIEW view1 AS select id_dvd,titre,nom_pers AS nom_realisateur,nom_genre,id_magasin from film natural join dvd natural join personne natural join genre natural join magasin;

SELECT * FROM view1;

--6
CREATE FUNCTION nb_emprunt( title varchar(100) ) RETURNS bigint AS $$
	SELECT COUNT(*) FROM emprunt WHERE id_dvd IN (select id_dvd from dvd where id_film IN (select id_film from film where film.titre=title));
$$LANGUAGE SQL;

SELECT nb_emprunt('Star Wars IV');

--7
SELECT id_film,count(*) FROM emprunt NATURAL JOIN dvd GROUP BY id_film HAVING count(*) >= all(select count(*) from emprunt natural join dvd group by id_film);
--SELECT titre,count(*) FROM (SELECT id_film,count(*) FROM emprunt NATURAL JOIN dvd GROUP BY id_film HAVING count(*) >= all(select count(*) from emprunt natural join dvd group by id_film)) as R1 natural join film;
-- COMMANDES PL/PSQL

--8
CREATE FUNCTION nb_emprunt_max( id integer ) RETURNS bigint AS $$
DECLARE
	nb_max bigint;
BEGIN
	nb_max=(SELECT caution from client WHERE id_client=id)/10;

	RETURN nb_max;
END;
$$LANGUAGE plpgsql;

SELECT nb_emprunt_max(1);

--9
CREATE FUNCTION liste_film( genre varchar(60), magasin integer ) RETURNS setof record AS $$
BEGIN
	RETURN query(SELECT titre FROM view1 WHERE id_magasin=magasin AND nom_genre=genre);
END;
$$LANGUAGE plpgsql;

SELECT * FROM liste_film('Science Fiction',1) AS t(titre varchar(100));

--10
CREATE OR REPLACE FUNCTION maj_statut() RETURNS void AS $$
DECLARE
	nb_emprunt integer;
	nb_retard integer;
	id integer;
BEGIN
	FOR id IN (SELECT id_client FROM client) LOOP

		SELECT COUNT(*) INTO nb_emprunt FROM emprunt WHERE id_client=id AND date_fin IS NULL;
		SELECT COUNT(*) INTO nb_retard FROM emprunt WHERE id_client=id AND date_fin IS NULL AND (date_deb + interval '3 days') < current_date;

		IF nb_emprunt > (select nb_emprunt_max(id)) OR nb_retard > 0 THEN
			UPDATE client SET statut='sursis' WHERE id_client=id;
		ELSE
			UPDATE client SET statut='ok' WHERE id_client=id;
		END IF;

	END LOOP;
END;
$$LANGUAGE plpgsql;

SELECT maj_statut();

--11
