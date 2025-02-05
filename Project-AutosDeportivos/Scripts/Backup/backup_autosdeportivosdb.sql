-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: autosdeportivosdb
-- ------------------------------------------------------
-- Server version	9.0.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `autosdeportivos`
--

DROP TABLE IF EXISTS `autosdeportivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autosdeportivos` (
  `id_auto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  `costo` decimal(10,2) NOT NULL,
  `id_marca` int DEFAULT NULL,
  PRIMARY KEY (`id_auto`),
  KEY `id_marca` (`id_marca`),
  CONSTRAINT `autosdeportivos_ibfk_1` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id_marca`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autosdeportivos`
--

LOCK TABLES `autosdeportivos` WRITE;
/*!40000 ALTER TABLE `autosdeportivos` DISABLE KEYS */;
/*!40000 ALTER TABLE `autosdeportivos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distribucionpais`
--

DROP TABLE IF EXISTS `distribucionpais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distribucionpais` (
  `id_distribucion` int NOT NULL AUTO_INCREMENT,
  `id_auto` int DEFAULT NULL,
  `id_pais` int DEFAULT NULL,
  `cantidad` int NOT NULL,
  PRIMARY KEY (`id_distribucion`),
  KEY `id_auto` (`id_auto`),
  KEY `id_pais` (`id_pais`),
  CONSTRAINT `distribucionpais_ibfk_1` FOREIGN KEY (`id_auto`) REFERENCES `autosdeportivos` (`id_auto`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `distribucionpais_ibfk_2` FOREIGN KEY (`id_pais`) REFERENCES `paises` (`id_pais`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distribucionpais`
--

LOCK TABLES `distribucionpais` WRITE;
/*!40000 ALTER TABLE `distribucionpais` DISABLE KEYS */;
/*!40000 ALTER TABLE `distribucionpais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `duenos`
--

DROP TABLE IF EXISTS `duenos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `duenos` (
  `id_dueno` int NOT NULL AUTO_INCREMENT,
  `nombre_dueÃ±o` varchar(100) NOT NULL,
  PRIMARY KEY (`id_dueno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `duenos`
--

LOCK TABLES `duenos` WRITE;
/*!40000 ALTER TABLE `duenos` DISABLE KEYS */;
/*!40000 ALTER TABLE `duenos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marcas`
--

DROP TABLE IF EXISTS `marcas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas` (
  `id_marca` int NOT NULL AUTO_INCREMENT,
  `nombre_marca` varchar(100) NOT NULL,
  `id_dueno` int DEFAULT NULL,
  PRIMARY KEY (`id_marca`),
  KEY `id_dueno` (`id_dueno`),
  CONSTRAINT `marcas_ibfk_1` FOREIGN KEY (`id_dueno`) REFERENCES `duenos` (`id_dueno`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas`
--

LOCK TABLES `marcas` WRITE;
/*!40000 ALTER TABLE `marcas` DISABLE KEYS */;
/*!40000 ALTER TABLE `marcas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paises`
--

DROP TABLE IF EXISTS `paises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paises` (
  `id_pais` int NOT NULL AUTO_INCREMENT,
  `nombre_pais` varchar(100) NOT NULL,
  PRIMARY KEY (`id_pais`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paises`
--

LOCK TABLES `paises` WRITE;
/*!40000 ALTER TABLE `paises` DISABLE KEYS */;
/*!40000 ALTER TABLE `paises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `contrasena` varbinary(255) NOT NULL,
  `rol` enum('Administrador','Usuario','Auditor') NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'admin','admin@admin.com',_binary 'uFq,Á|ËŽ\\=\"&¶ˆL?','Administrador','2025-01-31 01:58:52');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-30 21:18:58
