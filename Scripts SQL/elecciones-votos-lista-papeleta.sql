CREATE TABLE ELECCION(
	eleccion_id int auto_increment primary key,
	fecha date not null
);

CREATE TABLE ELECCION_PRESIDENCIAL(
	eleccion_id int primary key,
	foreign key (eleccion_id) references eleccion(eleccion_id) 
);

CREATE TABLE ELECCION_REFERENDUM(
	eleccion_id int primary key,
	foreign key (eleccion_id) references eleccion(eleccion_id) 
);

CREATE TABLE ELECCION_PLEBISITO(
	eleccion_id int primary key,
	foreign key (eleccion_id) references eleccion(eleccion_id) 
);

CREATE TABLE ELECCION_MUNICIPAL(
	eleccion_id int primary key,
	foreign key (eleccion_id) references eleccion(eleccion_id) 
);

CREATE TABLE ELECCION_BALLOTAGE(
	eleccion_id int primary key,
	foreign key (eleccion_id) references eleccion(eleccion_id) 
);

CREATE TABLE ELECCION_INTERNAS(
	eleccion_id int primary key,
	foreign key (eleccion_id) references eleccion(eleccion_id) 
);

CREATE TABLE LISTA(
    eleccion_id int not null,
    numero int not null,
	foreign key (eleccion_id) references eleccion(eleccion_id),
	primary key(eleccion_id, numero)
);

CREATE TABLE PAPELETA(
	eleccion_id int not null,
	valor boolean not null,
    color varchar(35) not null,
    foreign key (eleccion_id) references eleccion(eleccion_id),
    primary key(eleccion_id, valor)
);

CREATE TABLE VOTO(
	voto_id int not null unique,
    eleccion_id int not null,
    numero_lista int not null,
    valor boolean not null,
    primary key (eleccion_id, voto_id),
    foreign key (eleccion_id) references eleccion(eleccion_id),
    foreign key (eleccion_id, numero_lista) references lista(eleccion_id, numero),
    foreign key (eleccion_id, valor) references papeleta(eleccion_id, valor)
);
