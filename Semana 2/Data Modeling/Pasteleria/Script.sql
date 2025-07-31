 CREATE DATABASE pasteleria;
 
 USE pasteleria;
 
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo_producto ENUM('Torta', 'Cupcake', 'Galleta', 'Otro') NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    fecha_entrega DATE NOT NULL,
    sabor VARCHAR(50) NOT NULL,
    tamaño ENUM('Pequeño', 'Mediano', 'Grande') NOT NULL,
    cantidad INT NOT NULL,
    estado_pedido ENUM('Pendiente', 'En preparación', 'Entregado', 'Cancelado') NOT NULL,
    metodo_pago ENUM('Efectivo', 'Tarjeta crédito', 'Tarjeta débito', 'Transferencia') NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
