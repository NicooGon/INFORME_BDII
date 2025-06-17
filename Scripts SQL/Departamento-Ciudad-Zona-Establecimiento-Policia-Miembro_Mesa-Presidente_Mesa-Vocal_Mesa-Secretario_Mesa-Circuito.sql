CREATE DATABASE elecciones;
USE elecciones;
drop database elecciones;

CREATE TABLE Departamento(
	id_Departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (80) NOT NULL
);

CREATE TABLE Ciudad(
	id_Ciudad INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (80) NOT NULL,
    id_Departamento INT NOT NULL,
    FOREIGN KEY (id_Departamento) REFERENCES Departamento(id_Departamento)
);

CREATE TABLE Zona(
	id_Zona INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (80),
    esRural BOOLEAN NOT NULL,
    id_Ciudad INT NOT NULL,
    FOREIGN KEY (id_Ciudad) REFERENCES Ciudad(id_Ciudad)
);
    
CREATE TABLE Establecimiento(
	id_Establecimiento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (80) NOT NULL,
    calle VARCHAR (60) NOT NULL,
    numero INT UNSIGNED
);

CREATE TABLE Policia(
	CI INT UNSIGNED PRIMARY KEY,
    id_Establecimiento INT NOT NULL,
    FOREIGN KEY (id_Establecimiento) REFERENCES Establecimiento(id_Establecimiento),
    FOREIGN KEY (CI) REFERENCES Ciudadano(CI)
);

CREATE TABLE Miembro_Mesa(
	CI INT UNSIGNED PRIMARY KEY,
    FOREIGN KEY (CI) REFERENCES Ciudadano(CI)
);

CREATE TABLE Presidente_Mesa(
	CI INT UNSIGNED PRIMARY KEY,
    FOREIGN KEY (CI) REFERENCES Miembro_Mesa(CI)
);

CREATE TABLE Vocal_Mesa(
	CI INT UNSIGNED PRIMARY KEY,
    FOREIGN KEY (CI) REFERENCES Miembro_Mesa(CI)
);

CREATE TABLE Secretario_Mesa(
	CI INT UNSIGNED PRIMARY KEY,
    FOREIGN KEY (CI) REFERENCES Miembro_Mesa(CI)
);

CREATE TABLE Presidente_Ciudadano(
	CI INT UNSIGNED PRIMARY KEY,
	FOREIGN KEY (CI) REFERENCES Presidente_Mesa(CI),
    FOREIGN KEY (CI) REFERENCES Ciudadano(CI)
);

CREATE TABLE Circuito(
	id_Circuito INT PRIMARY KEY AUTO_INCREMENT,
    numero INT UNSIGNED NOT NULL,
    id_Zona INT NOT NULL,
    id_Eleccion INT NOT NULL,
    id_Establecimiento INT NOT NULL,
    CI INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_Zona) REFERENCES Zona(id_Zona),
    FOREIGN KEY (id_Eleccion) REFERENCES Eleccion(id_Eleccion),
    FOREIGN KEY (id_Establecimiento) REFERENCES Establecimiento(id_Establecimiento),
    FOREIGN KEY (CI) REFERENCES Presidente_Mesa(CI),
    FOREIGN KEY (CI) REFERENCES Vocal_Mesa(CI),
    FOREIGN KEY (CI) REFERENCES Secretario_Mesa(CI)
);



    