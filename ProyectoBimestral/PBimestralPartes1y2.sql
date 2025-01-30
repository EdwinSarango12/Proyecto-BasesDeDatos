-- //////////////////////////////// PARTE 1 /////////////////////////////////////////
-- Crear la base de datos
CREATE DATABASE AutosDeportivosDB;
USE AutosDeportivosDB;

-- Tabla de Dueños
CREATE TABLE Duenos (
    id_dueno INT AUTO_INCREMENT PRIMARY KEY,
    nombre_dueño VARCHAR(100) NOT NULL
);

-- Tabla de Marcas
CREATE TABLE Marcas (
    id_marca INT AUTO_INCREMENT PRIMARY KEY,
    nombre_marca VARCHAR(100) NOT NULL,
    id_dueno INT,
    FOREIGN KEY (id_dueno) REFERENCES Duenos(id_dueno) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabla de Autos Deportivos
CREATE TABLE AutosDeportivos (
    id_auto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    id_marca INT,
    FOREIGN KEY (id_marca) REFERENCES Marcas(id_marca) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabla de Países
CREATE TABLE Paises (
    id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL
);

-- Tabla de Distribución por País
CREATE TABLE DistribucionPais (
    id_distribucion INT AUTO_INCREMENT PRIMARY KEY,
    id_auto INT,
    id_pais INT,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_auto) REFERENCES AutosDeportivos(id_auto) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES Paises(id_pais) ON DELETE CASCADE ON UPDATE CASCADE
);
-- ///////////////////////////////// PARTE 2 //////////////////////////////////////
-- Crear usuarios
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin123';
CREATE USER 'usuario'@'localhost' IDENTIFIED BY 'Usuario123';
CREATE USER 'auditor'@'localhost' IDENTIFIED BY 'Auditor123';

-- Crear rol de Administrador
CREATE ROLE 'Administrador';
GRANT ALL PRIVILEGES ON AutosDeportivosDB.* TO 'Administrador';

-- Crear rol de Usuario (solo consulta)
CREATE ROLE 'Usuario';
GRANT SELECT ON AutosDeportivosDB.AutosDeportivos TO 'Usuario';
GRANT SELECT ON AutosDeportivosDB.Paises TO 'Usuario';

-- Crear rol de Auditor (solo lectura y acceso a logs)
CREATE ROLE 'Auditor';
GRANT SELECT ON AutosDeportivosDB.* TO 'Auditor';

-- Asignar roles a usuarios
GRANT 'Administrador' TO 'admin'@'localhost';
GRANT 'Usuario' TO 'usuario'@'localhost';
GRANT 'Auditor' TO 'auditor'@'localhost';

-- Verificar roles y privilegios asignados
SHOW GRANTS FOR 'admin'@'localhost';
SHOW GRANTS FOR 'usuario'@'localhost';
SHOW GRANTS FOR 'auditor'@'localhost';

-- Asignar roles y privilegios a Usuario
GRANT USAGE ON *.* TO 'usuario'@'localhost';
GRANT 'Usuario' TO 'usuario'@'localhost';
CREATE ROLE 'Usuario';

-- Otorgar privilegios al rol 'Usuario'
GRANT SELECT ON AutosDeportivosDB.AutosDeportivos TO 'Usuario';
GRANT SELECT ON AutosDeportivosDB.Paises TO 'Usuario';
-- Creación de usuarios
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARBINARY(255) NOT NULL,  -- Almacenará la contraseña cifrada
    rol ENUM('Administrador', 'Usuario', 'Auditor') NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cifrado de datos
INSERT INTO Usuarios (nombre, email, contrasena)
VALUES ('admin', 'admin@admin.com', AES_ENCRYPT('123', '123123'));

-- Activación de log general y errores de SQL
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'TABLE';



