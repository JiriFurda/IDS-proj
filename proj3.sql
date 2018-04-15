/**
 * @brief IDS projekt 3
 * @author Jiri Furda (xfurda00), Peter Havan (xhavan00)
*/


---------- PROJEKT 2 ----------

----- Vyresetovani databaze -----
DROP TABLE pojistovny CASCADE CONSTRAINTS;
DROP TABLE dodavatele CASCADE CONSTRAINTS;
DROP TABLE leky CASCADE CONSTRAINTS;
DROP TABLE pobocky CASCADE CONSTRAINTS;
DROP TABLE rezervace CASCADE CONSTRAINTS;
DROP TABLE prodeje CASCADE CONSTRAINTS;
DROP TABLE hrazeni CASCADE CONSTRAINTS;
DROP TABLE dodavani CASCADE CONSTRAINTS;
DROP TABLE uskladneni CASCADE CONSTRAINTS;

----- Entity -----
DROP TABLE uskladneni;

DROP TABLE dodavani;

DROP TABLE hrazeni;

DROP TABLE prodeje;

DROP TABLE rezervace;

DROP TABLE pobocky;

DROP TABLE leky;

DROP TABLE dodavatele;

DROP TABLE pojistovny;

CREATE TABLE pojistovny (
    pojistovna_cislo   NUMBER(3) NOT NULL PRIMARY KEY,
    pojistovna_jmeno   VARCHAR2(50) NOT NULL
);

CREATE TABLE dodavatele (
    dodavatel_id      NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    dodavatel_nazev   VARCHAR2(50) NOT NULL
);

CREATE TABLE leky (
    lek_id                 NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    lek_nazev              VARCHAR2(50) NOT NULL,
    lek_nutnost_predpisu   NUMBER(1) NOT NULL,
    lek_cena               NUMBER(5) NOT NULL
);

CREATE TABLE pobocky (
    pobocka_id       NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    pobocka_jmeno    VARCHAR2(50) NOT NULL,
    pobocka_adresa   VARCHAR2(50) NOT NULL
);

CREATE TABLE rezervace (
    rezervace_id                NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    rezervace_jmeno_zakaznika   VARCHAR2(50) NOT NULL,
    rezervace_datum             DATE NOT NULL,
    rezervace_mnozstvi          NUMBER(3) NOT NULL,
    lek_id                      NUMBER NOT NULL,
    pobocka_id                  NUMBER NOT NULL,
    CONSTRAINT rezervace_fk_lek FOREIGN KEY ( lek_id )
        REFERENCES leky ( lek_id ),
    CONSTRAINT rezervace_fk_pobocka FOREIGN KEY ( pobocka_id )
        REFERENCES pobocky ( pobocka_id )
);

CREATE TABLE prodeje (
    prodej_id            NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    prodej_datum         DATE NOT NULL,
    prodej_mnozstvi      NUMBER(5) NOT NULL,
    prodej_rodne_cislo   NUMBER(10),
    lek_id               NUMBER NOT NULL,
    pobocka_id           NUMBER NOT NULL,
    CONSTRAINT prodeje_fk_lek FOREIGN KEY ( lek_id )
        REFERENCES leky ( lek_id ),
    CONSTRAINT prodeje_fk_pobocka FOREIGN KEY ( pobocka_id )
        REFERENCES pobocky ( pobocka_id )
);

----- Entitni vztahy -----
CREATE TABLE hrazeni (
    pojistovna_cislo   NUMBER(3) NOT NULL,
    lek_id             NUMBER NOT NULL,
    hrazeni_castka     NUMBER(5),
    CONSTRAINT hrazeni_fk_pojistovna FOREIGN KEY ( pojistovna_cislo )
        REFERENCES pojistovny ( pojistovna_cislo ),
    CONSTRAINT hrazeni_fk_lek FOREIGN KEY ( lek_id )
        REFERENCES leky ( lek_id )
);

CREATE TABLE dodavani (
    dodavatel_id    NUMBER NOT NULL,
    lek_id          NUMBER NOT NULL,
    dodavani_cena   NUMBER(5) NOT NULL,
    CONSTRAINT dodavani_fk_dodavatel FOREIGN KEY ( dodavatel_id )
        REFERENCES dodavatele ( dodavatel_id ),
    CONSTRAINT dodavani_fk_lek FOREIGN KEY ( lek_id )
        REFERENCES leky ( lek_id )
);

CREATE TABLE uskladneni (
    lek_id                NUMBER NOT NULL,
    pobocka_id            NUMBER NOT NULL,
    uskladneni_mnozstvi   NUMBER(6),
    CONSTRAINT uskladneni_fk_lek FOREIGN KEY ( lek_id )
        REFERENCES leky ( lek_id ),
    CONSTRAINT uskladneni_fk_pobocka FOREIGN KEY ( pobocka_id )
        REFERENCES pobocky ( pobocka_id )
);


----- Data ----
INSERT INTO pojistovny (
    pojistovna_cislo,
    pojistovna_jmeno
) VALUES (
    554,
    'Union'
);

INSERT INTO pojistovny (
    pojistovna_cislo,
    pojistovna_jmeno
) VALUES (
    499,
    'CSOB'
);

INSERT INTO pojistovny (
    pojistovna_cislo,
    pojistovna_jmeno
) VALUES (
    888,
    'VZP'
);

INSERT INTO dodavatele ( dodavatel_nazev ) VALUES ( 'Bayer' );

INSERT INTO dodavatele ( dodavatel_nazev ) VALUES ( 'GlaxoSmithKline' );

INSERT INTO dodavatele ( dodavatel_nazev ) VALUES ( 'Lundbeck' );

INSERT INTO leky (
    lek_nazev,
    lek_nutnost_predpisu,
    lek_cena
) VALUES (
    'PARADIM',
    0,
    49
);

INSERT INTO leky (
    lek_nazev,
    lek_nutnost_predpisu,
    lek_cena
) VALUES (
    'PABAL',
    0,
    88
);

INSERT INTO leky (
    lek_nazev,
    lek_nutnost_predpisu,
    lek_cena
) VALUES (
    'IALUGEN PLUES',
    1,
    22
);

INSERT INTO pobocky (
    pobocka_jmeno,
    pobocka_adresa
) VALUES (
    'The pharmacy market',
    'Gorkeho 22, 602 00 Brno-stred, Cesko'
);

INSERT INTO pobocky (
    pobocka_jmeno,
    pobocka_adresa
) VALUES (
    'Pharmacy Aesculap',
    'Dornych 404/4, 602 00 Brno, Cesko'
);

INSERT INTO rezervace (
    rezervace_jmeno_zakaznika,
    rezervace_datum,
    rezervace_mnozstvi,
    lek_id,
    pobocka_id
) VALUES (
    'Peter Havan',
    DATE '2018-04-01',
    4,
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'IALUGEN PLUES'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'Pharmacy Aesculap'
    )
);

INSERT INTO rezervace (
    rezervace_jmeno_zakaznika,
    rezervace_datum,
    rezervace_mnozstvi,
    lek_id,
    pobocka_id
) VALUES (
    'Jiri Furda',
    DATE '2017-03-08',
    5,
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PABAL'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'The pharmacy market'
    )
);

INSERT INTO rezervace (
    rezervace_jmeno_zakaznika,
    rezervace_datum,
    rezervace_mnozstvi,
    lek_id,
    pobocka_id
) VALUES (
    'Jiri Furda',
    DATE '2017-08-08',
    1,
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'The pharmacy market'
    )
);

INSERT INTO rezervace (
    rezervace_jmeno_zakaznika,
    rezervace_datum,
    rezervace_mnozstvi,
    lek_id,
    pobocka_id
) VALUES (
    'Jiri Furda',
    DATE '2017-08-08',
    1,
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'The pharmacy market'
    )
);

INSERT INTO prodeje (
    prodej_datum,
    prodej_mnozstvi,
    prodej_rodne_cislo,
    lek_id,
    pobocka_id
) VALUES (
    DATE '2018-04-01',
    2,
    9707054830,
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'IALUGEN PLUES'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'Pharmacy Aesculap'
    )
);

INSERT INTO prodeje (
    prodej_datum,
    prodej_mnozstvi,
    lek_id,
    pobocka_id
) VALUES (
    DATE '2018-04-02',
    1,
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PABAL'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'Pharmacy Aesculap'
    )
);

INSERT INTO hrazeni (
    pojistovna_cislo,
    lek_id,
    hrazeni_castka
) VALUES (
    (
        SELECT
            pojistovna_cislo
        FROM
            pojistovny
        WHERE
            pojistovna_jmeno = 'Union'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PABAL'
    ),
    5
);

INSERT INTO hrazeni (
    pojistovna_cislo,
    lek_id,
    hrazeni_castka
) VALUES (
    (
        SELECT
            pojistovna_cislo
        FROM
            pojistovny
        WHERE
            pojistovna_jmeno = 'Union'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    5
);

INSERT INTO hrazeni (
    pojistovna_cislo,
    lek_id,
    hrazeni_castka
) VALUES (
    (
        SELECT
            pojistovna_cislo
        FROM
            pojistovny
        WHERE
            pojistovna_jmeno = 'CSOB'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PABAL'
    ),
    3
);

INSERT INTO hrazeni (
    pojistovna_cislo,
    lek_id,
    hrazeni_castka
) VALUES (
    (
        SELECT
            pojistovna_cislo
        FROM
            pojistovny
        WHERE
            pojistovna_jmeno = 'CSOB'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    5
);

INSERT INTO dodavani (
    dodavatel_id,
    lek_id,
    dodavani_cena
) VALUES (
    (
        SELECT
            dodavatel_id
        FROM
            dodavatele
        WHERE
            dodavatel_nazev = 'Bayer'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PABAL'
    ),
    5
);

INSERT INTO dodavani (
    dodavatel_id,
    lek_id,
    dodavani_cena
) VALUES (
    (
        SELECT
            dodavatel_id
        FROM
            dodavatele
        WHERE
            dodavatel_nazev = 'Lundbeck'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PABAL'
    ),
    10
);

INSERT INTO dodavani (
    dodavatel_id,
    lek_id,
    dodavani_cena
) VALUES (
    (
        SELECT
            dodavatel_id
        FROM
            dodavatele
        WHERE
            dodavatel_nazev = 'Lundbeck'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    10
);

INSERT INTO dodavani (
    dodavatel_id,
    lek_id,
    dodavani_cena
) VALUES (
    (
        SELECT
            dodavatel_id
        FROM
            dodavatele
        WHERE
            dodavatel_nazev = 'GlaxoSmithKline'
    ),
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    5
);

INSERT INTO uskladneni (
    lek_id,
    pobocka_id,
    uskladneni_mnozstvi
) VALUES (
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PABAL'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'Pharmacy Aesculap'
    ),
    15
);

INSERT INTO uskladneni (
    lek_id,
    pobocka_id,
    uskladneni_mnozstvi
) VALUES (
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'Pharmacy Aesculap'
    ),
    15
);

INSERT INTO uskladneni (
    lek_id,
    pobocka_id,
    uskladneni_mnozstvi
) VALUES (
    (
        SELECT
            lek_id
        FROM
            leky
        WHERE
            lek_nazev = 'PARADIM'
    ),
    (
        SELECT
            pobocka_id
        FROM
            pobocky
        WHERE
            pobocka_jmeno = 'The pharmacy market'
    ),
    50
);

---------- PROJEKT 3 ----------

----- Vyhľadá lieky, ktoré majú sú uskladné na danej pobočke vo väčšom počte, než 5 -----
SELECT
	lek_nazev,
    uskladneni_mnozstvi,
    pobocka_jmeno
FROM
    leky
    NATURAL JOIN uskladneni
    NATURAL JOIN pobocky
WHERE
    uskladneni_mnozstvi > 5;

----- Vyhľadá všetky rezervácie na meno Peter Havan -----
SELECT
	lek_nazev,
    rezervace_mnozstvi,
    rezervace_datum
FROM
    leky
    NATURAL JOIN rezervace
WHERE
    rezervace_jmeno_zakaznika = 'Peter Havan';

----- Vyhleda vsechny dny kdy byl prodan lek PABAL -----
SELECT
    DISTINCT prodej_datum
FROM
    prodeje
    NATURAL JOIN leky
WHERE
    lek_nazev = 'PABAL';

----- Vyhleda vsechny zakazniky, kteri maji zarezervovany nektery lek a spocita celkovy pocet jejich rezervovanych leku -----
SELECT
	rezervace_jmeno_zakaznika,
    SUM(rezervace_mnozstvi) AS mnozstvi_rezervovanych_leku  
FROM
    rezervace
GROUP BY
    rezervace_jmeno_zakaznika;

----- Spocita prumernou castku prispevku na lek a vypise jen ty pojistovny, ktere v prumeru prispivaji 5 a vice -----    
SELECT  
    pojistovna_jmeno,
	AVG(hrazeni_castka) AS prumerne_hrazeni
FROM
    hrazeni
    NATURAL JOIN pojistovny
HAVING
    AVG(hrazeni_castka) >= 5
GROUP
    BY pojistovny.pojistovna_jmeno;
    
----- Vypise nazvy vsech leku, ktere jsou rezervovany -----
SELECT
	lek_nazev
FROM
	leky
WHERE
	EXISTS
	(
		SELECT
			rezervace_id
		FROM
			rezervace
		WHERE 
			lek_id = leky.lek_id
	);

----- Vypise vsechny pojistovny, ktere hradi lek PABAL vetsi catskou nez 3 -----
SELECT
	pojistovna_jmeno
FROM
	pojistovny
WHERE
	pojistovna_cislo
	IN
	(
		SELECT
			pojistovna_cislo
		FROM
			hrazeni
			NATURAL JOIN leky
		WHERE
			lek_nazev = 'PABAL'
			AND hrazeni_castka > 3
	);
	
