CREATE DATABASE IF NOT EXISTS elecciones;
USE elecciones;

CREATE TABLE departamento(
	departamento_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL 
);

CREATE TABLE ciudad(
	ciudad_id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(255) NOT NULL,
    departamento_id INT,
    CONSTRAINT fk_ciudad_departamento FOREIGN KEY (departamento_id) REFERENCES departamento(departamento_id)
);

CREATE TABLE zona(
	zona_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    esRural BOOLEAN NOT NULL,
    ciudad_id INT,
	CONSTRAINT fk_zona_ciudad FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
);

CREATE TABLE establecimiento(
	establecimiento_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    calle VARCHAR(255) NOT NULL,
    numero INT UNSIGNED,
    zona_id INT,
    CONSTRAINT fk_establecimiento_zona FOREIGN KEY (zona_id) REFERENCES zona(zona_id)
);

CREATE TABLE eleccion(
    eleccion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR (255) NOT NULL,
    habilitado BOOLEAN NULL,
    fecha DATE NOT NULL,
    tipo_eleccion ENUM('REFERENDUM', 'PLEBISITO', 'MUNICIPAL', 'BALLOTAGE', 'PRESIDENCIAL', 'INTERNA') NOT NULL
);

CREATE TABLE cargo(
	cargo_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE credencial (
	serie VARCHAR(10) NOT NULL,
    numero MEDIUMINT UNSIGNED NOT NULL,
    validez BOOLEAN NOT NULL,
    PRIMARY KEY (serie, numero)
);

CREATE TABLE ciudadano(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    nombre_completo VARCHAR(511) GENERATED ALWAYS AS (CONCAT(nombre, ' ', apellido)) VIRTUAL,
    fecha_nacimiento DATE NOT NULL,
    serie_credencial VARCHAR(10),
    numero_credencial MEDIUMINT UNSIGNED,
    CONSTRAINT fk_ciudadano_credencial FOREIGN KEY (serie_credencial, numero_credencial) REFERENCES credencial (serie, numero),
	CONSTRAINT unq_credencial UNIQUE (serie_credencial, numero_credencial)
);

CREATE TABLE partido_politico (
    partido_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    calle_sede VARCHAR(255),
    numero_sede VARCHAR (80),
    presidente_ci INT UNSIGNED,
    CONSTRAINT fk_partido_presidente FOREIGN KEY (presidente_ci) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE politico (
    cedula_identidad INT UNSIGNED PRIMARY KEY,
    partido_id INT,
	cargo_id INT,
    CONSTRAINT fk_politico_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad),
    CONSTRAINT fk_politico_partido FOREIGN KEY (partido_id) REFERENCES partido_politico(partido_id),
    CONSTRAINT fk_politico_cargo FOREIGN KEY(cargo_id) REFERENCES cargo(cargo_id)
);

CREATE TABLE presidente_mesa(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    CONSTRAINT fk_presidente_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE vocal_mesa(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
   CONSTRAINT fk_vocal_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE secretario_mesa(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    CONSTRAINT fk_secretario_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE lista(
    eleccion_id INT NOT NULL,
    departamento_id INT NOT NULL,
    numero INT UNSIGNED NOT NULL,
	PRIMARY KEY(eleccion_id, departamento_id, numero),
	CONSTRAINT fk_lista_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id),
    CONSTRAINT fk_lista_departamento FOREIGN KEY (departamento_id) REFERENCES departamento(departamento_id)
);

CREATE TABLE lista_politico (
    eleccion_id INT NOT NULL,
    numero_lista INT UNSIGNED NOT NULL,
    cedula_identidad INT UNSIGNED NOT NULL,
    departamento_id INT NOT NULL,
    PRIMARY KEY (eleccion_id, numero_lista, cedula_identidad, departamento_id),
    CONSTRAINT fk_lp_lista FOREIGN KEY (eleccion_id, departamento_id, numero_lista) REFERENCES lista(eleccion_id, departamento_id, numero),
    CONSTRAINT fk_lp_politico FOREIGN KEY (cedula_identidad) REFERENCES politico(cedula_identidad)
);

CREATE TABLE circuito (
    eleccion_id INT NOT NULL,
    numero INT UNSIGNED NOT NULL,
    habilitado BOOLEAN NULL,
    establecimiento_id INT NOT NULL,
    presidente_mesa_ci INT UNSIGNED NULL,
    vocal_mesa_ci INT UNSIGNED NULL,
    secretario_mesa_ci INT UNSIGNED NULL,
    PRIMARY KEY(eleccion_id, numero),
    CONSTRAINT fk_circuito_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id),
    CONSTRAINT fk_circuito_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES establecimiento(establecimiento_id),
    CONSTRAINT fk_circuito_presidente FOREIGN KEY (presidente_mesa_ci) REFERENCES presidente_mesa(cedula_identidad),
    CONSTRAINT fk_circuito_vocal FOREIGN KEY (vocal_mesa_ci) REFERENCES vocal_mesa(cedula_identidad),
    CONSTRAINT fk_circuito_secretario FOREIGN KEY (secretario_mesa_ci) REFERENCES secretario_mesa(cedula_identidad)
);

CREATE TABLE credencial_circuito (
    serie VARCHAR(10) NOT NULL,
    numero MEDIUMINT UNSIGNED NOT NULL,
    eleccion_id INT,
    numero_circuito INT UNSIGNED,
    participo BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (serie, numero, eleccion_id, numero_circuito),
    CONSTRAINT fk_vc_credencial FOREIGN KEY (serie, numero) REFERENCES credencial(serie, numero),
    CONSTRAINT fk_vc_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id),
    CONSTRAINT fk_vc_circuito FOREIGN KEY (eleccion_id, numero_circuito) REFERENCES circuito(eleccion_id, numero)
);

CREATE TABLE policia(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    comisaria VARCHAR(255) NOT NULL,
    establecimiento_id INT NULL,
    CONSTRAINT fk_policia_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES establecimiento(establecimiento_id),
    CONSTRAINT fk_policia_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE papeleta(
	eleccion_id INT NOT NULL,
	valor BOOLEAN NOT NULL,
    color ENUM("AMARILLO", "CELESTE", "ROSADO") NOT NULL,
    PRIMARY KEY(eleccion_id, valor),
    CONSTRAINT fk_papeleta_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id)
);

CREATE TABLE voto(
	eleccion_id INT NOT NULL,
    numero INT UNSIGNED NOT NULL,
	voto_id INT NOT NULL,
    numero_lista INT UNSIGNED,
    valor BOOLEAN,
    cedula_identidad INT UNSIGNED NOT NULL,
    departamento_id INT NOT NULL,
    PRIMARY KEY (eleccion_id, numero, voto_id),
    CONSTRAINT fk_voto_circuito FOREIGN KEY (eleccion_id, numero) REFERENCES circuito(eleccion_id, numero),
    CONSTRAINT fk_voto_lista FOREIGN KEY (eleccion_id, departamento_id, numero_lista) REFERENCES lista(eleccion_id, departamento_id, numero),
    CONSTRAINT fk_voto_papeleta FOREIGN KEY (eleccion_id, valor) REFERENCES papeleta(eleccion_id, valor),
    CONSTRAINT fk_voto_lista_politico FOREIGN KEY (eleccion_id, numero_lista, cedula_identidad, departamento_id) REFERENCES lista_politico(eleccion_id, numero_lista, cedula_identidad, departamento_id)
);

INSERT INTO departamento (nombre) VALUES
('Montevideo'),
('Canelones'),
('Maldonado');

INSERT INTO ciudad (nombre, departamento_id) VALUES
('Montevideo', 1),
('Las Piedras', 2),
('Punta del Este', 3);

INSERT INTO zona (nombre, esRural, ciudad_id) VALUES
('Centro', FALSE, 1),
('Barrio Sur', FALSE, 1),
('Zona Rural Este', TRUE, 2);

INSERT INTO establecimiento (nombre, calle, numero, zona_id) VALUES
('Escuela Nº 1', '18 de Julio', 1234, 1),
('Escuela Nº 2', 'Av. Italia', 5678, 2),
('Escuela Rural', 'Camino Vecinal', 0, 3);

INSERT INTO eleccion (nombre, habilitado, fecha, tipo_eleccion) VALUES
('Elección Presidencial 2014', FALSE, '2014-10-26', 'PRESIDENCIAL'),
('Elección Presidencial 2019', FALSE, '2019-10-27', 'PRESIDENCIAL'),
('Elección Presidencial 2025', TRUE,  '2024-10-27', 'PRESIDENCIAL');

INSERT INTO cargo (nombre) VALUES
('Diputado'),
('Senador'),
('Intendente');

INSERT INTO credencial (serie, numero, validez) VALUES
('A', 10001, TRUE),
('1', 12345, TRUE),
('C3', 3001, FALSE);

INSERT INTO ciudadano (cedula_identidad, nombre, apellido, fecha_nacimiento, serie_credencial, numero_credencial) VALUES
(12345678, 'Marta', 'Perez', '1990-05-12', 'A', 10001),
(56789012, 'Diego', 'Gonzalez', '1990-05-20', '1', 12345),
(34567890, 'Luis', 'Rodríguez', '1975-12-05', NULL, NULL),
(23456789, 'Ana', 'Fernández', '1985-07-14', NULL, NULL);

INSERT INTO partido_politico (nombre, calle_sede, numero_sede, presidente_ci) VALUES
('Partido Verde', 'Av. Libertad', '1000', 12345678),
('Partido Azul', 'Calle Falsa', '123', 23456789),
('Partido Rojo', 'Calle Real', '321', 34567890);

INSERT INTO politico (cedula_identidad, partido_id, cargo_id) VALUES
(12345678, 1, 3),
(23456789, 2, 1),
(34567890, 3, 2);

INSERT INTO presidente_mesa (cedula_identidad) VALUES
(12345678),
(23456789),
(34567890);

INSERT INTO vocal_mesa (cedula_identidad) VALUES
(34567890),
(12345678),
(23456789);

INSERT INTO secretario_mesa (cedula_identidad) VALUES
(34567890),
(12345678),
(23456789);

INSERT INTO lista (eleccion_id, departamento_id, numero) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 1, 1);

INSERT INTO lista_politico (eleccion_id, numero_lista, cedula_identidad, departamento_id) VALUES
(1, 1, 12345678, 1),
(1, 2, 23456789, 2),
(2, 1, 34567890, 1);

INSERT INTO circuito (eleccion_id, numero, habilitado, establecimiento_id, presidente_mesa_ci, vocal_mesa_ci, secretario_mesa_ci) VALUES
(1, 101, TRUE, 1, 12345678, 34567890, 34567890),
(2, 102, FALSE, 2, 23456789, 12345678, 34567890),
(3, 103, TRUE, 3, 34567890, 23456789, 12345678);

INSERT INTO credencial_circuito (serie, numero, eleccion_id, numero_circuito, participo) VALUES
('A', 10001, 1, 101, TRUE),
('1', 12345, 2, 102, FALSE),
('C3', 3001, 3, 103, TRUE);

INSERT INTO policia (cedula_identidad, comisaria, establecimiento_id) VALUES
(12345678, 'Comisaría 1', 1),
(23456789, 'Comisaría 2', 2),
(34567890, 'Comisaría 3', 3);

INSERT INTO papeleta (eleccion_id, valor, color) VALUES
(1, TRUE, 'AMARILLO'),
(1, FALSE, 'CELESTE'),
(2, TRUE, 'ROSADO');

INSERT INTO voto (eleccion_id, numero, voto_id, numero_lista, valor, cedula_identidad, departamento_id) VALUES
(1, 101, 1, 1, FALSE, 12345678, 1),
(1, 101, 2, 2, FALSE, 23456789, 2),
(2, 102, 1, 1, TRUE, 34567890, 1);