CREATE TABLE departamento(
	departamento_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (255) NOT NULL
);

CREATE TABLE ciudad(
	ciudad_id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (255) NOT NULL,
    departamento_id INT NOT NULL,
    CONSTRAINT fk_ciudad_departamento FOREIGN KEY (departamento_id) REFERENCES departamento(departamento_id)
);

CREATE TABLE zona(
	zona_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (255),
    esRural BOOLEAN NOT NULL,
    ciudad_id INT NOT NULL,
	CONSTRAINT fk_zona_ciudad FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
);
    
CREATE TABLE establecimiento(
	establecimiento_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (255) NOT NULL,
    calle VARCHAR (255) NOT NULL,
    numero INT UNSIGNED
);

CREATE TABLE policia(
	cedula_identidad INT UNSIGNED PRIMARY KEY,
    comisaria VARCHAR (255) NOT NULL,
    establecimiento_id INT NOT NULL,
    CONSTRAINT fk_policia_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES establecimiento(establecimiento_id),
    CONSTRAINT fk_policia_ciudadano FOREIGN KEY (cedula_identidad) REFERENCES ciudadano(cedula_identidad)
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
	presidente_ci INT UNSIGNED NOT NULL,
    ciudadano_ci INT UNSIGNED NOT NULL,
    PRIMARY KEY (presidente_ci, ciudadano_ci),
	CONSTRAINT fk_presidente_ci FOREIGN KEY (presidente_ci) REFERENCES presidente_mesa(cedula_identidad),
    CONSTRAINT fk_ciudadano_ci FOREIGN KEY (ciudadano_ci) REFERENCES ciudadano(cedula_identidad)
);

CREATE TABLE circuito (
    circuito_id INT PRIMARY KEY AUTO_INCREMENT,
    numero INT UNSIGNED NOT NULL,
    zona_id INT NOT NULL,
    eleccion_id INT NOT NULL,
    establecimiento_id INT NOT NULL,
    presidente_mesa_ci INT UNSIGNED NOT NULL,
    vocal_mesa_ci INT UNSIGNED NOT NULL,
    secretario_mesa_ci INT UNSIGNED NOT NULL,
    CONSTRAINT fk_circuito_zona FOREIGN KEY (zona_id) REFERENCES zona(zona_id),
    CONSTRAINT fk_circuito_eleccion FOREIGN KEY (eleccion_id) REFERENCES eleccion(eleccion_id),
    CONSTRAINT fk_circuito_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES establecimiento(establecimiento_id),
    CONSTRAINT fk_circuito_presidente FOREIGN KEY (presidente_mesa_ci) REFERENCES presidente_mesa(cedula_identidad),
    CONSTRAINT fk_circuito_vocal FOREIGN KEY (vocal_mesa_ci) REFERENCES vocal_mesa(cedula_identidad),
    CONSTRAINT fk_circuito_secretario FOREIGN KEY (secretario_mesa_ci) REFERENCES secretario_mesa(cedula_identidad)
);



    