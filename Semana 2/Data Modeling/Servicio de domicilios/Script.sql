CREATE DATABASE Servicio_domicilios;

USE Servicio_domicilios;

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

CREATE TABLE Repartidor (
    id_repartidor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    vehiculo VARCHAR(50)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_repartidor INT,
    medio_pago VARCHAR(50) NOT NULL,
    estado_pedido ENUM('pendiente', 'entregado', 'cancelado') NOT NULL,
    descripcion TEXT,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_repartidor) REFERENCES Repartidor(id_repartidor)
);
