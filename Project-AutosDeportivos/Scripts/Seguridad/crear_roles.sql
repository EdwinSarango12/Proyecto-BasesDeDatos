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