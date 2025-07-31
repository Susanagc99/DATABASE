CREATE DATABASE tienda_videojuegos;

USE tienda_videojuegos;

CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20)
);

CREATE TABLE Videojuego (
    videojuego_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    plataforma ENUM('PlayStation', 'Xbox', 'Nintendo', 'PC', 'Otro') NOT NULL,
    genero VARCHAR(50),
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE Venta (
    venta_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    videojuego_id INT NOT NULL, 
    cantidad INT NOT NULL,
    fecha_venta DATETIME NOT NULL,
    medio_pago ENUM('Efectivo', 'Tarjeta crédito', 'Tarjeta débito') NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (videojuego_id) REFERENCES Videojuego(videojuego_id)
);
