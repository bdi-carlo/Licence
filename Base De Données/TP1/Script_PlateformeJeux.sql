DROP TABLE IF EXISTS ville;
DROP TABLE IF EXISTS save;
DROP TABLE IF EXISTS partie;
DROP TABLE IF EXISTS jeu;
DROP TABLE IF EXISTS avatar;
DROP TABLE IF EXISTS race;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS objet;
DROP TABLE IF EXISTS visiteur;


-- CREATION DES TABLES
CREATE TABLE visiteur (
	id_visiteur serial PRIMARY KEY,
	login varchar(10) NOT NULL,
	mdp varchar(10) NOT NULL,
	mail varchar(50) CHECK(mail LIKE '%@%'),
	ville varchar(50)
);

CREATE TABLE objet (
	id_objet serial PRIMARY KEY,
	nom_objet varchar(40) NOT NULL,
	prix integer,
	puissance integer
);

CREATE TABLE stock (
	id_objet bigint REFERENCES objet,
	id_visiteur bigint REFERENCES visiteur,
	nb_achat integer,
	nb_dispo integer,
	PRIMARY KEY (id_objet, id_visiteur)
);

CREATE TABLE race(
	id_race serial PRIMARY KEY,
	nom_race varchar(20) NOT NULL,
	txt_race text NOT NULL	
);

CREATE TABLE avatar (
	id_avatar serial PRIMARY KEY,
	nom_avatar varchar(20) NOT NULL,
	sexe char(1),
	xp integer,
	code_dsc integer,
	id_visiteur bigint REFERENCES visiteur,
	id_race bigint REFERENCES race
);

CREATE TABLE jeu (
	id_jeu serial PRIMARY KEY,
	nom_jeu varchar(20) NOT NULL,
	type varchar(20) CHECK( type IN('role','plateau','tower defense','MMORPG','Autre')),
	nb_joueur integer
);

CREATE TABLE partie (
	id_avatar bigint REFERENCES avatar,
  id_jeu bigint REFERENCES jeu,
	role varchar(20),
  highscore integer,
  PRIMARY KEY (id_avatar, id_jeu)
);

CREATE TABLE save (
	id_avatar bigint REFERENCES avatar,
  id_jeu bigint REFERENCES jeu,
	date_s date,
  nb_pv integer,
  fichier varchar(50) UNIQUE NOT NULL,
  PRIMARY KEY (id_avatar, id_jeu, date_s)
);

CREATE TABLE ville (
	id_ville serial PRIMARY KEY,
  nom_ville varchar(50),
	code_postal integer
);

---- Emplacement de la création de table JEU

---- Emplacement de la création de table PARTIE

---- Emplacement de la création de table SAVE


INSERT INTO visiteur VALUES (DEFAULT, 'Elijah', 'toto','toto@toto.me','Dunkerque');
INSERT INTO visiteur VALUES (DEFAULT, 'Ian', 'titi');
INSERT INTO visiteur VALUES (DEFAULT, 'Sean', 'tata');
INSERT INTO visiteur VALUES (DEFAULT, 'Billy', 'tutu','tutu@tutu.me','Grenoble');
INSERT INTO visiteur VALUES (DEFAULT, 'Dominic', 'tyty','tyty@tyty.me','Annecy');
INSERT INTO visiteur VALUES (DEFAULT, 'Viggo', 'tete','tete@tete.me','Foix');

INSERT INTO objet VALUES (DEFAULT, 'Amulette en ivoire',520,40);
INSERT INTO objet VALUES (DEFAULT, 'Bille de force',680,70);
INSERT INTO objet VALUES (DEFAULT, 'Bouclier de nécrophage',990,140);
INSERT INTO objet VALUES (DEFAULT, 'Chaine tourbillonnante',543,70);
INSERT INTO objet VALUES (DEFAULT, 'Crane des ténèbres',264,30);
INSERT INTO objet VALUES (DEFAULT, 'Cristal de sécurité',377,40);
INSERT INTO objet VALUES (DEFAULT, 'Dague de défiance',590,80);
INSERT INTO objet VALUES (DEFAULT, 'Elixir de déplacement furtif',521,90);
INSERT INTO objet VALUES (DEFAULT, 'Filet aquatique',343,30);
INSERT INTO objet VALUES (DEFAULT, 'Gant de venin',678,100);
INSERT INTO objet VALUES (DEFAULT, 'Sceptre de maitrise des dragons',802,150);

INSERT INTO stock VALUES (1,1,2,1);
INSERT INTO stock VALUES (7,1,1,0);
INSERT INTO stock VALUES (6,1,1,0);
INSERT INTO stock VALUES (9,1,3,2);
INSERT INTO stock VALUES (3,1,4,3);
INSERT INTO stock VALUES (4,1,10,8);
INSERT INTO stock VALUES (2,2,3,1);
INSERT INTO stock VALUES (5,2,2,0);
INSERT INTO stock VALUES (6,2,1,1);
INSERT INTO stock VALUES (8,2,1,1);
INSERT INTO stock VALUES (2,3,2,1);
INSERT INTO stock VALUES (9,3,1,0);
INSERT INTO stock VALUES (9,4,3,1);
INSERT INTO stock VALUES (11,4,2,1);
INSERT INTO stock VALUES (8,5,1,1);
INSERT INTO stock VALUES (7,5,4,1);
INSERT INTO stock VALUES (6,5,3,2);
INSERT INTO stock VALUES (5,5,2,0);
INSERT INTO stock VALUES (4,5,1,1);
INSERT INTO stock VALUES (3,5,1,0);

INSERT INTO race VALUES (DEFAULT, 'Homme', ' Les humains sont les Seconds Enfants d Ilúvatar, les "Suivants" (quenya Hildor). Contrairement aux elfes, leur durée de vie n est pas liée à Arda (dans un langage plus courant, on peut les considérer comme mortels).');
INSERT INTO race VALUES (DEFAULT, 'Elfe', 'Les elfes (Quendi, « ceux qui parlent », en quenya) sont des êtres sages et immortels (vieillesse et maladies n ont aucun effet sur eux). Seule une souffrance trop grande ou un rejet de la vie, ainsi qu une mort physique, peut les tuer. Lorsqu un elfe meurt, son esprit se rend dans les cavernes de Mandos. Ce sont les premiers-nés, conçus par Ilúvatar seul.');
INSERT INTO race VALUES (DEFAULT, 'Nain', 'Ils ne mesurent pas plus d 1,50 mètre. Ils portent de longues barbes. Ils sont spécialisés dans l exploitation des mines : ils ont construit les mines de la Moria ou Khazad-dûm et plus largement sur une grande partie de la Terre du milieu. Ils sont de piètres cavaliers mais il sont très endurants. Ils parlent le Khuzdul.');
INSERT INTO race VALUES (DEFAULT, 'Ainur', 'Les Ainur (en quenya, « les saints », au singulier Ainu) sont présents dans Le Silmarillion et les Contes et légendes inachevés. Ils créèrent le monde avec Ilúvatar à travers la Musique des Ainur. Après la création d Arda, une partie des Ainur y descendit pour la guider et réguler sa croissance.');
INSERT INTO race VALUES (DEFAULT, 'Valar', 'Les Valar (nom quenya) sont présents dans Le Silmarillion. Les Valar (« puissances ») sont les quatorze plus puissants Ainur (esprits angéliques) qui soient descendus sur Arda, la Terre, pour y faire naître ce qui a été entrevu dans l Ainulindalë. Parmi eux, les huit plus puissants se nomment les « Aratar » (en quenya, « les exaltés »); ils étaient Neuf avant le bannissement de Melkor, divinité maléfique, dont le but est de détruire et défigurer Arda. Parmi les quatorze, on compte sept esprits masculins et sept féminins (appelés Valier).');
INSERT INTO race VALUES (DEFAULT, 'Maiar', 'Les Maiar (nom quenya, au singulier : Maia) sont présents dans Le Silmarilion et les Contes et légendes inachevés. Les Maiar font partie des Ainur, les divinités issues de l esprit d Ilúvatar, le père des dieux. Ce sont cependant des esprits de second rang, servant les esprits supérieurs, les Valar. Ils sont beaucoup plus nombreux que ces derniers, mais seule une petite partie d entre eux est nommée. Parmi les serviteurs de Melkor, le dieu maléfique, figurent Sauron et les Balrogs.');
INSERT INTO race VALUES (DEFAULT, 'Hobbit', 'Les Hobbits sont des créatures de petite taille, de 0,60 à 1,20 m et vivent dans des terriers confortables pour les plus riches, des trous pour les plus pauvres, ou des habitations de surface depuis leur installation dans la Comté. Ce sont des bons vivants, amateurs d herbe à pipe, de bière et de bonne chère. Ils sont accueillants mais se dissimulent souvent aux étrangers. Ils vivent dans la Terre du milieu et plus précisément dans la Comté, et dans une moindre mesure à Bree. Sauf exception, ils n aiment pas voyager.');
INSERT INTO race VALUES (DEFAULT, 'Orques','Un orque est une créature inspirée du gobelin des légendes germaniques. C est à l origine une espèce humanoïde aux moeurs brutales. Le nom « orque » vient du sindarin « orch » (pluriel : yrch).'); 
INSERT INTO race VALUES (DEFAULT, 'Troll', 'Les trolls furent créés par Melkor au premier Âge du monde, mais leur origine n est pas connue. Sylvebarbe indique qu ils ont été créés à partir d ents qui auraient été corrompus à l instar des orcs qui seraient des elfes torturés et corrompus.');
INSERT INTO race VALUES (DEFAULT, 'Balrog','Les balrogs (sindarin pour Démon de Puissance, analogue du quenya valarauko (pl. valaraukar)), sont des créatures fantastiques. Aux origines du monde, ils faisaient partie des Maiar. Ils furent corrompus par Melkor et prirent l apparence de formes ténébreuses et horribles. Ils se présentent comme des démons enveloppés de feu et d obscurité, munis de fouets de feu.'); 

INSERT INTO avatar VALUES (DEFAULT, 'Hector', 'M',170,345,1,1);
INSERT INTO avatar VALUES (DEFAULT, 'Timothy', 'M',135,126,2,2);
INSERT INTO avatar VALUES (DEFAULT, 'Matthis', 'M',90,336,3,3);
INSERT INTO avatar VALUES (DEFAULT, 'Baptiste', 'M',80,456,4,4);
INSERT INTO avatar VALUES (DEFAULT, 'David', 'M',102,333,4,5);
INSERT INTO avatar VALUES (DEFAULT, 'Yannick', 'M',145,234,5,6);
INSERT INTO avatar VALUES (DEFAULT, 'Luc', 'M',130,145,6,7);
INSERT INTO avatar VALUES (DEFAULT, 'Antoine', 'M',85,321,1,8);
INSERT INTO avatar VALUES (DEFAULT, 'Wajdi', 'M',140,234,1,9);
INSERT INTO avatar VALUES (DEFAULT, 'Yann', 'M',82,344,2,10);
INSERT INTO avatar VALUES (DEFAULT, 'Eliass', 'M',90,145,3,1);
INSERT INTO avatar VALUES (DEFAULT, 'Mohammed', 'M',100,321,3,2);
INSERT INTO avatar VALUES (DEFAULT, 'Youssef', 'M',150,321,4,3);
INSERT INTO avatar VALUES (DEFAULT, 'Ayas', 'M',150,345,4,4);
INSERT INTO avatar VALUES (DEFAULT, 'Merieme', 'F',110,431,5,5);
INSERT INTO avatar VALUES (DEFAULT, 'Stevy', 'M',152,241,6,6);
INSERT INTO avatar VALUES (DEFAULT, 'Victorien', 'M',135,241,1,7);
INSERT INTO avatar VALUES (DEFAULT, 'Houssam', 'M',145,214,1,8);
INSERT INTO avatar VALUES (DEFAULT, 'Pierre', 'M',120,234,2,9);
INSERT INTO avatar VALUES (DEFAULT, 'Etienne', 'M',85,432,3,10);
INSERT INTO avatar VALUES (DEFAULT, 'Marius', 'M',127,132,4,2);
INSERT INTO avatar VALUES (DEFAULT, 'Choukri', 'F',135,342,4,3);
INSERT INTO avatar VALUES (DEFAULT, 'Ahmed', 'M',100,121,5,4);
INSERT INTO avatar VALUES (DEFAULT, 'Joris', 'M',130,345,6,5);

INSERT INTO jeu VALUES (DEFAULT,'Forge of Empire','role');
INSERT INTO jeu VALUES (DEFAULT,'Solitaire','plateau');
INSERT INTO jeu VALUES (DEFAULT,'Plants vs Zombies','tower defense');
INSERT INTO jeu VALUES (DEFAULT,'Drakensang Online','MMORPG');
INSERT INTO jeu VALUES (DEFAULT,'Cooking Fever','Autre');
INSERT INTO jeu VALUES (DEFAULT,'Kingdom Rush','tower defense');
INSERT INTO jeu VALUES (DEFAULT,'League of Angels','role');
INSERT INTO jeu VALUES (DEFAULT,'Mahjong','plateau');


INSERT INTO partie VALUES (1, 2, 'gentil', 345);
INSERT INTO partie VALUES (2, 7, 'méchant', 234);
INSERT INTO partie VALUES (3, 6, 'gentil', 543);
INSERT INTO partie VALUES (4, 3, 'méchant', 987);
INSERT INTO partie VALUES (4, 2, 'gentil', 554);
INSERT INTO partie VALUES (23, 1, 'méchant', 290);
INSERT INTO partie VALUES (12, 4, 'gentil', 541);
INSERT INTO partie VALUES (17, 5, 'méchant', 509);
INSERT INTO partie VALUES (9, 3, 'gentil', 80);
INSERT INTO partie VALUES (15, 7, 'méchant', 589);
INSERT INTO partie VALUES (3, 3, 'gentil', 430);
INSERT INTO partie VALUES (4, 8, 'méchant', 734);
INSERT INTO partie VALUES (14, 2, 'gentil', 127);
INSERT INTO partie VALUES (6, 2, 'méchant', 343);
INSERT INTO partie VALUES (7, 6, 'gentil', 13);
INSERT INTO partie VALUES (19, 8, 'méchant', 84);
INSERT INTO partie VALUES (8, 4, 'gentil', 885);
INSERT INTO partie VALUES (10, 5, 'méchant', 413);
INSERT INTO partie VALUES (2, 6, 'gentil', 283);
INSERT INTO partie VALUES (7, 1, 'méchant', 145);
INSERT INTO partie VALUES (12, 2, 'gentil', 587);
INSERT INTO partie VALUES (14, 3, 'méchant', 175);
INSERT INTO partie VALUES (21, 3, 'gentil', 497);
INSERT INTO partie VALUES (21, 4, 'méchant', 383);
INSERT INTO partie VALUES (8, 5, 'gentil', 566);
INSERT INTO partie VALUES (24, 7, 'méchant', 786);
INSERT INTO partie VALUES (8, 1, 'méchant', 12);
INSERT INTO partie VALUES (1, 1, 'gentil', 76);
INSERT INTO partie VALUES (7, 4, 'méchant', 55);
INSERT INTO partie VALUES (6, 5, 'gentil', 496);
INSERT INTO partie VALUES (16, 5, 'méchant', 448);
INSERT INTO partie VALUES (2, 2, 'gentil', 883);


INSERT INTO save VALUES (1, 2, '01/02/16', 45, '/Save/Part001_02_010216.txt');
INSERT INTO save VALUES (2, 7, '01/02/16', 34, '/Save/Part002_07_010216.txt');
INSERT INTO save VALUES (3, 6, '24/01/16', 43, '/Save/Part003_06_240116.txt');
INSERT INTO save VALUES (4, 3, '12/01/16', 87, '/Save/Part004_03_120116.txt');
INSERT INTO save VALUES (4, 2, '18/01/16', 54, '/Save/Part004_02_180116.txt');
INSERT INTO save VALUES (23, 1, '19/02/16', 90, '/Save/Part023_01_190216.txt');
INSERT INTO save VALUES (12, 4, '18/02/16', 41, '/Save/Part012_04_180216.txt');
INSERT INTO save VALUES (17, 5, '15/01/16', 19, '/Save/Part017_05_150116.txt');
INSERT INTO save VALUES (9, 3, '19/02/16', 28, '/Save/Part009_03_190216.txt');
INSERT INTO save VALUES (15, 7, '08/01/16', 89, '/Save/Part015_07_080116.txt');


INSERT INTO ville VALUES(DEFAULT,'Aix en Provence',13100);
INSERT INTO ville VALUES(DEFAULT,'Brette les Pins',72250);
INSERT INTO ville VALUES(DEFAULT,'Foix',09000);
INSERT INTO ville VALUES(DEFAULT,'Dunkerque',59640);
INSERT INTO ville VALUES(DEFAULT,'Grenoble',38000);
INSERT INTO ville VALUES(DEFAULT,'Annecy',74000);
