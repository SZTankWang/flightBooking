-- MySQL dump 10.13  Distrib 8.0.22, for macos10.15 (x86_64)
--
-- Host: 8.129.182.214    Database: eflight
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `airline`
--

DROP TABLE IF EXISTS `airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline` (
  `airline_name` varchar(50) NOT NULL,
  PRIMARY KEY (`airline_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airline`
--

LOCK TABLES `airline` WRITE;
/*!40000 ALTER TABLE `airline` DISABLE KEYS */;
INSERT INTO `airline` VALUES ('China Airline'),('China Eastern'),('China Southern'),('Jet Blue'),('Shenzhen Airline'),('Wuhu Airline');
/*!40000 ALTER TABLE `airline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airline_sequence_num`
--

DROP TABLE IF EXISTS `airline_sequence_num`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline_sequence_num` (
  `type` varchar(12) NOT NULL,
  `curr_value` int NOT NULL,
  `increment` int NOT NULL DEFAULT '1',
  `airline` varchar(20) NOT NULL,
  PRIMARY KEY (`type`,`airline`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airline_sequence_num`
--

LOCK TABLES `airline_sequence_num` WRITE;
/*!40000 ALTER TABLE `airline_sequence_num` DISABLE KEYS */;
INSERT INTO `airline_sequence_num` VALUES ('1',101,1,'1'),('flight_num',102,1,'China Eastern'),('flight_num',105,1,'Jet Blue'),('flight_num',107,1,'Shenzhen Airline'),('flight_num',144,1,'Wuhu Airline'),('plane_id',101,1,'China Airline'),('plane_id',105,1,'China Eastern'),('plane_id',105,1,'China Southern'),('plane_id',103,1,'Jet Blue'),('plane_id',110,1,'Shenzhen Airline'),('plane_id',110,1,'Wuhu Airline');
/*!40000 ALTER TABLE `airline_sequence_num` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airline_staff`
--

DROP TABLE IF EXISTS `airline_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline_staff` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  `airline_name` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  KEY `airline_name` (`airline_name`),
  CONSTRAINT `airline_staff_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`airline_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airline_staff`
--

LOCK TABLES `airline_staff` WRITE;
/*!40000 ALTER TABLE `airline_staff` DISABLE KEYS */;
INSERT INTO `airline_staff` VALUES ('AirlineStaff','abcd1234','Joe','Bland','1980-02-05','Jet Blue'),('cbrahm0','3FlG59wG','Charyl','Brahm','1995-10-03','China Eastern'),('wuhudsm','wbwb','Jinlong','Han','1980-02-05','Wuhu Airline');
/*!40000 ALTER TABLE `airline_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airplane`
--

DROP TABLE IF EXISTS `airplane`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airplane` (
  `airline_name` varchar(50) NOT NULL,
  `airplane_id` int NOT NULL,
  `seats` int NOT NULL,
  PRIMARY KEY (`airline_name`,`airplane_id`),
  CONSTRAINT `airplane_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`airline_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airplane`
--

LOCK TABLES `airplane` WRITE;
/*!40000 ALTER TABLE `airplane` DISABLE KEYS */;
INSERT INTO `airplane` VALUES ('China Airline',100,127),('China Eastern',100,243),('China Eastern',101,319),('China Eastern',102,393),('China Eastern',104,500),('China Southern',100,414),('China Southern',101,369),('China Southern',102,219),('China Southern',103,474),('China Southern',104,133),('Jet Blue',100,100),('Jet Blue',101,50),('Jet Blue',102,75),('Shenzhen Airline',100,253),('Shenzhen Airline',101,282),('Shenzhen Airline',102,117),('Shenzhen Airline',103,327),('Shenzhen Airline',104,477),('Shenzhen Airline',105,188),('Shenzhen Airline',107,300),('Shenzhen Airline',109,300),('Wuhu Airline',101,2000),('Wuhu Airline',103,500),('Wuhu Airline',105,100),('Wuhu Airline',107,500),('Wuhu Airline',109,10000);
/*!40000 ALTER TABLE `airplane` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`SE`@`%`*/ /*!50003 TRIGGER `set_plane_id` BEFORE INSERT ON `airplane` FOR EACH ROW BEGIN
		DECLARE num INT;
		SELECT next_val('plane_id', NEW.airline_name) INTO num;
		SET NEW.airplane_id = num;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `airport`
--

DROP TABLE IF EXISTS `airport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airport` (
  `airport_name` varchar(50) NOT NULL,
  `airport_city` varchar(50) NOT NULL,
  PRIMARY KEY (`airport_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airport`
--

LOCK TABLES `airport` WRITE;
/*!40000 ALTER TABLE `airport` DISABLE KEYS */;
INSERT INTO `airport` VALUES ('CDG','Paris'),('HRB','Harbin'),('JFK','New York'),('KHH','Gaoxiong'),('La Guardia','New York City'),('LAX','Los Angeles'),('Louisville SDF','Louisville'),('NRT','Tokyo'),('O\'Hare','Chicago'),('PEK','Beijing'),('PKX','Beijing'),('PVG','Shanghai'),('SFO','San Francisco'),('SHA','Shanghai'),('SVO','Moscow'),('SZX','Shenzhen'),('WHA','Wuhu');
/*!40000 ALTER TABLE `airport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_agent`
--

DROP TABLE IF EXISTS `booking_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_agent` (
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `booking_agent_id` int NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_agent`
--

LOCK TABLES `booking_agent` WRITE;
/*!40000 ALTER TABLE `booking_agent` DISABLE KEYS */;
INSERT INTO `booking_agent` VALUES ('12306','233',12306),('Booking@agent.com','abcd1234',1),('eFlight@agent.com','test',12345678),('Professional@booking.com','abcd1234',2);
/*!40000 ALTER TABLE `booking_agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `building_number` varchar(30) NOT NULL,
  `street` varchar(30) NOT NULL,
  `city` varchar(30) NOT NULL,
  `state` varchar(30) NOT NULL,
  `phone_number` bigint NOT NULL,
  `passport_number` varchar(30) NOT NULL,
  `passport_expiration` date NOT NULL,
  `passport_country` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('123','123','123','123','123','123','123',123,'123','2020-12-13','123','2020-12-06'),('Customer2@nyu.edu','Jarad','abcd1234','5','Sullivan','Corpus Christi','Texas',13234324234,'46-809-1951','2021-09-30','United States','2020-02-02'),('Customer@nyu.edu','Customer','abcd1234','2','Metrotech','New York','New York',51234,'P123456','2020-10-24','USA','1990-04-01'),('one@nyu.edu','Keenan','test','064','Summerview','Shawnee Mission','Kansas',-3975,'50-906-9117','2021-07-25','United States','2019-12-21'),('test@nyu.edu','t','test','t','t','t','t',123445,'234','2020-12-30','sdf','2000-01-01'),('three@nyu.edu','Shijun Tong','test','1555','Century Avenue','Shanghai','Shanghai',12222222222,'12345678987654321','2025-10-25','China','1956-06-07'),('two@nyu.edu','Aurie','test','8','Colorado','New Orleans','Louisiana',-7148,'14-899-4026','2021-01-03','United States','2020-07-24'),('zw1806@nyu.edu','zhenming','sfls2012101','test','test','test','test',17722699710,'test','2020-12-30','test','2000-09-22');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flight`
--

DROP TABLE IF EXISTS `flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight` (
  `airline_name` varchar(50) NOT NULL,
  `flight_num` int NOT NULL,
  `departure_airport` varchar(50) NOT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_airport` varchar(50) NOT NULL,
  `arrival_time` datetime NOT NULL,
  `price` decimal(10,0) NOT NULL,
  `status` varchar(50) NOT NULL COMMENT 'flight status: 0:未出发 1:已出发 2: 已到达 3:延误 4:已取消 ',
  `airplane_id` int NOT NULL,
  PRIMARY KEY (`airline_name`,`flight_num`),
  KEY `airline_name` (`airline_name`,`airplane_id`),
  KEY `departure_airport` (`departure_airport`),
  KEY `arrival_airport` (`arrival_airport`),
  CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`airline_name`, `airplane_id`) REFERENCES `airplane` (`airline_name`, `airplane_id`),
  CONSTRAINT `flight_ibfk_2` FOREIGN KEY (`departure_airport`) REFERENCES `airport` (`airport_name`),
  CONSTRAINT `flight_ibfk_3` FOREIGN KEY (`arrival_airport`) REFERENCES `airport` (`airport_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES ('China Eastern',101,'KHH','2020-12-24 10:00:00','SHA','2020-12-24 13:00:00',90000,'0',104),('Jet Blue',100,'SFO','2020-12-20 23:50:00','JFK','2020-12-21 08:50:00',200,'0',100),('Jet Blue',101,'O\'Hare','2021-01-01 12:00:00','SFO','2021-01-01 14:00:00',420,'0',100),('Jet Blue',102,'La Guardia','2020-12-19 22:00:00','SFO','2020-12-20 02:00:00',600,'0',100),('Jet Blue',103,'JFK','2020-12-25 05:00:00','Louisville SDF','2020-12-25 07:00:00',97,'0',102),('Jet Blue',104,'O\'Hare','2020-09-01 00:00:00','SFO','2020-09-01 04:00:00',500,'3',101),('Shenzhen Airline',100,'PVG','2020-11-13 13:30:34','JFK','2020-11-22 15:09:48',250,'3',101),('Shenzhen Airline',106,'WHA','2020-12-10 11:00:00','PVG','2020-12-10 12:00:00',200,'0',109),('Wuhu Airline',101,'SZX','2020-12-10 11:00:00','SHA','2020-12-10 12:00:00',100,'1',105),('Wuhu Airline',137,'PKX','2020-12-23 10:30:00','HRB','2020-12-24 02:00:00',200,'0',109),('Wuhu Airline',141,'SZX','2020-12-11 11:00:00','PVG','2020-12-11 12:30:00',200,'4',109),('Wuhu Airline',143,'CDG','2020-12-21 11:00:00','NRT','2020-12-21 14:00:00',1000,'0',109);
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`SE`@`%`*/ /*!50003 TRIGGER `set_flight_num` BEFORE INSERT ON `flight` FOR EACH ROW BEGIN
		DECLARE num INT;
		SELECT next_val('flight_num', NEW.airline_name) INTO num;
		SET NEW.flight_num = num;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `purchase_sequence_num`
--

DROP TABLE IF EXISTS `purchase_sequence_num`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_sequence_num` (
  `curr_value` int NOT NULL DEFAULT '1000',
  `increment` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`curr_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_sequence_num`
--

LOCK TABLES `purchase_sequence_num` WRITE;
/*!40000 ALTER TABLE `purchase_sequence_num` DISABLE KEYS */;
INSERT INTO `purchase_sequence_num` VALUES (10044,1);
/*!40000 ALTER TABLE `purchase_sequence_num` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchases`
--

DROP TABLE IF EXISTS `purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchases` (
  `ticket_id` int NOT NULL,
  `purchase_id` varchar(8) NOT NULL,
  `customer_email` varchar(50) NOT NULL,
  `booking_agent_id` int DEFAULT NULL,
  `purchase_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ticket_id`,`customer_email`),
  KEY `customer_email` (`customer_email`),
  CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`),
  CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`customer_email`) REFERENCES `customer` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchases`
--

LOCK TABLES `purchases` WRITE;
/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
INSERT INTO `purchases` VALUES (2,'10019','one@nyu.edu',0,'2020-09-10 02:23:20'),(3,'10019','one@nyu.edu',0,'2020-10-10 02:23:20'),(4,'10019','one@nyu.edu',0,'2020-11-10 02:23:20'),(5,'10020','two@nyu.edu',12345678,'2020-12-10 04:02:29'),(7,'10022','one@nyu.edu',12345678,'2020-12-10 04:03:47'),(8,'10023','two@nyu.edu',12306,'2020-12-10 04:08:50'),(9,'10024','three@nyu.edu',12306,'2020-12-10 04:11:59'),(10,'10024','three@nyu.edu',12306,'2020-12-10 04:11:59'),(11,'10024','three@nyu.edu',12306,'2020-12-10 04:11:59'),(12,'10024','three@nyu.edu',12306,'2020-12-10 04:11:59'),(13,'10024','three@nyu.edu',12306,'2020-12-10 04:11:59'),(14,'10025','three@nyu.edu',62994809,'2020-12-10 04:15:55'),(15,'10025','three@nyu.edu',62994809,'2020-12-10 04:15:55'),(16,'10026','one@nyu.edu',62994809,'2020-12-10 05:03:07'),(17,'10026','one@nyu.edu',62994809,'2020-12-10 05:03:07'),(18,'10027','one@nyu.edu',0,'2020-12-10 05:06:06'),(19,'10027','one@nyu.edu',0,'2020-12-10 05:06:06'),(20,'10027','one@nyu.edu',0,'2020-12-10 05:06:06'),(22,'10029','Customer@nyu.edu',0,'2019-12-31 16:00:00'),(24,'10031','Customer@nyu.edu',1,'2020-11-17 04:00:00'),(25,'10032','one@nyu.edu',2,'2020-10-10 04:00:00'),(26,'10033','two@nyu.edu',2,'2020-10-11 04:00:00'),(27,'10034','Customer@nyu.edu',1,'2020-09-12 04:00:00'),(28,'10035','one@nyu.edu',0,'2020-08-19 04:00:00'),(29,'10036','two@nyu.edu',0,'2020-08-23 04:00:00'),(30,'10037','one@nyu.edu',1,'2020-11-15 04:00:00'),(31,'10038','Customer@nyu.edu',1,'2020-06-19 04:00:00'),(36,'10043','one@nyu.edu',0,'2020-12-15 03:45:49');
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket` (
  `ticket_id` int NOT NULL AUTO_INCREMENT,
  `status` int NOT NULL DEFAULT '0',
  `airline_name` varchar(50) NOT NULL,
  `flight_num` int NOT NULL,
  `passenger_name` varchar(32) NOT NULL,
  `passenger_id` varchar(32) NOT NULL,
  `passenger_phone` bigint NOT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `airline_name` (`airline_name`,`flight_num`),
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`airline_name`, `flight_num`) REFERENCES `flight` (`airline_name`, `flight_num`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
INSERT INTO `ticket` VALUES (2,0,'Wuhu Airline',143,'Ding Wang','12345',12345),(3,0,'Wuhu Airline',143,'Honglin Zhu','123456',123456),(4,0,'Wuhu Airline',143,'Zhen Ding','1234567',1234567),(5,0,'Wuhu Airline',137,'Michael Jackson','12345',12341234123),(7,4,'Wuhu Airline',141,'Ariana Grande','1234567',1234567654),(8,0,'Wuhu Airline',143,'Anbei Jinsan','201984112',123213123),(9,0,'Wuhu Airline',137,'1','1',1),(10,0,'Wuhu Airline',137,'2','2',2),(11,0,'Wuhu Airline',137,'3','3',3),(12,0,'Wuhu Airline',137,'4','4',4),(13,0,'Wuhu Airline',137,'5','5',5),(14,1,'Wuhu Airline',101,'1','1',1),(15,1,'Wuhu Airline',101,'2','2',2),(16,0,'China Eastern',101,'1','1',1),(17,0,'China Eastern',101,'2','2',2),(18,0,'China Eastern',101,'3','3',3),(19,0,'China Eastern',101,'2','2',2),(20,0,'China Eastern',101,'1','1',1),(22,0,'Jet Blue',100,'John Smith','12345',12345),(24,0,'Jet Blue',102,'John Smith','12345',12345),(25,3,'Jet Blue',104,'John Smith','12345',12345),(26,3,'Jet Blue',104,'John Smith','12345',12345),(27,3,'Jet Blue',104,'John Smith','12345',12345),(28,0,'Jet Blue',103,'John Smith','12345',12345),(29,0,'Jet Blue',103,'John Smith','12345',12345),(30,0,'Jet Blue',102,'John Smith','12345',12345),(31,0,'Jet Blue',103,'John Smith','12345',12345),(36,0,'Jet Blue',100,'Self Test','12345',12345);
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('123','123','customer'),('12306','233','agent'),('AirlineStaff','abcd1234','staff'),('Booking@agent.com','abcd1234','agent'),('cbrahm0','3FlG59wG','staff'),('Customer@nyu.edu','abcd1234','customer'),('Customer2@nyu.edu','abcd1234','customer'),('eFlight@agent.com','test','agent'),('one@nyu.edu','test','customer'),('test@nyu.edu','test','customer'),('three@nyu.edu','test','customer'),('two@nyu.edu','test','customer'),('wuhudsm','wbwb','staff'),('zw1806@nyu.edu','sfls2012101','customer');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


-- Dump completed on 2020-12-15 21:44:18
