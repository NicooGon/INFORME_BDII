CREATE TABLE ELECCION(
	id_eleccion int auto_increment primary key,
	fecha date not null
);

CREATE TABLE ELECCION_PRESIDENCIAL(
	id_eleccion int primary key,
	foreign key (id_eleccion) references eleccion(id_eleccion) 
);

CREATE TABLE ELECCION_REFERENDUM(
	id_eleccion int primary key,
	foreign key (id_eleccion) references eleccion(id_eleccion) 
);

CREATE TABLE ELECCION_PLEBISITO(
	id_eleccion int primary key,
	foreign key (id_eleccion) references eleccion(id_eleccion) 
);

CREATE TABLE ELECCION_MUNICIPAL(
	id_eleccion int primary key,
	foreign key (id_eleccion) references eleccion(id_eleccion) 
);

CREATE TABLE ELECCION_BALLOTAGE(
	id_eleccion int primary key,
	foreign key (id_eleccion) references eleccion(id_eleccion) 
);

CREATE TABLE ELECCION_INTERNAS(
	id_eleccion int primary key,
	foreign key (id_eleccion) references eleccion(id_eleccion) 
);

CREATE TABLE LISTA(
    id_eleccion int not null,
    numero int not null,
	foreign key (id_eleccion) references eleccion(id_eleccion),
	primary key(id_eleccion, numero)
);

CREATE TABLE PAPELETA(
	id_eleccion int not null,
	valor boolean not null,
    color varchar(35) not null,
    foreign key (id_eleccion) references eleccion(id_eleccion),
    primary key(id_eleccion, valor)
);

CREATE TABLE VOTO(
	id_voto int not null unique,
    id_eleccion int not null,
    numero_lista int not null,
    valor boolean not null,
    primary key (id_eleccion, id_voto),
    foreign key (id_eleccion) references eleccion(id_eleccion),
    foreign key (id_eleccion, numero_lista) references lista(id_eleccion, numero),
    foreign key (id_eleccion, valor) references papeleta(id_eleccion, valor)
);