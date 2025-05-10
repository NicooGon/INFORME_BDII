USE elecciones;

CREATE TABLE credencial (
	serie VARCHAR (10),
    numero MEDIUMINT UNSIGNED,
    PRIMARY KEY (serie, numero),
    validez BOOLEAN
);

SELECT * FROM credencial;

drop table credencial;

