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
-- Dumping routines for database 'eflight'
--
/*!50003 DROP FUNCTION IF EXISTS `agent_get_id_by_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `agent_get_id_by_email`(agent_email VARCHAR(50)) RETURNS int
BEGIN
    DECLARE result int;
    SELECT booking_agent_id INTO result from booking_agent where email = agent_email;
RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `next_purchase_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `next_purchase_id`() RETURNS int
BEGIN
DECLARE
			cur INT;
		set cur = (SELECT curr_value FROM purchase_sequence_num s);

		if cur is null then
				INSERT INTO purchase_sequence_num
					VALUES (10000,1);
					set cur = 10000;

		END IF;
		UPDATE purchase_sequence_num s
		SET s.curr_value= cur + s.increment;

		RETURN cur;
		END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `next_val` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `next_val`(type VARCHAR(12),airline VARCHAR(20)) RETURNS int
BEGIN
DECLARE
			cur INT;
		set cur = (SELECT curr_value FROM airline_sequence_num s where s.type=type AND s.airline=airline);
		if
			cur IS NULL THEN
				INSERT INTO airline_sequence_num
					VALUES
						(type,100,1,airline);
						set cur = 100;
		END IF;
		UPDATE airline_sequence_num s
		SET s.curr_value= cur + s.increment
		WHERE s.type=type and s.airline = airline;
		RETURN cur;
		END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `query_avail_space` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `query_avail_space`(
	flight_num_args INT,
	airline_name_args VARCHAR(50)
) RETURNS int
BEGIN
	DECLARE total_space INT;
	DECLARE sold_space INT;

	SELECT airplane.seats INTO total_space
	FROM airplane natural join flight
	WHERE (flight_num,airline_name) = (flight_num_args,airline_name_args);


	SELECT count(*) INTO sold_space
	FROM ticket natural join flight
	WHERE  (flight_num,airline_name) = (flight_num_args,airline_name_args)
	AND ticket.status = 0;


	RETURN (total_space - sold_space);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `return_city` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `return_city`(airport VARCHAR(50)) RETURNS varchar(50) CHARSET utf8mb4
BEGIN
DECLARE city VARCHAR(50);
SET city = (SELECT airport_city
			FROM airport
            WHERE airport_name = airport);
RETURN city;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `return_passenger_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `return_passenger_list`(
	purchaseID VARCHAR(8)
) RETURNS varchar(100) CHARSET utf8mb4
BEGIN
    DECLARE result VARCHAR(100);
    SELECT
	GROUP_CONCAT(passenger_name SEPARATOR" ") INTO result
    FROM purchases NATURAL JOIN ticket
    WHERE purchase_id = purchaseID;
    RETURN result;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `return_passenger_num` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `return_passenger_num`(
	purchaseID VARCHAR(8)
) RETURNS int
BEGIN
    DECLARE result int;
    SELECT
	COUNT(ticket_id) INTO result
    FROM purchases NATURAL JOIN ticket
    WHERE purchase_id = purchaseID;
    RETURN result;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `return_total_spending` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` FUNCTION `return_total_spending`(
	customerID VARCHAR(50)
) RETURNS int
BEGIN
    DECLARE result int;
    SELECT
	SUM(price) INTO result
    FROM purchases NATURAL JOIN ticket NATURAL JOIN flight
    WHERE customer_email = customerID;
    RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `change_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `change_status`(staffID VARCHAR(50),flight_number int,new_status int)
BEGIN
    DECLARE msg VARCHAR(50);
    DECLARE code int;
    DECLARE airline VARCHAR(50);

    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    UPDATE flight
    SET status = new_status
    WHERE (airline_name, flight_num) = (airline, flight_number);

	UPDATE ticket
    SET status = new_status
    WHERE (airline_name, flight_num) = (airline, flight_number);

	set msg = "status changed successfully!";
    set code = 0;
    SELECT msg,code;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `create_agent`(
	IN email varchar(50),
    IN `password` varchar(50),
    IN booking_agent_id_arg int

)
create_agent:BEGIN
	DECLARE agent_id_check int default 0;
    DECLARE msg VARCHAR(100);
	DECLARE EXIT HANDLER FOR 1062
    BEGIN set msg = "email is already registered!";
    END;

    SELECT booking_agent_id INTO agent_id_check FROM booking_agent WHERE booking_agent_id = booking_agent_id_arg;

    if agent_id_check <> 0 THEN
    set msg = "booking agent id duplicate!";
    leave create_agent;
    END IF;

    INSERT INTO booking_agent VALUES (email,`password`,booking_agent_id_arg);
    INSERT INTO user VALUES (email,`password`,'agent');
    set msg = "registered successfully";
    SELECT msg;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_airplane` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `create_airplane`(staffID VARCHAR(50),seats int)
BEGIN
    DECLARE msg VARCHAR(50);
    DECLARE code int;
    DECLARE airline VARCHAR(50);
    DECLARE EXIT handler for 1062
    BEGIN
        set msg="airplane already existed!";
        set code=-1;
        select msg,code;
	END;
    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    INSERT into airplane values(airline,next_val("plane_id",airline),seats);
    set msg = "airplane created successfully!";
    set code = 0;
    SELECT msg,code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_airport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `create_airport`(name VARCHAR(50),city VARCHAR(50))
BEGIN
    DECLARE msg VARCHAR(50);
    DECLARE code int;
    DECLARE EXIT handler for 1062
    BEGIN
        set msg="airport already created!";
        set code=-1;
        select msg,code;
	END;

    INSERT into airport values(name,city);
    set msg = "airport created successfully!";
    set code = 0;
    SELECT msg,code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `create_customer`(
		IN email varchar(50),
        IN `name` varchar(50),
        IN `password` varchar(50),
        IN building_number varchar(30),
        IN street varchar(30),
        IN city varchar(30),
        IN state varchar(30),
        IN phone_number bigint,
        IN passport_number varchar(30),
        IN passport_expiration date,
        IN passport_country varchar(50),
        IN date_of_birth date
    )
BEGIN
    DECLARE msg VARCHAR(100);
	DECLARE EXIT handler for 1062
		BEGIN
			SET msg = "email already registered";
		END;

        INSERT INTO customer VALUES (email,`name`,`password`,building_number,street, city, state, phone_number, passport_number, passport_expiration, passport_country, date_of_birth);
        INSERT INTO user VALUES (email,`password`,'customer');
        SET msg = "registered successfully";
    SELECT msg;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_flight` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `create_flight`(staffID VARCHAR(50),given_departure_airport VARCHAR(50), given_departure_time datetime,given_arrival_airport VARCHAR(50), given_arrival_time datetime, price decimal(10,0), status VARCHAR(50))
BEGIN
    DECLARE msg VARCHAR(50);
    DECLARE random_id int;
    DECLARE code int;
    DECLARE airline VARCHAR(50);
    DECLARE EXIT handler for 1062
    BEGIN
        set msg="flight already created!";
        set code=-1;
        select msg,code;
	END;
    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;


    SELECT airplane_id INTO random_id
    FROM ((SELECT airplane_id
    FROM airplane NATURAL JOIN flight
    WHERE (given_departure_time NOT BETWEEN departure_time AND arrival_time) AND (given_arrival_time NOT BETWEEN departure_time AND arrival_time) AND airline_name = airline)
    UNION
    (SELECT airplane_id
    FROM airplane
    WHERE airline_name=airline AND airplane_id NOT IN (select airplane_id from flight where airline_name = airline))) as a
    ORDER BY airplane_id DESC
    LIMIT 1;

    INSERT into flight values(airline,next_val("flight_num",airline),given_departure_airport,given_departure_time,given_arrival_airport,given_arrival_time,price,status,random_id);
    set msg = "flight created successfully!";
    set code = 0;
    SELECT msg,code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_staff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `create_staff`(
	IN username VARCHAR(50),
    IN password VARCHAR(50),
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN date_of_birth date,
    IN airline_name_args VARCHAR(50)
)
create_staff:BEGIN
	 DECLARE airline_check VARCHAR(50) DEFAULT '';
     DECLARE msg VARCHAR(100);
	 DECLARE EXIT HANDLER FOR 1062
     BEGIN
		set msg = "username duplicating!";
	 END;

     SELECT airline_name INTO airline_check FROM airline WHERE airline_name = airline_name_args;

     IF airline_check = '' THEN
		SET msg = "invalid airline!";
        LEAVE create_staff;
	 END IF ;

     INSERT INTO airline_staff VALUES (username,`password`,first_name,last_name, date_of_birth, airline_name_args);
     INSERT INTO user VALUES (username,`password`,'staff');
     SET msg = "registered successfully";
     SELECT msg;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `create_user`(
		IN email varchar(50),
        IN `name` varchar(50),
        IN `password` varchar(50),
        IN building_number varchar(30),
        IN street varchar(30),
        IN city varchar(30),
        IN state varchar(30),
        IN phone_number bigint,
        IN passport_number varchar(30),
        IN passport_expiration date,
        IN passport_country varchar(50),
        IN date_of_birth date
    )
BEGIN
    DECLARE msg VARCHAR(100);
	DECLARE EXIT handler for 1062
		BEGIN
			SET msg = "email already registered";
		END;

        INSERT INTO customer VALUES (email,`name`,`password`,building_number,street, city, state, phone_number, passport_number, passport_expiration, passport_country, date_of_birth);
        INSERT INTO user VALUES (email,`password`,'customer');
        SET msg = "registered successfully";
    SELECT msg;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_view_flights` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `customer_view_flights`(username VARCHAR(50))
BEGIN
    SELECT
        airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city,
        departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,
        status,cast(sum(price) as char(11)) as price,
        return_passenger_num(purchase_id) as passenger_num, return_passenger_list(purchase_id) as passenger_list
    FROM
        purchases NATURAL JOIN ticket NATURAL JOIN flight
	WHERE purchases.customer_email = username
    GROUP BY purchases.purchase_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_date_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_date_report`(staffID VARCHAR(50),startDate VARCHAR(20),endDate VARCHAR(20))
BEGIN
    DECLARE airline VARCHAR(50);

    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT count(ticket_id) as ticket_number
	FROM purchases NATURAL JOIN ticket
    WHERE airline_name=airline AND purchase_date between startDate and endDate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_date_spending` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_date_spending`(customerID VARCHAR(50),startDate VARCHAR(10),endDate VARCHAR(10))
BEGIN
    SELECT sum(price) as spending
	FROM purchases NATURAL JOIN ticket NATURAL JOIN flight
    WHERE customer_email = customerID AND purchase_date between startDate and endDate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_flight_by_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_flight_by_customer`(staffID int,customerid VARCHAR(50))
BEGIN
    DECLARE airline VARCHAR(50);
    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city,
    departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,price
	FROM flight NATURAL JOIN purchases NATURAL JOIN ticket
    WHERE
        airline_name = airline AND customer_email = customerid
	GROUP BY purchase_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_month_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_month_report`(staffID VARCHAR(50),startMonth VARCHAR(10),endMonth VARCHAR(10))
BEGIN
    DECLARE airline VARCHAR(50);

    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT DATE_FORMAT(purchase_date,'%Y-%m') as month,count(ticket_id) as ticket_number
	FROM purchases NATURAL JOIN ticket
    WHERE airline_name=airline AND DATE_FORMAT(purchase_date,'%Y-%m')>=startMonth AND DATE_FORMAT(purchase_date,'%Y-%m')<=endMonth
    GROUP BY DATE_FORMAT(purchase_date,'%Y-%m');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_month_spending` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_month_spending`(customerID VARCHAR(50),startMonth VARCHAR(10),endMonth VARCHAR(10))
BEGIN
    SELECT DATE_FORMAT(purchase_date,'%Y-%m') as month,sum(price) as spending
	FROM purchases NATURAL JOIN ticket NATURAL JOIN flight
    WHERE customer_email = customerID AND DATE_FORMAT(purchase_date,'%Y-%m')>=startMonth AND DATE_FORMAT(purchase_date,'%Y-%m')<=endMonth
    GROUP BY DATE_FORMAT(purchase_date,'%Y-%m');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_passengers_by_flight` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_passengers_by_flight`(staffID VARCHAR(50),flight_number int)
BEGIN
    DECLARE airline VARCHAR(50);

    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT passenger_name,passenger_id,passenger_phone
    FROM ticket
    WHERE (airline_name,flight_num) = (airline,flight_number);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_commission_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_top_commission_agent`(staffID VARCHAR(50),days int)
BEGIN
    DECLARE airline VARCHAR(50);

    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT booking_agent_id,sum(price)
    FROM purchases NATURAL JOIN ticket NATURAL JOIN flight
    WHERE booking_agent_id <> 0 AND airline_name = airline
    AND datediff(DATE(now()),purchase_date) between 0 and days
    GROUP BY booking_agent_id
    ORDER BY sum(price) DESC
    LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_commission_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_top_commission_customer`(agentID int)
BEGIN
    SELECT customer_email, 0.1*sum(price) as total_commission
    FROM purchases NATURAL JOIN ticket NATURAL JOIN flight
    WHERE booking_agent_id = agentID
    AND datediff(DATE(now()),DATE(purchase_date)) <= 180
    GROUP BY customer_email
    ORDER BY sum(price) DESC
    LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_top_customer`(agentID int)
BEGIN
    SELECT customer_email, count(ticket_id)
    FROM purchases
    WHERE booking_agent_id = agentID
    AND datediff(DATE(now()),DATE(purchase_date)) <= 180
    GROUP BY customer_email
    ORDER BY count(ticket_id) DESC
    LIMIT 5;

    SELECT customer_email, sum(price)
    FROM purchases NATURAL JOIN ticket NATURAL JOIN flight
    WHERE booking_agent_id = agentID
    AND datediff(DATE(now()),DATE(purchase_date)) <= 180
    GROUP BY customer_email
    ORDER BY sum(price) DESC
    LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_destinations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_top_destinations`(days int,number int)
BEGIN
    SELECT airport_city,count(ticket_id)
    FROM flight  NATURAL JOIN ticket JOIN airport on arrival_airport = airport.airport_name
    WHERE datediff(DATE(now()),DATE(departure_time)) <= days
    GROUP BY airport_city
    ORDER BY count(ticket_id) DESC
    LIMIT number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_ticket_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_top_ticket_agent`(staffID VARCHAR(50),days int)
BEGIN
    DECLARE airline VARCHAR(50);

    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT booking_agent_id,count(ticket_id)
    FROM purchases NATURAL JOIN ticket
    WHERE booking_agent_id <> 0 AND airline_name = airline
    AND datediff(DATE(now()),purchase_date) between 0 and days
    GROUP BY booking_agent_id
    ORDER BY count(ticket_id) DESC
    LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_ticket_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `get_top_ticket_customer`(agentID VARCHAR(50))
BEGIN
    SELECT customer_email, count(ticket_id) as count
    FROM purchases
    WHERE booking_agent_id = agentID
    AND datediff(DATE(now()),DATE(purchase_date)) <= 180
    GROUP BY customer_email
    ORDER BY count(ticket_id) DESC
    LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_ticket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `insert_ticket`(
				IN customer_email VARCHAR(50),
				IN booking_agent_id INT,
				IN passenger_names VARCHAR(300),
				IN passenger_ids VARCHAR(100),
				IN passenger_phones VARCHAR(100),
				IN flight_num INT,
				IN airline_name VARCHAR(50)
)
BEGIN

		DECLARE passenger_id VARCHAR(32);
		DECLARE passenger_name VARCHAR(32);
		DECLARE passenger_phone BIGINT;
		DECLARE avail_space INT;
		DECLARE nameLen INT;
		DECLARE idLen INT;
		DECLARE phoneLen INT;
		DECLARE newTicketId INT;
		DECLARE newPurchId INT;
		DECLARE sub_name_len INT;
		DECLARE sub_id_len INT;
		DECLARE sub_phone_len INT;
        DECLARE msg VARCHAR(10);
        DECLARE code INT;
		SET SQL_SAFE_UPDATES = 0;
-- 		remove space from input string if any
		set passenger_ids = REPLACE(passenger_ids,' ','');
		SET passenger_phones = REPLACE(passenger_phones, ' ','');
		SET newPurchId = next_purchase_id();

this_proc:BEGIN


		addTicket: LOOP

			SET nameLen = LENGTH(passenger_names);
			SET idLen = LENGTH(passenger_ids);
			SET phoneLen = LENGTH(passenger_phones);

			START TRANSACTION;
			SET avail_space = query_avail_space(flight_num, airline_name);
			SET passenger_name = SUBSTRING_INDEX(passenger_names,',',1);
			SET passenger_id = SUBSTRING_INDEX(passenger_ids,',',1);
			SET passenger_phone = CONVERT(SUBSTRING_INDEX(passenger_phones,',',1),UNSIGNED);

			IF avail_space = 0 THEN
					SET msg="already sold out!" ;
                    SET code = -1;
					LEAVE this_proc;
			ELSE
					insert into ticket (`status`,airline_name,flight_num,passenger_name,passenger_id,passenger_phone)
					 VALUES (0,airline_name,flight_num,passenger_name,passenger_id,passenger_phone);

					SET newTicketId = LAST_INSERT_ID();

					insert into purchases (`ticket_id`,`purchase_id`,`customer_email`,`booking_agent_id`) VALUES (newTicketId, newPurchId, customer_email, booking_agent_id);


			END IF;
			COMMIT;


			set sub_name_len = LENGTH(SUBSTRING_INDEX(passenger_names,',',1));
			set passenger_names = MID(passenger_names,sub_name_len+2,nameLen);

			set sub_id_len = LENGTH(SUBSTRING_INDEX(passenger_ids,',',1));
			set passenger_ids = MID(passenger_ids, sub_id_len+2,idLen);

			set sub_phone_len = LENGTH(SUBSTRING_INDEX(passenger_phones,',',1));
			set passenger_phones = MID(passenger_phones, sub_phone_len+2, phoneLen);


			IF passenger_ids = '' THEN
					LEAVE addTicket;
			END IF;

		END LOOP addTicket;
		SET msg = "finished!";
        SET code = 0;
END;
    SELECT msg,code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `login_check` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `login_check`(
	IN `type` VARCHAR(10),
    IN `username_arg` VARCHAR(50),
    IN `password_arg` VARCHAR(50),
    OUT msg VARCHAR(32),
	OUT `code` INT
)
login_check:BEGIN
	DECLARE result int;

	if `type` = 'agent' THEN
		select EXISTS (SELECT email, `password` from booking_agent WHERE (email,`password`) = (`username_arg`,`password_arg`)) INTO result;
		IF result = 0 THEN
			set msg = "agent does not exist";
            set `code` = -1;
            leave login_check;
		ELSE
			set msg = "correct info";
            set `code` = 0;
            leave login_check;
		END IF;
    END IF;

    IF `type` = 'customer' THEN
		select EXISTS (SELECT email, `password` from customer WHERE (email,`password`) = (`username_arg`,`password_arg`)) INTO result;
		IF result = 0 THEN
			set msg = "customer does not exist";
			set `code` = -1;

            leave login_check;
		ELSE
			set msg = 'correct info';
            set `code` = 0;
            leave login_check;
		END IF;

    END IF;

	IF `type` = 'staff' THEN
		select EXISTS (SELECT username, `password` from airline_staff WHERE (username,`password`) = (`username_arg`,`password_arg`)) INTO result;
		IF result = 0 THEN
			set msg = "staff does not exist";
			set `code` = -1;

            leave login_check;
		ELSE
			set msg = 'correct info';
            set `code` = 0;
            leave login_check;
		END IF;

    END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `most_frequent_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `most_frequent_customer`(staffID VARCHAR(50))
BEGIN
    DECLARE airline VARCHAR(50);
    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT customer_email, count(ticket_id) as number
    FROM purchases NATURAL JOIN ticket
    WHERE airline_name = airline
    GROUP BY customer_email
    ORDER BY count(DISTINCT purchase_id) DESC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `revenue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `revenue`(days int,staffID VARCHAR(50))
BEGIN
    DECLARE airline VARCHAR(50);
    DECLARE customer_num_ticket int;
    DECLARE agent_num_ticket int;
    SELECT airline_name INTO airline
    FROM airline_staff
    WHERE username = staffID;

    SELECT sum(price) INTO customer_num_ticket
    FROM ticket NATURAL JOIN purchases NATURAL JOIN flight
    WHERE booking_agent_id = 0 and airline_name = airline and datediff(DATE(now()),DATE(purchase_date))<=days;

    SELECT sum(0.9*price) INTO agent_num_ticket
    FROM ticket NATURAL JOIN purchases NATURAL JOIN flight
    WHERE  booking_agent_id <> 0 and airline_name = airline and datediff(DATE(now()),DATE(purchase_date))<=days;

    SELECT customer_num_ticket, agent_num_ticket;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `search_by_city` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `search_by_city`(depart_city VARCHAR(50),arrival_city VARCHAR(50), departure_date date)
BEGIN
    (SELECT
        airline_name, flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price as char(10)) as price
    FROM
        flight
        JOIN airport a1 ON flight.departure_airport = a1.airport_name
        JOIN airport a2 ON flight.arrival_airport = a2.airport_name
    WHERE
		depart_city like CONCAT('%',a1.airport_city,'%')
        AND arrival_city like CONCAT('%',a2.airport_city,'%')
        AND DATE(flight.departure_time) = departure_date)
	UNION
    (SELECT
        airline_name, flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price as char(10)) as price
    FROM
        flight
        JOIN airport a2 ON flight.arrival_airport = a2.airport_name
    WHERE
		depart_city like CONCAT('%',departure_airport,'%')
        AND arrival_city like CONCAT('%',a2.airport_city,'%')
        AND DATE(flight.departure_time) = departure_date)
	UNION
    (SELECT
        airline_name, flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price as char(10)) as price
    FROM
        flight
        JOIN airport a1 ON flight.departure_airport = a1.airport_name
    WHERE
		depart_city like CONCAT('%',a1.airport_city,'%')
        AND arrival_city like CONCAT('%',arrival_airport,'%')
        AND DATE(flight.departure_time) = departure_date)
	UNION
    (SELECT
        airline_name, flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price as char(10)) as price
    FROM
        flight
    WHERE
		depart_city like CONCAT('%',departure_airport,'%')
        AND arrival_city like CONCAT('%',arrival_airport,'%')
        AND DATE(flight.departure_time) = departure_date);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `search_by_num` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `search_by_num`(flightnum int, departure_date date)
BEGIN
    SELECT
        airline_name, flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price as char(10)) as price
    FROM
        flight
    WHERE
        flight_num = flightnum
        AND DATE(flight.departure_time) = departure_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `staff_view_flights` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`SE`@`%` PROCEDURE `staff_view_flights`(staffID VARCHAR(50), startDate VARCHAR(10), endDate VARCHAR(10))
BEGIN
    SELECT
        airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city,
        departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,
        status, price
    FROM
        flight NATURAL JOIN airline_staff
	WHERE username = staffID
    AND departure_time >= startDate and departure_time <= endDate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-12-15 21:44:18
