
CREATE TABLE Usuario (
    usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE Artista (
    artista_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100)
);

CREATE TABLE Cancion (
    cancion_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    duracion TIME NOT NULL,
    artista_id INT NOT NULL,
    FOREIGN KEY (artista_id) REFERENCES Artista(artista_id)
);

CREATE TABLE Escucha (
    escucha_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    cancion_id INT NOT NULL,
    fecha_escucha DATETIME NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id),
    FOREIGN KEY (cancion_id) REFERENCES Cancion(cancion_id)
);

CREATE TABLE Lista (
    lista_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    usuario_id INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

CREATE TABLE Lista_Cancion (
    lista_id INT NOT NULL,
    cancion_id INT NOT NULL,
    fecha_agregado DATETIME,
    PRIMARY KEY (lista_id, cancion_id),
    FOREIGN KEY (lista_id) REFERENCES Lista(lista_id),
    FOREIGN KEY (cancion_id) REFERENCES Cancion(cancion_id)
);
