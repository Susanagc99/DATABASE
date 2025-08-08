CREATE DATABASE gestion_academica_universidad;
USE gestion_academica_universidad;

CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    genero ENUM('M', 'F', 'Otro') NOT NULL,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    carrera VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    fecha_ingreso DATE NOT NULL
);

CREATE TABLE docentes (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_institucional VARCHAR(100) NOT NULL UNIQUE,
    departamento_academico VARCHAR(100) NOT NULL,
    anios_experiencia INT NOT NULL CHECK (anios_experiencia >= 3)
);

CREATE TABLE cursos (
	id_curso INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    creditos INT NOT NULL CHECK (creditos > 0),
    semestre INT NOT NULL CHECK (semestre BETWEEN 1 AND 10),
    id_docente INT NOT NULL,
    FOREIGN KEY (id_docente) 
		REFERENCES docentes(id_docente)
);

CREATE TABLE inscripciones (
	id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    calificacion_final DECIMAL(2,1) CHECK (calificacion_final BETWEEN 0 AND 5),
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

INSERT INTO estudiantes (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso) VALUES
('Melissa Gutiérrez', 'meli.guti@gmail.com', 'F', '1004567890', 'Contaduria', '1994-07-22', '2013-01-15'),
('Carlos Torres', 'carlos.torres@hotmail.com', 'M', '1001234567', 'Medicina', '1997-09-10', '2015-07-10'),
('Sara Gomez', 'Saritagc@hotmail.com', 'F', '1009876543', 'Psicología', '2002-02-25', '2020-01-20'),
('Mateo Beltran', 'mateo.beltran@gmail.com', 'M', '1003456789', 'Música', '1999-12-12', '2017-08-01'),
('Alejandra Mejía', 'aleja.mejia@gmail.com', 'F', '1001112223', 'Medicina', '1999-11-03', '2018-07-15');

SELECT * FROM estudiantes;

INSERT INTO docentes (nombre_completo, correo_institucional, departamento_academico, anios_experiencia) VALUES
('Victoria Paz', 'victoria.paz@univ.edu', 'Artes', 10),
('Juan Herrera', 'juan.herrera@universidad.edu.co', 'Ciencias de la Salud', 12),
('Camila Salazar', 'camila.salazar@universidad.edu.co', 'Ciencias Sociales', 4),
('Andrés Rojas', 'andres.rojas@universidad.edu.co', 'Economía y Finanzas', 15);

SELECT * FROM docentes;

INSERT INTO cursos (nombre, codigo, creditos, semestre, id_docente) VALUES
('Historia del Arte', 'ART101', 3, 1, 1), -- 1   
('Anatomía Humana', 'MED201', 4, 2, 2), -- 2         
('Psicología del Desarrollo', 'PSI301', 3, 3, 3), -- 3   
('Contabilidad I', 'CON101', 3, 1, 4); -- 4

INSERT INTO cursos (nombre, codigo, creditos, semestre, id_docente) VALUES 
('Ética Profesional', 'CON202', 2, 2, 4), -- 5   
('Fisiología Humana', 'MED301', 4, 3, 2), -- 6   
('Teoría Musical Avanzada', 'MUS202', 3, 2, 1); -- 7          

SELECT * FROM cursos;

INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion, calificacion_final) VALUES
(1, 4, '2013-02-10', 4.3), -- melissa contabilidad I
(2, 2, '2015-08-15', 4.7), -- carlos a anato
(3, 3, '2020-02-01', 4.5), -- sara piscologia desa
(4, 1, '2017-08-10', 4.8), -- mateo a historia del arte
(5, 2, '2018-08-01', 4.2), -- aleja a anatomia
(4, 7, '2018-03-10', 4.9), -- mateo teoria muscial
(2, 6, '2016-01-15', 4.6), -- carlos a fisiologia
(5, 6, '2019-02-03', 4.4), -- aleja a fisio
(1, 5, '2013-08-20', 4.8); -- meli a etica profesional

SELECT * FROM inscripciones;


SELECT * FROM cursos;
DELETE FROM cursos WHERE id_curso >= 5; -- los tres últimos cursos que agregué tenian el id 12, 13 y 14 entonces borré los cursos que tenian un id mayor a 5
ALTER TABLE cursos AUTO_INCREMENT = 5;  -- para poder reiniciar el contador desde 5 y volver a ejecutar el alter table de los 3 nuevos cursos


-- CONSULTAS

-- 1.
-- Obtener el listado de todos los estudiantes junto con sus inscripciones y cursos (JOIN):
SELECT * FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON c.id_curso = i.id_curso;

-- (misma consulta pero personalizada)
SELECT
e.nombre_completo,
e.identificacion,
e.carrera,
e.fecha_ingreso,
c.nombre AS curso_inscrito,
c.codigo AS codigo_curso,
i.fecha_inscripcion,
i.calificacion_final
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON c.id_curso = i.id_curso;


-- 2.
-- Listar los cursos dictados por docentes con más de 5 años de experiencia:
SELECT c.*, d.nombre_completo AS docente, d.anios_experiencia
FROM cursos c
JOIN docentes d ON d.id_docente = c.id_docente
WHERE anios_experiencia > 5;


-- 3.
-- Obtener el promedio de calificaciones por curso (GROUP BY + AVG):
SELECT c.nombre AS Nombre_Curso, ROUND(AVG(calificacion_final),2) AS Promedio
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.nombre;


-- 4.
-- Mostrar los estudiantes que están inscritos en más de un curso (HAVING COUNT(*) > 1):
SELECT e.nombre_completo AS Estudiante,
COUNT(i.id_curso) AS Cantidad_Cursos,
GROUP_CONCAT(c.nombre SEPARATOR ',') AS Cursos_Inscritos
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON c.id_curso = i.id_curso
GROUP BY e.id_estudiante, e.nombre_completo
HAVING COUNT(i.id_curso) > 1;


-- 5.
-- Agregar una nueva columna estado_academico a la tabla estudiantes (ALTER TABLE):
ALTER TABLE estudiantes ADD COLUMN estado_academico VARCHAR(100);

SELECT*FROM estudiantes;


-- 6.
-- Eliminar un docente y observar el efecto en la tabla cursos (uso de ON DELETE en FK):
DELETE FROM docentes WHERE id_docente = 2;
-- no funciona a no ser que se defina ON DELETE en FK con una acción específica

ALTER TABLE cursos
DROP FOREIGN KEY cursos_ibfk_1;

-- Solución: modificar que id_docente permita null para poder definir la acción de que aparezca null en el curso enlazado al docente que fue eliminado
ALTER TABLE cursos MODIFY COLUMN id_docente INT NULL;

ALTER TABLE cursos
ADD CONSTRAINT fk_docente
FOREIGN KEY (id_docente)
REFERENCES docentes(id_docente)
ON DELETE SET NULL;

SELECT * FROM cursos;


-- 7.
-- Consultar los cursos en los que se han inscrito más de 1 estudiantes (GROUP BY + COUNT + HAVING): 
SELECT c.id_curso AS ID, c.nombre AS Curso,
COUNT(i.id_estudiante) AS Estudiantes_Inscritos
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
GROUP BY c.id_curso, c.nombre
HAVING COUNT(c.id_curso) > 1;


-- SUBCONSULTAS

-- 1.
-- Obtener los estudiantes cuya calificación promedio es superior al promedio general (AVG() + subconsulta):
SELECT e.nombre_completo AS Estudiante, ROUND(AVG(calificacion_final),2) AS Promedio_estudiante
FROM inscripciones i
JOIN estudiantes e ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante, e.nombre_completo
HAVING AVG(calificacion_final) > (
	SELECT AVG(calificacion_final)
    FROM inscripciones
);


-- 2.
-- Mostrar los nombres de las carreras con estudiantes inscritos en cursos del semestre 2 o posterior (IN o EXISTS).
SELECT DISTINCT carrera
FROM estudiantes
WHERE id_estudiante IN (
    SELECT i.id_estudiante
    FROM inscripciones i
    JOIN cursos c ON i.id_curso = c.id_curso
    WHERE c.semestre >= 2
);


-- 3.
-- Utiliza funciones como ROUND, SUM, MAX, MIN y COUNT para explorar distintos indicadores del sistema.

SELECT 
    d.nombre_completo AS Nombre_docente,
    COUNT(DISTINCT c.id_curso) AS Cursos_dictados,                           
    SUM(c.creditos) AS Suma_creditos_impartidos,                               
    ROUND(AVG(i.calificacion_final), 2) AS Promedio_de_sus_estudiantes,    
    MAX(i.calificacion_final) AS Calificacion_maxima,                         
    MIN(i.calificacion_final) AS Calificacion_minima                           
FROM docentes d
LEFT JOIN cursos c ON d.id_docente = c.id_docente
LEFT JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY d.id_docente, d.nombre_completo;


-- VISTA
CREATE VIEW vista_historial_academico AS
SELECT 
    e.nombre_completo AS Estudiante,
    c.nombre AS Curso,
    IFNULL(d.nombre_completo, 'No asignado') AS Docente, -- si el docente es NULL (por eliminar anteriormente al docente 2) entonces se muestra ese mensaje
    c.semestre AS Semestre,
    i.calificacion_final AS Calificación
FROM inscripciones i
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
LEFT JOIN docentes d ON c.id_docente = d.id_docente;

SELECT * FROM vista_historial_academico;


-- ROLES

-- 1.
-- Asigna permisos de solo lectura a un rol llamado revisor_academico sobre la vista vista_historial_academico (GRANT SELECT):
CREATE ROLE IF NOT EXISTS revisor_academico;
GRANT SELECT ON vista_historial_academico TO revisor_academico;

-- 2.
-- Revoca los permisos de modificación de datos sobre la tabla inscripciones a este rol (REVOKE):
REVOKE INSERT, UPDATE, DELETE ON inscripciones FROM revisor_academico;

SHOW GRANTS FOR 'revisor_academico';

CREATE USER 'usuario_prueba'@'localhost' IDENTIFIED BY 'clave123';
GRANT 'revisor_academico' TO 'usuario_prueba'@'localhost';

-- Prueba de que el rol no tiene permisos para modificar, solo lectura
SELECT CURRENT_ROLE();
SET ROLE 'revisor_academico';

SELECT * FROM vista_historial_academico;
UPDATE inscripciones SET calificacion = 5 WHERE id_inscripcion = 1; -- Error Code: 1142. UPDATE command denied to user 'usuario_prueba'@'localhost' for table 'inscripciones'


-- 3.
-- Simula una operación de actualización de calificaciones usando BEGIN, SAVEPOINT, ROLLBACK y COMMIT.

-- Iniciar transacción
START TRANSACTION;

-- Actualizar una calificación
UPDATE inscripciones
SET calificacion_final = 4.0
WHERE id_estudiante = 3 AND id_curso = 3;

-- Guardar punto de control
SAVEPOINT antes_de_segundo_cambio;

-- Hacemos otro cambio
UPDATE inscripciones
SET calificacion_final = 2.5
WHERE id_estudiante = 5 AND id_curso = 6;

-- cancelamos el segundo cambio
ROLLBACK TO antes_de_segundo_cambio;

-- Confirmamos solo el primer cambio
COMMIT;










