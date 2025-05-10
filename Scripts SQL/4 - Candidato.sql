USE elecciones;
CREATE TABLE candidato (
    cedula_identindad INTEGER UNSIGNED PRIMARY KEY,
    partido VARCHAR(255),
    
    CONSTRAINT fk_candidato_ciudadano FOREIGN KEY (cedula_identindad)
	REFERENCES ciudadano(cedula_identindad)
);

