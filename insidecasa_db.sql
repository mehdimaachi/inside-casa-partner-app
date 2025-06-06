-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: insidecasa_db
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `image_urls` json DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `partner_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partner_id` (`partner_id`),
  KEY `category_id` (`category_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `activities_ibfk_49` FOREIGN KEY (`partner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `activities_ibfk_50` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `activities_ibfk_51` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (3,'Randonnée urbaine dans le quartier des Habous','Balade guidée à travers les ruelles du quartier des Habous, découverte de l’architecture traditionnelle et des souks.','Habous, Casablanca',33.57300000,-7.61000000,120.00,180,1,'\"[\\\"http://localhost:5000/uploads/1749061949505-caption.jpg\\\"]\"','2025-06-04 18:32:29','2025-06-04 18:32:29',2,1,NULL),(4,'Séance de surf à la plage Aïn Diab','Initiation au surf sur les vagues d’Aïn Diab, tout le matériel est fourni par un instructeur professionnel.','Aïn Diab, Casablanca',33.57580000,-7.69150000,250.00,240,1,'\"[\\\"http://localhost:5000/uploads/1749062134867-the-best-school.jpg\\\"]\"','2025-06-04 18:35:34','2025-06-04 18:35:34',2,3,NULL),(5,'Visite guidée de la cathédrale du Sacré-Cœur','Découverte de la cathédrale néo-gothique du Sacré-Cœur et de son histoire dans le quartier Gauthier.','Gauthier, Casablanca',33.59000000,-7.62100000,80.00,90,1,'\"[\\\"http://localhost:5000/uploads/1749062279338-caption (1).jpg\\\"]\"','2025-06-04 18:37:59','2025-06-04 18:37:59',2,4,NULL),(7,'Atelier de cuisine marocaine à Maarif','Apprenez à préparer un tajine et un couscous traditionnels dans une maison berbère située à Maarif.','Maarif, Casablanca',33.58200000,-7.60900000,300.00,240,1,'\"[\\\"http://localhost:5000/uploads/1749062426932-caption (2).jpg\\\"]\"','2025-06-04 18:40:26','2025-06-04 18:40:26',2,5,NULL),(8,'Yoga matinal au Parc de la Ligue Arabe','Séance de yoga en plein air au Parc de la Ligue Arabe, idéale pour débutants et confirmés.','Parc de la Ligue Arabe, Casablanca',33.56500000,-7.63200000,150.00,90,1,'\"[\\\"http://localhost:5000/uploads/1749062828098-depositphotos_660183670-stock-photo-woman-practices-yoga-morning-park.jpg\\\"]\"','2025-06-04 18:47:08','2025-06-04 18:47:08',2,6,NULL),(9,'Observation des oiseaux au Parc de Sindibad','Excursion guidée pour observer la faune aviaire dans les espaces verts du Parc de Sindibad.','Sindibad, Casablanca',33.55600000,-7.71400000,100.00,100,1,'\"[\\\"http://localhost:5000/uploads/1749062967932-observation-des-oiseaux-dans-la-parc-de-la-poudrerie.jpg\\\"]\"','2025-06-04 18:49:27','2025-06-04 18:49:27',2,7,NULL),(10,'Visite historique de la Place Mohammed V','Balade guidée pour découvrir l’histoire et l’architecture de la Place Mohammed V et du Théâtre Mohamed V.','Place Mohammed V, Casablanca',33.59300000,-7.62000000,90.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749063120059-casablanca-plaza-mohammed-v-pal.jpg\\\"]\"','2025-06-04 18:52:00','2025-06-04 18:52:00',2,8,NULL),(11,'Atelier de poterie artisanale','Apprenez la poterie traditionnelle dans un atelier d’artisanat situé dans le quartier Derb Sultan.','Derb Sultan, Casablanca',33.57100000,-7.61100000,250.00,180,1,'\"[\\\"http://localhost:5000/uploads/1749063223038-images.jpeg\\\"]\"','2025-06-04 18:53:43','2025-06-04 18:53:43',2,9,NULL),(12,'Concert de musique andalouse au quartier Gauthier','Soirée musicale traditionnelle andalouse dans un riad du quartier Gauthier, thé à la menthe inclus.','Gauthier, Casablanca',33.59000000,-7.62100000,150.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749063349971-Festival-des-Musiques-sacrees.jpg\\\"]\"','2025-06-04 18:55:49','2025-06-04 18:55:49',2,10,NULL),(13,'Visite ludique pour enfants au quartier Oasis','Balade interactive pour familles dans le quartier Oasis, avec animations et jeux éducatifs.','Oasis, Casablanca',33.58000000,-7.67000000,150.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749063495413-105A5466.JPG\\\"]\"','2025-06-04 18:58:15','2025-06-04 18:58:15',2,11,NULL),(14,'Randonnée en quad dans la Palmeraie','Aventure en quad de 2 heures dans la Palmeraie de Casablanca, longeant les palmiers et les oasis urbaines.','Palmeraie, Casablanca',33.71670000,-7.94770000,300.00,180,1,'\"[\\\"http://localhost:5000/uploads/1749063624828-images (1).jpeg\\\"]\"','2025-06-04 19:00:24','2025-06-04 19:00:24',2,1,NULL),(15,'Session d’escalade urbaine à Sidi Belyout','Cours d’escalade indoor pour tous niveaux dans le complexe sportif de Sidi Belyout.','Sidi Belyout, Casablanca',33.58400000,-7.62700000,300.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749063738289-escalade-urbaine-paris-rosa-parks-thibault-2-960x640.jpg\\\"]\"','2025-06-04 19:02:18','2025-06-04 19:02:18',2,3,NULL),(16,'Visite guidée du Musée de la Fondation Abderrahman Slaoui','Découverte de la collection d’art moderne et d’objets d’art au sein de la Fondation Abderrahman Slaoui.','Roches Noires, Casablanca',33.58900000,-7.56600000,100.00,90,1,'\"[\\\"http://localhost:5000/uploads/1749063833298-entree_musee.jpg\\\"]\"','2025-06-04 19:03:53','2025-06-04 19:03:53',2,4,NULL),(17,'Atelier de pâtisserie à Derb Ghallef','Apprenez à confectionner des pâtisseries marocaines traditionnelles dans un atelier local à Derb Ghallef.','Derb Ghallef, Casablanca',33.58200000,-7.60400000,220.00,180,1,'\"[\\\"http://localhost:5000/uploads/1749063921041-mg-7384-1024x683.jpg\\\"]\"','2025-06-04 19:05:21','2025-06-04 19:05:21',2,5,NULL),(18,'Séance de méditation au Parc de la Ligue Arab','Cours de méditation guidée en plein air dans le Parc de la Ligue Arabe, pour détente et bien-être.','Parc de la Ligue Arabe, Casablanca',33.56500000,-7.63200000,120.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749064038239-35374860-femme-de-facon-relaxante-seance-et-pratiquant-meditation-dans-le-publique-parc-a-atteindre-bonheur-de-interne-paix-sagesse-en-dessous-de-le-arbre-dans-le-ete-photo.jpg\\\"]\"','2025-06-04 19:07:18','2025-06-04 19:07:18',2,6,NULL),(19,'Atelier de mosaïque au centre Art Wall','Initiation à l’art de la mosaïque dans un atelier artisanal situé dans le quartier Palmier.','Palmier, Casablanca',33.58600000,-7.62100000,200.00,180,1,'\"[\\\"http://localhost:5000/uploads/1749127777565-22-12-27-Mosaique-750x425-1.jpg\\\"]\"','2025-06-05 12:49:37','2025-06-05 12:49:37',2,9,NULL),(20,'Concert jazz en plein air','Soirée jazz en plein air dans le jardin du Parc de la Ligue Arabe, artistes locaux et internationaux.','Parc de la Ligue Arabe, Casablanca',33.56500000,-7.63200000,150.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749127929749-concert-jazz-swing-mediateque-sartrouville-6.jpg\\\"]\"','2025-06-05 12:52:09','2025-06-05 12:52:09',2,10,NULL),(21,'Visite interactive pour enfants au Morocco Mall','Chasse au trésor et ateliers ludiques pour enfants au Morocco Mall, avec guide pédagogique.','Anfa, Casablanca',33.57800000,-7.61200000,120.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749128020547-AquaDream.jpg\\\"]\"','2025-06-05 12:53:40','2025-06-05 12:53:40',2,11,NULL),(22,'Excursion en quad sur la corniche d’Aïn Sebaâ','Chasse au trésor et ateliers ludiques pour enfants au Morocco Mall, avec guide pédagogique.','Aïn Sebaâ, Casablanca',33.57600000,-7.62000000,300.00,240,1,'\"[\\\"http://localhost:5000/uploads/1749128137748-bc.jpg\\\"]\"','2025-06-05 12:55:37','2025-06-05 12:55:37',2,1,NULL),(23,'Séance d’escalade intérieure au centre de Casablanca','Cours d’escalade indoor pour débutants et confirmés dans une salle équipée du centre-ville.','Derb Ghallef, Casablanca',33.58200000,-7.60400000,200.00,120,1,'\"[\\\"http://localhost:5000/uploads/1749128238453-images (2).jpeg\\\"]\"','2025-06-05 12:57:18','2025-06-05 12:57:18',2,3,NULL);
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_reviews`
--

DROP TABLE IF EXISTS `activity_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rating` int DEFAULT NULL,
  `comment` text COLLATE utf8mb4_general_ci,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int DEFAULT NULL,
  `activity_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `activity_reviews_ibfk_49` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `activity_reviews_ibfk_50` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_reviews`
--

LOCK TABLES `activity_reviews` WRITE;
/*!40000 ALTER TABLE `activity_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Aventure'),(3,'Sport'),(4,'Culture'),(5,'Gastronomie'),(6,'Bien-être'),(7,'Nature'),(8,'Historique'),(9,'Art & Artisanat'),(10,'Musique & Danse'),(11,'Familial');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `remaining_places` int DEFAULT NULL,
  `activity_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'2025-06-10','10:00:00','12:00:00',10,10,NULL);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `activity_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `favorites_ibfk_49` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `favorites_ibfk_50` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES (12,1,4),(17,1,11);
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `participants` int DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `payment_status` enum('unpaid','paid','refunded') COLLATE utf8mb4_general_ci DEFAULT 'unpaid',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int DEFAULT NULL,
  `event_id` int DEFAULT NULL,
  `activity_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `event_id` (`event_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `reservations_ibfk_73` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `reservations_ibfk_74` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `reservations_ibfk_75` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_reservations`
--

DROP TABLE IF EXISTS `restaurant_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reservation_date` date DEFAULT NULL,
  `reservation_time` time DEFAULT NULL,
  `guests` int DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int DEFAULT NULL,
  `restaurant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_reservations_ibfk_49` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `restaurant_reservations_ibfk_50` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_reservations`
--

LOCK TABLES `restaurant_reservations` WRITE;
/*!40000 ALTER TABLE `restaurant_reservations` DISABLE KEYS */;
/*!40000 ALTER TABLE `restaurant_reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_reviews`
--

DROP TABLE IF EXISTS `restaurant_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rating` int DEFAULT NULL,
  `comment` text COLLATE utf8mb4_general_ci,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int DEFAULT NULL,
  `restaurant_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `restaurant_reviews_ibfk_49` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `restaurant_reviews_ibfk_50` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_reviews`
--

LOCK TABLES `restaurant_reviews` WRITE;
/*!40000 ALTER TABLE `restaurant_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `restaurant_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurants`
--

DROP TABLE IF EXISTS `restaurants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `partner_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `owner_id` int DEFAULT NULL,
  `image_urls` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partner_id` (`partner_id`),
  KEY `category_id` (`category_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `restaurants_ibfk_49` FOREIGN KEY (`partner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `restaurants_ibfk_50` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `restaurants_ibfk_51` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurants`
--

LOCK TABLES `restaurants` WRITE;
/*!40000 ALTER TABLE `restaurants` DISABLE KEYS */;
INSERT INTO `restaurants` VALUES (2,'Restaurant El Bahia','Cuisine marocaine traditionnelle','22 Rue Badr, Casablanca',33.58988600,7.60386900,'+212612345678','elbahia@resto.ma','https://elbahia.ma',1,'2025-06-02 18:44:34','2025-06-02 18:44:34',2,1,NULL,'[\"http://localhost:5000/uploads/1748889874470-Screenshot 2025-02-20 234837.png\"]');
/*!40000 ALTER TABLE `restaurants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fullname` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password_hash` text COLLATE utf8mb4_general_ci,
  `phone` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('admin','customer','partner') COLLATE utf8mb4_general_ci DEFAULT 'customer',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `email_2` (`email`),
  UNIQUE KEY `email_3` (`email`),
  UNIQUE KEY `email_4` (`email`),
  UNIQUE KEY `email_5` (`email`),
  UNIQUE KEY `email_6` (`email`),
  UNIQUE KEY `email_7` (`email`),
  UNIQUE KEY `email_8` (`email`),
  UNIQUE KEY `email_9` (`email`),
  UNIQUE KEY `email_10` (`email`),
  UNIQUE KEY `email_11` (`email`),
  UNIQUE KEY `email_12` (`email`),
  UNIQUE KEY `email_13` (`email`),
  UNIQUE KEY `email_14` (`email`),
  UNIQUE KEY `email_15` (`email`),
  UNIQUE KEY `email_16` (`email`),
  UNIQUE KEY `email_17` (`email`),
  UNIQUE KEY `email_18` (`email`),
  UNIQUE KEY `email_19` (`email`),
  UNIQUE KEY `email_20` (`email`),
  UNIQUE KEY `email_21` (`email`),
  UNIQUE KEY `email_22` (`email`),
  UNIQUE KEY `email_23` (`email`),
  UNIQUE KEY `email_24` (`email`),
  UNIQUE KEY `email_25` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Merouane Hany','merouane@example.com','$2b$10$9Y7FRyfh1ZjFst8f0NiC0Ozr17n1/QHlkoQ7r7bXekPkrAmVJHDeG','+212766259860','customer','2025-06-02 15:33:30','2025-06-02 15:33:30'),(2,'partner','partner@example.com','$2b$10$NQGVgRcMmXo9ol/V/XcuQuyWkCkPIOPEAohdsLA12cvbvp3kkNFke','+212500000000','partner','2025-06-02 16:09:14','2025-06-02 16:09:14'),(3,'amine','amine@example.com','$2b$10$O4wUdZvkq5gwTb7ehfmeDeQJqPeeirUGBqEt3hCtIPaD4hCObU5NW','+212500000000','customer','2025-06-02 18:09:15','2025-06-02 18:15:25'),(4,'admin','admin@example.com','$2b$10$7KB.PKLL7OmF7o05vgAXZuis/XD3QMyRrMEE0/ws3Jd763FdYTfLe','+212500000000','admin','2025-06-02 18:20:57','2025-06-02 18:20:57');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-05 14:05:31
