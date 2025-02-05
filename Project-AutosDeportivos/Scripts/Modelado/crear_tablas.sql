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