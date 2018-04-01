CREATE TABLE pojistovny
(
	pojistovna_cislo	NUMBER(3) NOT NULL,
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

CREATE TABLE rezervace
(
	rezervace_id				NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	rezervace_jmeno_zakaznika	VARCHAR2(255) NOT NULL,
	rezervace_datum				DATE
);

CREATE TABLE prodeje
(
	prodej_id		NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	prodej_datum	DATE,
	prodej_mnozstvi	NUMBER(5) NOT NULL
);

CREATE TABLE pobocky
(
	pobocka_id		NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	pobocka_jmeno	VARCHAR2(255) NOT NULL,
	pobocka_adresa	VARCHAR2(255) NOT NULL
);


/*
===== For resetting database =====
DROP TABLE pojistovny;
DROP TABLE dodavatele;
DROP TABLE leky;
DROP TABLE rezervace;
DROP TABLE prodeje;
DROP TABLE pobocky;
*/
