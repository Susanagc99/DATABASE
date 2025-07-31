CREATE DATABASE Agencia_viajes;
USE Agencia_viajes;

CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20)
);

CREATE TABLE Paquete (
    paquete_id INT PRIMARY KEY AUTO_INCREMENT,
    precio DECIMAL(10,2) NOT NULL,
    duracion_dias INT NOT NULL
);

CREATE TABLE Reserva (
    reserva_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    paquete_id INT NOT NULL,
    medio_pago VARCHAR(50) NOT NULL,
    estado_pedido VARCHAR(50) NOT NULL,
    cantidad_personas INT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (paquete_id) REFERENCES Paquete(paquete_id)
);

CREATE TABLE Destino (
    destino_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL
);

CREATE TABLE Destinos_incluidos (
    paquete_id INT NOT NULL,
    destino_id INT NOT NULL,
    PRIMARY KEY (paquete_id, destino_id),
    FOREIGN KEY (paquete_id) REFERENCES Paquete(paquete_id),
    FOREIGN KEY (destino_id) REFERENCES Destino(destino_id)
);

CREATE TABLE Fecha_programada (
    fecha_id INT PRIMARY KEY AUTO_INCREMENT,
    paquete_id INT NOT NULL,
    fecha_salida DATE NOT NULL,
    fecha_regreso DATE NOT NULL,
    FOREIGN KEY (paquete_id) REFERENCES Paquete(paquete_id)
);

