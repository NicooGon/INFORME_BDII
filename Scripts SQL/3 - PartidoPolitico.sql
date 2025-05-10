USE elecciones;

CREATE TABLE partido_politico (
    nombre VARCHAR(255) PRIMARY KEY,
    direccion_sede VARCHAR(511),
    presidente_ci INTEGER UNSIGNED,
    vicepresidente_ci INTEGER UNSIGNED,
    
    CONSTRAINT fk_presidente FOREIGN KEY (presidente_ci) 
    REFERENCES ciudadano (cedula_identindad),
    
    CONSTRAINT fk_vicepresidente FOREIGN KEY (vicepresidente_ci) 
    REFERENCES ciudadano (cedula_identindad)
);
