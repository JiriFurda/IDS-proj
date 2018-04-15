/**
 * @brief IDS projekt 2
 * @author Jiri Furda (xfurda00), Peter Havan (xhavan00)
*/

----- Entity -----

CREATE TABLE pojistovny
(
	pojistovna_cislo	NUMBER(3) NOT NULL PRIMARY KEY,
	pojistovna_jmeno	VARCHAR2(255) NOT NULL
);

CREATE TABLE dodavatele
(
	dodavatel_id	NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	dodavatel_nazev	VARCHAR2(255) NOT NULL
);

CREATE TABLE leky
(
	lek_id					NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	lek_nazev				VARCHAR2(255) NOT NULL,
	lek_nutnost_predpisu	NUMBER(1) NOT NULL,
	lek_cena				NUMBER(5) NOT NULL
);

CREATE TABLE pobocky
(
	pobocka_id		NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	pobocka_jmeno	VARCHAR2(255) NOT NULL,
	pobocka_adresa	VARCHAR2(255) NOT NULL
);

CREATE TABLE rezervace
(
	rezervace_id				NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	rezervace_jmeno_zakaznika	VARCHAR2(255) NOT NULL,
	rezervace_datum				DATE NOT NULL,
	rezervace_mnozstvi			NUMBER(3) NOT NULL,
	lek_id						NUMBER NOT NULL,
	pobocka_id					NUMBER NOT NULL,
	CONSTRAINT rezervace_fk_lek
		FOREIGN KEY (lek_id)
		REFERENCES leky(lek_id),
	CONSTRAINT rezervace_fk_pobocka
		FOREIGN KEY (pobocka_id)
		REFERENCES pobocky(pobocka_id)
);

CREATE TABLE prodeje
(
	prodej_id			NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	prodej_datum		DATE NOT NULL,
	prodej_mnozstvi		NUMBER(5) NOT NULL,
	prodej_rodne_cislo	NUMBER(10),
	lek_id				NUMBER NOT NULL,
	pobocka_id			NUMBER NOT NULL,
	CONSTRAINT prodeje_fk_lek
		FOREIGN KEY (lek_id)
		REFERENCES leky(lek_id),
	CONSTRAINT prodeje_fk_pobocka
		FOREIGN KEY (pobocka_id)
		REFERENCES pobocky(pobocka_id)
		
);



----- Entitni vztahy -----

CREATE TABLE hrazeni
(
	pojistovna_cislo	NUMBER(3) NOT NULL,
	lek_id				NUMBER NOT NULL,
	hrazeni_castka		NUMBER(5),
	CONSTRAINT hrazeni_fk_pojistovna
		FOREIGN KEY (pojistovna_cislo)
		REFERENCES pojistovny(pojistovna_cislo),
	CONSTRAINT hrazeni_fk_lek
		FOREIGN KEY (lek_id)
		REFERENCES leky(lek_id)
);

CREATE TABLE dodavani
(
	dodavatel_id	NUMBER NOT NULL,
	lek_id			NUMBER NOT NULL,
	dodavani_cena	NUMBER(5) NOT NULL,
	CONSTRAINT dodavani_fk_dodavatel
		FOREIGN KEY (dodavatel_id)
		REFERENCES dodavatele(dodavatel_id),
	CONSTRAINT dodavani_fk_lek
		FOREIGN KEY (lek_id)
		REFERENCES leky(lek_id)
);

CREATE TABLE uskladneni
(
	lek_id				NUMBER NOT NULL,
	pobocka_id			NUMBER NOT NULL,
	uskladneni_mnozstvi	NUMBER(6),
	CONSTRAINT uskladneni_fk_lek
		FOREIGN KEY (lek_id)
		REFERENCES leky(lek_id),
	CONSTRAINT uskladneni_fk_pobocka
		FOREIGN KEY (pobocka_id)
		REFERENCES pobocky(pobocka_id)
);



----- Data ----
INSERT INTO pojistovny(pojistovna_cislo, pojistovna_jmeno)
VALUES (554, 'Union');

INSERT INTO pojistovny(pojistovna_cislo, pojistovna_jmeno)
VALUES (499, 'CSOB');

INSERT INTO pojistovny(pojistovna_cislo, pojistovna_jmeno)
VALUES (888, 'VZP');

INSERT INTO dodavatele(dodavatel_nazev)
VALUES ('Bayer');

INSERT INTO dodavatele(dodavatel_nazev)
VALUES ('GlaxoSmithKline');

INSERT INTO dodavatele(dodavatel_nazev)
VALUES ('Lundbeck');

INSERT INTO leky(lek_nazev, lek_nutnost_predpisu, lek_cena)
VALUES ('PARADIM', 0, 49);

INSERT INTO leky(lek_nazev, lek_nutnost_predpisu, lek_cena)
VALUES ('PABAL', 0, 88);

INSERT INTO leky(lek_nazev, lek_nutnost_predpisu, lek_cena)
VALUES ('IALUGEN PLUES', 1, 22);

INSERT INTO pobocky(pobocka_jmeno, pobocka_adresa)
VALUES ('The pharmacy market', 'Gorkeho 22, 602 00 Brno-stred, Cesko');

INSERT INTO pobocky(pobocka_jmeno, pobocka_adresa)
VALUES ('Pharmacy Aesculap', 'Dornych 404/4, 602 00 Brno, Cesko');

INSERT INTO rezervace(rezervace_jmeno_zakaznika, rezervace_datum, rezervace_mnozstvi, lek_id, pobocka_id)
VALUES
('Peter Havan', date '2018-04-01', 1, (SELECT lek_id from leky WHERE lek_nazev='PABAL'), (SELECT pobocka_id from pobocky Where pobocka_jmeno='Pharmacy Aesculap'));

INSERT INTO prodeje(prodej_datum, prodej_mnozstvi, prodej_rodne_cislo, lek_id, pobocka_id)
VALUES(date '2018-04-01', 2, 9707054830, (SELECT lek_id from leky WHERE lek_nazev='IALUGEN PLUES'),  (SELECT pobocka_id from pobocky Where pobocka_jmeno='Pharmacy Aesculap'));

INSERT INTO prodeje(prodej_datum, prodej_mnozstvi, lek_id, pobocka_id)
VALUES(date '2018-04-02', 1, (SELECT lek_id from leky WHERE lek_nazev='PABAL'),  (SELECT pobocka_id from pobocky Where pobocka_jmeno='Pharmacy Aesculap'));

INSERT INTO hrazeni(pojistovna_cislo, lek_id, hrazeni_castka)
VALUES((SELECT pojistovna_cislo from pojistovny WHERE pojistovna_jmeno='Union'), (SELECT lek_id from leky WHERE lek_nazev='PABAL'), 22);

INSERT INTO dodavani(dodavatel_id, lek_id, dodavani_cena)
VALUES((SELECT dodavatel_id from dodavatele WHERE dodavatel_nazev='Bayer'), (SELECT lek_id from leky WHERE lek_nazev='PABAL'), 5);

INSERT INTO uskladneni(lek_id, pobocka_id, uskladneni_mnozstvi)
VALUES((SELECT lek_id from leky WHERE lek_nazev='PABAL'), (SELECT pobocka_id from pobocky Where pobocka_jmeno='Pharmacy Aesculap'), 15);

INSERT INTO uskladneni(lek_id, pobocka_id, uskladneni_mnozstvi)
VALUES((SELECT lek_id from leky WHERE lek_nazev='PARADIM'), (SELECT pobocka_id from pobocky Where pobocka_jmeno='Pharmacy Aesculap'), 15);



/*
===== For resetting database =====
DROP TABLE pojistovny;
DROP TABLE dodavatele;
DROP TABLE leky;
DROP TABLE pobocky;
DROP TABLE rezervace;
DROP TABLE prodeje;
DROP TABLE hrazeni;
DROP TABLE dodavani;
DROP TABLE uskladneni;
*/

