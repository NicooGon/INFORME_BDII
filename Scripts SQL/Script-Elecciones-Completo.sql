CREATE DATABASE IF NOT EXISTS elecciones;
USE elecciones;
drop database elecciones;

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
    numero INT UNSIGNED
);

CREATE TABLE eleccion(
	eleccion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR (255) NOT NULL,
	fecha DATE NOT NULL
);

CREATE TABLE eleccion_presidencial(
	eleccion_id INT PRIMARY KEY,
	CONSTRAINT fk_presidencial_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id) 
);

CREATE TABLE eleccion_referendum(
	eleccion_id INT PRIMARY KEY,
	CONSTRAINT fk_referendum_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id) 
);

CREATE TABLE eleccion_plebisito(
	eleccion_id INT PRIMARY KEY,
	CONSTRAINT fk_plebisito_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id) 
);

CREATE TABLE eleccion_municipal(
	eleccion_id INT PRIMARY KEY,
	CONSTRAINT fk_municipal_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id) 
);

CREATE TABLE eleccion_ballotage(
	eleccion_id INT PRIMARY KEY,
	CONSTRAINT fk_ballotage_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id) 
);

CREATE TABLE eleccion_interna(
	eleccion_id INT PRIMARY KEY,
	CONSTRAINT fk_interna_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id) 
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
    vicepresidente_ci INT UNSIGNED,
    CONSTRAINT fk_partido_presidente FOREIGN KEY (presidente_ci) REFERENCES ciudadano(cedula_identidad),
    CONSTRAINT fk_partido_vicepresidente FOREIGN KEY (vicepresidente_ci) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE ciudadano_eleccion(
	cedula_identidad INT UNSIGNED,
    eleccion_id INT,
    PRIMARY KEY (cedula_identidad, eleccion_id),
    CONSTRAINT fk_ciudadano_eleccion_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad),
    CONSTRAINT fk_ciudadano_eleccion_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id)
);

CREATE TABLE politico (
    cedula_identidad INT UNSIGNED PRIMARY KEY,
    partido_id INT,
	cargo_id INT,
    CONSTRAINT fk_politico_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad),
    CONSTRAINT fk_politico_partido FOREIGN KEY (partido_id) REFERENCES partido_politico(partido_id),
    CONSTRAINT fk_politico_cargo FOREIGN KEY(cargo_id) REFERENCES cargo(cargo_id)
);

CREATE TABLE miembro_mesa(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    CONSTRAINT fk_miembro_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE presidente_mesa(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    CONSTRAINT fk_presidente_miembro FOREIGN KEY (cedula_identidad) REFERENCES miembro_mesa(cedula_identidad)
);

CREATE TABLE vocal_mesa(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    CONSTRAINT fk_vocal_miembro FOREIGN KEY (cedula_identidad) REFERENCES miembro_mesa(cedula_identidad)
);

CREATE TABLE secretario_mesa(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    CONSTRAINT fk_secretario_miembro FOREIGN KEY (cedula_identidad) REFERENCES miembro_mesa(cedula_identidad)
);

CREATE TABLE presidente_ciudadano(
	presidente_ci INT UNSIGNED,
    ciudadano_ci INT UNSIGNED,
    PRIMARY KEY (presidente_ci, ciudadano_ci),
	CONSTRAINT fk_presidente_ciudadano_presidente FOREIGN KEY (presidente_ci) REFERENCES presidente_mesa(cedula_identidad),
    CONSTRAINT fk_presidente_ciudadano_ciudadano FOREIGN KEY (ciudadano_ci) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE circuito (
    circuito_id INT PRIMARY KEY AUTO_INCREMENT,
    numero INT UNSIGNED NOT NULL,
    zona_id INT,
    eleccion_id INT,
    establecimiento_id INT,
    presidente_mesa_ci INT UNSIGNED,
    vocal_mesa_ci INT UNSIGNED,
    secretario_mesa_ci INT UNSIGNED,
    CONSTRAINT fk_circuito_zona FOREIGN KEY (zona_id) REFERENCES zona(zona_id),
    CONSTRAINT fk_circuito_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id),
    CONSTRAINT fk_circuito_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES establecimiento(establecimiento_id),
    CONSTRAINT fk_circuito_presidente FOREIGN KEY (presidente_mesa_ci) REFERENCES presidente_mesa(cedula_identidad),
    CONSTRAINT fk_circuito_vocal FOREIGN KEY (vocal_mesa_ci) REFERENCES vocal_mesa(cedula_identidad),
    CONSTRAINT fk_circuito_secretario FOREIGN KEY (secretario_mesa_ci) REFERENCES secretario_mesa(cedula_identidad)
);

CREATE TABLE policia(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    comisaria VARCHAR(255) NOT NULL,
    establecimiento_id INT NOT NULL,
    CONSTRAINT fk_policia_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES establecimiento(establecimiento_id),
    CONSTRAINT fk_policia_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE lista(
    eleccion_id INT NOT NULL,
    numero INT UNSIGNED NOT NULL,
	PRIMARY KEY(eleccion_id, numero),
	CONSTRAINT fk_lista_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id)
);

CREATE TABLE papeleta(
	eleccion_id INT NOT NULL,
	valor BOOLEAN NOT NULL,
    color VARCHAR(60) NOT NULL,
    PRIMARY KEY(eleccion_id, valor),
    CONSTRAINT fk_papeleta_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id)
);

CREATE TABLE voto(
	voto_id INT NOT NULL,
    eleccion_id INT NOT NULL,
    numero_lista INT UNSIGNED NOT NULL,
    valor BOOLEAN NOT NULL,
    PRIMARY KEY (eleccion_id, voto_id),
    CONSTRAINT fk_voto_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id),
    CONSTRAINT fk_voto_lista FOREIGN KEY (eleccion_id, numero_lista) REFERENCES lista(eleccion_id, numero),
    CONSTRAINT fk_voto_papeleta FOREIGN KEY (eleccion_id, valor) REFERENCES papeleta(eleccion_id, valor)
);
