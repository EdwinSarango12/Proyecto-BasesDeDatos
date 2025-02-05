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
