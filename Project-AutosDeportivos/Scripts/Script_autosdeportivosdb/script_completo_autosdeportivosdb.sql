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

-- ///////////////////////////////// PARTE 3 /////////////////////////////////
              -- LOS BACKUP SE ENCUENTRAN EN UNA CARPETA APARTE --

-- ///////////////////////////////// PARTE 4 /////////////////////////////////
-- Crear indices 
CREATE INDEX idx_marca ON AutosDeportivos(id_marca);
CREATE INDEX idx_pais ON DistribucionPais(id_pais);

-- El Uso de EXPLAIN
INSERT INTO Duenos (nombre_dueño)
VALUES ('Juan Pérez'), ('Carlos López');
select*from Duenos;


-- Insertar datos en la tabla Marcas
INSERT INTO Marcas (nombre_marca, id_dueno) 
VALUES ('Ferrari', 1), ('Lamborghini', 1), ('Porsche', 2);


-- Insertar datos en la tabla Paises
INSERT INTO Paises (nombre_pais) 
VALUES ('Estados Unidos'), ('Alemania'), ('Italia');

-- Insertar datos en la tabla AutosDeportivos
INSERT INTO AutosDeportivos (nombre, modelo, costo, id_marca) 
VALUES 
('Ferrari 488', '2021', 280000.00, 4),
('Lamborghini Huracan', '2022', 300000.00, 5),
('Porsche 911', '2021', 120000.00, 6);


-- Insertar datos en la tabla DistribucionPais
INSERT INTO DistribucionPais (id_auto, id_pais, cantidad) 
VALUES 
(10, 1, 100), 
(11, 2, 150), 
(12, 3, 50);


EXPLAIN SELECT AutosDeportivos.nombre, Paises.nombre_pais
FROM AutosDeportivos
JOIN DistribucionPais ON AutosDeportivos.id_auto = DistribucionPais.id_auto
JOIN Paises ON DistribucionPais.id_pais = Paises.id_pais
WHERE DistribucionPais.cantidad > 100;

SELECT 
    AutosDeportivos.nombre, 
    Marcas.nombre_marca, 
    Paises.nombre_pais
FROM 
    AutosDeportivos
JOIN 
    Marcas ON AutosDeportivos.id_marca = Marcas.id_marca
JOIN 
    DistribucionPais ON AutosDeportivos.id_auto = DistribucionPais.id_auto
JOIN 
    Paises ON DistribucionPais.id_pais = Paises.id_pais
WHERE 
    DistribucionPais.cantidad > 50;
    
-- 3. Particionamiento de tablas
CREATE TABLE Reservas (
    id_reserva INT AUTO_INCREMENT,
    id_cliente INT,
    id_auto INT,
    fecha_reserva DATE,
    PRIMARY KEY (id_reserva, fecha_reserva)  -- Incluimos fecha_reserva en la clave primaria
)
PARTITION BY RANGE (YEAR(fecha_reserva)) (
    PARTITION p0 VALUES LESS THAN (2022),
    PARTITION p1 VALUES LESS THAN (2023),
    PARTITION p2 VALUES LESS THAN (2024)
);

-- ///////////////////////////////// PARTE 5 /////////////////////////////////
-- 1.- Crear Procedimientos --
select*from autosdeportivos;
select*from distribucionpais;
select*from duenos;
select*from marcas;
select*from paises;
select*from reservas;
select*from usuarios;

-- Insertar datos en la tabla Reservas
insert into Reservas (id_cliente, id_auto, fecha_reserva) 
values 
(1, 10, '2023-05-15'),  
(2, 11, '2023-07-20'),  
(1, 12, '2023-10-10'),  
(2, 10, '2022-01-05'),  
(1, 11, '2022-03-18');  

-- EJERCICIO 1/2
Delimiter //

-- Procedimiento para calcular el precio total de la reserva
create procedure CalcularPrecioReserva(in id_reserva int)
BEGIN
    declare precio_base decimal(10,2);
    declare descuento decimal(10,2);
    declare cargo_adicional decimal(10,2);
    declare precio_final decimal(10,2);

    -- Obtener el precio base del auto
    select costo 
    into precio_base
    from AutosDeportivos
    join Reservas on AutosDeportivos.id_auto = Reservas.id_auto
    where Reservas.id_reserva = id_reserva
    limit 1; -- Esto sera para que solo muestre una fila en la consulta

    -- Aplicar descuento dependiendo del año del modelo del auto
    if exists(
        select 1
        from AutosDeportivos
        where id_auto = (select id_auto from Reservas where id_reserva = id_reserva limit 1)
        and modelo = '2021'
    ) then
        set descuento = precio_base * 0.10; 
    else
        set descuento = 0;
    end if;

    -- Aplicar cargo adicional dependiendo del país
    if exists (
        select 1
        from DistribucionPais
        where id_auto = (select id_auto from Reservas where id_reserva = id_reserva limit 1)
        and id_pais = 1
    ) then
        set cargo_adicional = precio_base * 0.05; 
    else
        set cargo_adicional = 0;
    end if;

    -- Calcular el precio final aplicando descuento y cargo adicional
    set precio_final = precio_base - descuento + cargo_adicional;

    -- Mostrar el precio final
    select 
        precio_base as 'Precio Base',
        descuento as 'Descuento',
        cargo_adicional as 'Cargo Adicional',
        precio_final as 'Precio Final';
end //

Delimiter ;

-- Calcular el precio de una reserva mediante el id_reserva
select*from Reservas;
call CalcularPrecioReserva(10);

-- EJERCICIO 2/2
-- Sera el mismo ejercicio de arriba ya que solo tenemos costos en la tabla de autos deportivos
select*from Reservas;
call CalcularPrecioReserva(11);


-- 2.- Crear vistas --
-- Vista de Autos deportivos y marcas
create view VistaAutosMarcas as
select 
    AutosDeportivos.id_auto,
    AutosDeportivos.nombre as 'Nombre del Auto',
    AutosDeportivos.modelo,
    AutosDeportivos.costo as 'Precio del Auto',
    Marcas.nombre_marca as 'Marca',
    Duenos.nombre_dueño as 'Dueño de la Marca'
from 
    AutosDeportivos
join 
    Marcas on AutosDeportivos.id_marca = Marcas.id_marca
join 
    Duenos on Marcas.id_dueno = Duenos.id_dueno;
    
    
-- Vista de distribucion de autos por pais
create view VistaDistribucionAutosPais as
select 
    AutosDeportivos.nombre as 'Nombre del Auto',
    Paises.nombre_pais as 'País',
    DistribucionPais.cantidad as 'Cantidad Distribuida'
from 
    DistribucionPais
join 
    AutosDeportivos on DistribucionPais.id_auto = AutosDeportivos.id_auto
join 
    Paises on DistribucionPais.id_pais = Paises.id_pais;
    
-- Vistas de informacion de clientes y autos
create view VistaReservasClientesAutos as
select 
    Reservas.id_reserva,
    Reservas.fecha_reserva,
    Usuarios.nombre as 'Nombre del Cliente',
    Usuarios.email as 'Correo del Cliente',
    AutosDeportivos.nombre as 'Auto Reservado',
    AutosDeportivos.modelo as 'Modelo del Auto'
from 
    Reservas
join 
    Usuarios on Reservas.id_cliente = Usuarios.id_usuario
join 
    AutosDeportivos on Reservas.id_auto = AutosDeportivos.id_auto;
    
-- Vistas de precios de reservas
create view VistaPreciosReservas as
select 
    Reservas.id_reserva,
    AutosDeportivos.nombre as 'Auto Reservado',
    AutosDeportivos.modelo as 'Modelo del Auto',
    Reservas.fecha_reserva,
    (AutosDeportivos.costo - 
        (case 
            when AutosDeportivos.modelo = '2021' then AutosDeportivos.costo * 0.10
            else 0
        end) + 
        (case 
            when DistribucionPais.id_pais = 1 then AutosDeportivos.costo * 0.05
            else 0
        end)) as 'Precio Final'
from 
    Reservas
join 
    AutosDeportivos on Reservas.id_auto = AutosDeportivos.id_auto
join 
    DistribucionPais on AutosDeportivos.id_auto = DistribucionPais.id_auto;
    
-- Autos disponibles para reserva
create view VistaAutosDisponibles as
select 
    AutosDeportivos.id_auto,
    AutosDeportivos.nombre as 'Nombre del Auto',
    AutosDeportivos.modelo,
    AutosDeportivos.costo as 'Precio',
    Paises.nombre_pais as 'País'
from 
    AutosDeportivos
join 
    DistribucionPais on AutosDeportivos.id_auto = DistribucionPais.id_auto
join 
    Paises on DistribucionPais.id_pais = Paises.id_pais
where 
    DistribucionPais.cantidad > 0;
    
-- Vista de Autos y Precios Finales con Descuento y Cargo Adicional
create view VistaPreciosFinales as
select 
    AutosDeportivos.nombre as 'Nombre del Auto',
    AutosDeportivos.modelo,
    AutosDeportivos.costo as 'Precio Base',
    (case 
        when AutosDeportivos.modelo = '2021' then AutosDeportivos.costo * 0.10
        else 0
    end) as 'Descuento',
    (case 
        when DistribucionPais.id_pais = 1 then AutosDeportivos.costo * 0.05
        else 0
    end) as 'Cargo Adicional',
    (AutosDeportivos.costo - 
        (case 
            when AutosDeportivos.modelo = '2021' then AutosDeportivos.costo * 0.10
            else 0
        end) + 
        (case 
            when DistribucionPais.id_pais = 1 then AutosDeportivos.costo * 0.05
            else 0
        end)) as 'Precio Final'
from 
    AutosDeportivos
join 
    DistribucionPais on AutosDeportivos.id_auto = DistribucionPais.id_auto;
    
-- Ver las vistas creadas
select*from VistaAutosMarcas;
select*from VistaDistribucionAutosPais;
select*from VistaReservasClientesAutos;
select*from VistaPreciosReservas;
select*from VistaAutosDisponibles;
select*from VistaPreciosFinales;


-- 3.- Crear Triggers y control de cambios

-- En esta tabla se guardaran los cambios 
create table HistorialCambios (
    id_cambio INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    tipo_cambio ENUM('UPDATE', 'DELETE'),
    id_registro INT,
    detalles TEXT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- trigger para registrar cambios en Reservas  1/2
DELIMITER //

CREATE TRIGGER before_update_reservas
BEFORE UPDATE ON Reservas
FOR EACH ROW
BEGIN
    INSERT INTO HistorialCambios (tabla_afectada, tipo_cambio, id_registro, detalles)
    VALUES ('Reservas', 'UPDATE', OLD.id_reserva, 
        CONCAT('Reserva cambiada: ID ', OLD.id_reserva, 
               ', Cliente: ', OLD.id_cliente, 
               ', Auto: ', OLD.id_auto, 
               ', Fecha Anterior: ', OLD.fecha_reserva, 
               ' -> Nueva Fecha: ', NEW.fecha_reserva));
END //

DELIMITER ;


-- trigger para registrar eliminaciones en autosdeportivos  2/2
DELIMITER //

CREATE TRIGGER before_delete_autosdeportivos
BEFORE DELETE ON autosdeportivos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialCambios (tabla_afectada, tipo_cambio, id_registro, detalles)
    VALUES ('autosdeportivos', 'DELETE', OLD.id_auto, 
        CONCAT('Auto eliminado: ID ', OLD.id_auto, 
               ', Marca: ', OLD.id_marca, 
               ', Modelo: ', OLD.modelo));
END //

DELIMITER ;

-- actualizar una reserva
update Reservas set fecha_reserva = '2019-07-22' where id_reserva = 10; -- aqui cambiamos la fecha y/o la id_reserva para modifica

-- eliminar un auto
delete from autosdeportivos where id_auto = 7; -- aqui cambiamos solo la id_auto para eliminar
select*from autosdeportivos;

-- ver loos cambios
select*from HistorialCambios;

-- Ver solo los cambios relacionados con las eliminaciones en autosdeportivos
select*from HistorialCambios where tabla_afectada = 'autosdeportivos' and tipo_cambio = 'DELETE';
-- Ver solo los cambios relacionados con las actualizaciones en reservas
select*from HistorialCambios where tabla_afectada = 'Reservas' and tipo_cambio = 'UPDATE';
