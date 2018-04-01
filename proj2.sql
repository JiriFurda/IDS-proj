/* TO-DO
 * Default value for DATE
 * Unsigned number
 * hrazeni_castka NULL or NOT NULL?
 * duplicity in hrazeni, dodavani, uskladneni
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
	prodej_id		NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	prodej_datum	DATE NOT NULL,
	prodej_mnozstvi	NUMBER(5) NOT NULL,
	lek_id			NUMBER NOT NULL,
	pobocka_id		NUMBER NOT NULL,
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
	hrazeni_castka		NUMBER(5) NOT NULL,
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
	lek_id				NUMBER NOT NULL,
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
