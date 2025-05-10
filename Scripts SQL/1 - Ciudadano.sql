CREATE DATABASE IF NOT EXISTS elecciones;
USE elecciones;

CREATE TABLE ciudadano(
	cedula_identindad INTEGER UNSIGNED PRIMARY KEY,
    nombre VARCHAR (255),
    apellido VARCHAR (255),
    nombre_completo VARCHAR(511) GENERATED ALWAYS AS (CONCAT(nombre, ' ', apellido)) VIRTUAL,
    fecha_nacimiento DATE,
    serie_credencial VARCHAR(3),
    numero_credencial MEDIUMINT UNSIGNED,
    CONSTRAINT fk_credencial FOREIGN KEY (serie_credencial, numero_credencial)
    REFERENCES credencial (serie, numero),
	CONSTRAINT unq_credencial UNIQUE (serie_credencial, numero_credencial)
);

SELECT nombre, apellido,
  YEAR(CURDATE()) - YEAR(fecha_nacimiento) - 
  (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(fecha_nacimiento, '%m%d')) AS edad
FROM ciudadano;

SELECT * FROM ciudadano;
