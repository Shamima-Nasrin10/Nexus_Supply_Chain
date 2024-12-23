-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: supply_chain
-- ------------------------------------------------------
-- Server version	8.0.37

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
-- Table structure for table `acc_procurement`
--

DROP TABLE IF EXISTS `acc_procurement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acc_procurement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `procurement_date` datetime(6) DEFAULT NULL,
  `quantity` int NOT NULL,
  `status` enum('APPROVED','PENDING','REJECTED') DEFAULT NULL,
  `total_price` double NOT NULL,
  `unit_price` double NOT NULL,
  `raw_material_id` bigint DEFAULT NULL,
  `supplier_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKaj2xg3vtn3tt6kbtot1m7rfy6` (`raw_material_id`),
  KEY `FKapesypeqyydv03wel16g22rp8` (`supplier_id`),
  CONSTRAINT `FKaj2xg3vtn3tt6kbtot1m7rfy6` FOREIGN KEY (`raw_material_id`) REFERENCES `inv_raw_materials` (`id`),
  CONSTRAINT `FKapesypeqyydv03wel16g22rp8` FOREIGN KEY (`supplier_id`) REFERENCES `inv_raw_material_suppliers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acc_procurement`
--

LOCK TABLES `acc_procurement` WRITE;
/*!40000 ALTER TABLE `acc_procurement` DISABLE KEYS */;
INSERT INTO `acc_procurement` VALUES (2,'2024-11-13 21:10:54.439000',6,'APPROVED',36,6,3,NULL),(5,'2024-11-18 06:00:00.000000',20,'APPROVED',1000,50,8,2),(6,'2024-11-18 06:00:00.000000',200,'APPROVED',3000,15,7,4),(7,'2024-11-19 06:00:00.000000',215,'APPROVED',3440,16,9,2),(8,'2024-11-20 06:00:00.000000',159,'APPROVED',3021,19,11,3),(9,'2024-11-23 06:00:00.000000',500,'APPROVED',5000,10,10,6),(10,'2024-11-23 06:00:00.000000',150,'APPROVED',1650,11,12,3);
/*!40000 ALTER TABLE `acc_procurement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `acc_sales`
--

DROP TABLE IF EXISTS `acc_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acc_sales` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `sales_date` datetime(6) DEFAULT NULL,
  `status` enum('APPROVED','PENDING','REJECTED') DEFAULT NULL,
  `total_price` double NOT NULL,
  `unit_price` double NOT NULL,
  `retailer_id` bigint DEFAULT NULL,
  `production_product_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKmlmlpe0dcyptkkvndqjk4kdpc` (`retailer_id`),
  KEY `FKej9bacq69eeqmkxdkxo41m9xc` (`production_product_id`),
  CONSTRAINT `FKej9bacq69eeqmkxdkxo41m9xc` FOREIGN KEY (`production_product_id`) REFERENCES `production_product` (`id`),
  CONSTRAINT `FKmlmlpe0dcyptkkvndqjk4kdpc` FOREIGN KEY (`retailer_id`) REFERENCES `product_retailers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acc_sales`
--

LOCK TABLES `acc_sales` WRITE;
/*!40000 ALTER TABLE `acc_sales` DISABLE KEYS */;
INSERT INTO `acc_sales` VALUES (1,1,'2024-11-21 06:00:00.000000','APPROVED',1,1,2,6),(2,11,'2024-11-24 06:00:00.000000','APPROVED',121,11,5,7);
/*!40000 ALTER TABLE `acc_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_raw_material_categories`
--

DROP TABLE IF EXISTS `inv_raw_material_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_raw_material_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_raw_material_categories`
--

LOCK TABLES `inv_raw_material_categories` WRITE;
/*!40000 ALTER TABLE `inv_raw_material_categories` DISABLE KEYS */;
INSERT INTO `inv_raw_material_categories` VALUES (1,'Fruit'),(2,'Utensils'),(3,'Sweetener'),(4,'Artificial Flavour'),(5,'Edible Acid'),(6,'Water');
/*!40000 ALTER TABLE `inv_raw_material_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_raw_material_suppliers`
--

DROP TABLE IF EXISTS `inv_raw_material_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_raw_material_suppliers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `cell_no` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_raw_material_suppliers`
--

LOCK TABLES `inv_raw_material_suppliers` WRITE;
/*!40000 ALTER TABLE `inv_raw_material_suppliers` DISABLE KEYS */;
INSERT INTO `inv_raw_material_suppliers` VALUES (2,'Khulna','0198765432','Express Supply Ltd.','Mahbub','express@gmail.com'),(3,'Chittagong','017654321','Delta Supply Ltd.','Aminul','delta@gmail.com'),(4,'Kushtia, Bangladesh','01876543290','Helal Supply Ltd.','Shabab','helal@gmail.com'),(5,'Bagura, Bangladesh','01876543291','ABC Supply Ltd.','Abid Rahman','abc@gmail.com'),(6,'Chattogram, Bangladesh','01876543292','Khushi Suppliers','Sohana Saba','khushi@gmail.com'),(7,'Jessore, Bangladesh','01876543295','Sky Supply Ltd.','Akash Malik','sky@gmail.com');
/*!40000 ALTER TABLE `inv_raw_material_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_raw_materials`
--

DROP TABLE IF EXISTS `inv_raw_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_raw_materials` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `unit` enum('GRAM','KG','LITRE','PIECE') DEFAULT NULL,
  `category_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7vrisihocobnd30bonqijgaxt` (`category_id`),
  CONSTRAINT `FK7vrisihocobnd30bonqijgaxt` FOREIGN KEY (`category_id`) REFERENCES `inv_raw_material_categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_raw_materials`
--

LOCK TABLES `inv_raw_materials` WRITE;
/*!40000 ALTER TABLE `inv_raw_materials` DISABLE KEYS */;
INSERT INTO `inv_raw_materials` VALUES (3,'Sugar_fcdb578a-cf33-43da-aa1a-505bdc4d64e1.jpg','Sugar','KG',3),(6,'Orange_d25c46ca-372d-4d36-850d-4acbe0e62d10.jpg','Orange','KG',1),(7,'Papaya_3a8679f5-6eea-435b-bdf3-99929587fd4c.jpg','Papaya','KG',1),(8,'Flavour_ac01c6db-19e5-4048-9f39-04f27c2b0ae7.jpg','Flavour','LITRE',4),(9,'Bottle_c9a3a668-7d08-4a43-bf15-8380ae071349.jpg','Bottle','PIECE',2),(10,'Apple_fb83be28-9714-4101-98fe-d4edda12cc8c.jpg','Apple','KG',1),(11,'Preservative_5d6928c4-b148-48c0-bcba-4dd4365994c3.jpg','Preservative','LITRE',5),(12,'Pineapple_2d0c6924-402b-45c4-8316-d3c6aba05282.jpg','Pineapple','KG',1);
/*!40000 ALTER TABLE `inv_raw_materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `capacity` bigint NOT NULL,
  `created_date` datetime(6) DEFAULT NULL,
  `last_updated_date` datetime(6) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_order_items`
--

DROP TABLE IF EXISTS `prod_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6mv213fe9jfrranlcw9h035qm` (`order_id`),
  KEY `FKk36gdjqaarojy9tsg11g8ihkl` (`product_id`),
  CONSTRAINT `FK6mv213fe9jfrranlcw9h035qm` FOREIGN KEY (`order_id`) REFERENCES `prod_orders` (`id`),
  CONSTRAINT `FKk36gdjqaarojy9tsg11g8ihkl` FOREIGN KEY (`product_id`) REFERENCES `prod_products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_order_items`
--

LOCK TABLES `prod_order_items` WRITE;
/*!40000 ALTER TABLE `prod_order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `prod_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_orders`
--

DROP TABLE IF EXISTS `prod_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `expected_delivery_date` date DEFAULT NULL,
  `order_date` date NOT NULL,
  `order_status` enum('APPROVED','COMPLETED','PENDING','REJECTED') NOT NULL,
  `shipping_address` date NOT NULL,
  `customer_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsu8lrih4xdhx1wuv9v1bhf5a6` (`customer_id`),
  CONSTRAINT `FKsu8lrih4xdhx1wuv9v1bhf5a6` FOREIGN KEY (`customer_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_orders`
--

LOCK TABLES `prod_orders` WRITE;
/*!40000 ALTER TABLE `prod_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `prod_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_products`
--

DROP TABLE IF EXISTS `prod_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_products` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_products`
--

LOCK TABLES `prod_products` WRITE;
/*!40000 ALTER TABLE `prod_products` DISABLE KEYS */;
INSERT INTO `prod_products` VALUES (1,'Orange juice is a popular drink in many tropical countries. ','Orange Juice_5742a412-a4e9-4911-812e-8fec84b7e509.jpg','Orange Juice'),(2,'Apple juice is a popular drink in many tropical countries. ','Apple Juice_c3d70a09-72a9-4525-a58b-826af4caa18a.png','Apple Juice'),(3,'Papaya juice is a popular drink in many tropical countries. ','Papaya Juice_59891d9a-3669-4f5a-bc95-72a6c54a95ee.jpg','Papaya Juice');
/*!40000 ALTER TABLE `prod_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_retailers`
--

DROP TABLE IF EXISTS `product_retailers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_retailers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `cell_no` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_retailers`
--

LOCK TABLES `product_retailers` WRITE;
/*!40000 ALTER TABLE `product_retailers` DISABLE KEYS */;
INSERT INTO `product_retailers` VALUES (1,'Dhaka, Bangladesh','01865432340','ACI Logistics Limited','Mizanur Rahman','aci@gmail.com'),(2,'Chattogram, Bangladesh','01865432342','Smile Apparels Limited','Sadik khan','smile@gmail.com'),(3,'Khulna, Bangladesh','0186543239','Rahim Brothers Ltd.','Ashfaq Nipun','rahim@gmail.com'),(4,'Bagura, Bangladesh','0186543236','Aesthetic Retail Ltd.','Sayed Abdullah','aesthetic@gmail.com'),(5,'Barisal, Bangladesh','01865432349','Khan Brothers Ltd.','Rafiq Azad','khan@gmail.com'),(6,'Test, Bangladesh','0198765432','Test Retailers','Test','test@gmail.com');
/*!40000 ALTER TABLE `product_retailers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_product`
--

DROP TABLE IF EXISTS `production_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_number` bigint DEFAULT NULL,
  `completion_date` datetime(6) DEFAULT NULL,
  `moved_to_warehouse_date` datetime(6) DEFAULT NULL,
  `qr_code_path` varchar(255) DEFAULT NULL,
  `quantity` int NOT NULL,
  `status` enum('COMPLETED','IN_PROGRESS','MOVED_TO_WAREHOUSE') DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `warehouse_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKd5uw8guvvcdfg66d4fsvfw5y4` (`product_id`),
  KEY `FKdei1hip587x5kbjgg0c205qul` (`warehouse_id`),
  CONSTRAINT `FKd5uw8guvvcdfg66d4fsvfw5y4` FOREIGN KEY (`product_id`) REFERENCES `prod_products` (`id`),
  CONSTRAINT `FKdei1hip587x5kbjgg0c205qul` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_product`
--

LOCK TABLES `production_product` WRITE;
/*!40000 ALTER TABLE `production_product` DISABLE KEYS */;
INSERT INTO `production_product` VALUES (3,33,'2024-11-13 17:02:21.319000','2024-11-24 16:02:25.557000','src\\main\\resources\\static\\images\\qrcodes\\3_qrcode.png',3,'MOVED_TO_WAREHOUSE',1,4),(5,12345,'2024-11-18 18:15:34.116000','2024-11-18 18:15:46.602000','src\\main\\resources\\static\\images\\qrcodes\\5_qrcode.png',200,'MOVED_TO_WAREHOUSE',1,4),(6,123,'2024-11-21 17:02:36.326000','2024-11-21 17:02:42.061000','src\\main\\resources\\static\\images\\qrcodes\\6_qrcode.png',10,'MOVED_TO_WAREHOUSE',3,3),(7,1245,'2024-11-23 17:07:21.115000','2024-11-23 17:08:16.261000','src\\main\\resources\\static\\images\\qrcodes\\7_qrcode.png',79,'MOVED_TO_WAREHOUSE',2,4),(8,234,NULL,NULL,'src\\main\\resources\\static\\images\\qrcodes\\8_qrcode.png',111,'IN_PROGRESS',3,NULL);
/*!40000 ALTER TABLE `production_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rawmat_usage`
--

DROP TABLE IF EXISTS `rawmat_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rawmat_usage` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `production_product_id` bigint DEFAULT NULL,
  `rawmaterial_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKlntuyh5j7e49gffjd8wff263l` (`production_product_id`),
  KEY `FKsql4or33yj1djrw8peabmaixd` (`rawmaterial_id`),
  CONSTRAINT `FKlntuyh5j7e49gffjd8wff263l` FOREIGN KEY (`production_product_id`) REFERENCES `production_product` (`id`),
  CONSTRAINT `FKsql4or33yj1djrw8peabmaixd` FOREIGN KEY (`rawmaterial_id`) REFERENCES `inv_raw_materials` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rawmat_usage`
--

LOCK TABLES `rawmat_usage` WRITE;
/*!40000 ALTER TABLE `rawmat_usage` DISABLE KEYS */;
INSERT INTO `rawmat_usage` VALUES (4,1,5,3),(6,1,NULL,9),(7,1,NULL,7),(8,20,NULL,10),(9,15,NULL,9),(10,2,NULL,8),(11,2,NULL,3),(12,11,8,7),(13,2,8,9),(14,1,8,11),(15,1,8,8),(16,1,8,3);
/*!40000 ALTER TABLE `rawmat_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rawmaterialstock`
--

DROP TABLE IF EXISTS `rawmaterialstock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rawmaterialstock` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) DEFAULT NULL,
  `last_updated_date` datetime(6) DEFAULT NULL,
  `quantity` int NOT NULL,
  `rawmaterial_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKc5w8pq5lthioy0dfgqe2n7264` (`rawmaterial_id`),
  CONSTRAINT `FKc5w8pq5lthioy0dfgqe2n7264` FOREIGN KEY (`rawmaterial_id`) REFERENCES `inv_raw_materials` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rawmaterialstock`
--

LOCK TABLES `rawmaterialstock` WRITE;
/*!40000 ALTER TABLE `rawmaterialstock` DISABLE KEYS */;
INSERT INTO `rawmaterialstock` VALUES (2,'2024-11-13 15:13:32.717137','2024-11-23 18:52:32.257925',1,3),(5,'2024-11-19 16:02:20.696506','2024-11-23 18:52:32.107870',388,7),(6,'2024-11-19 16:17:22.454147','2024-11-23 18:52:32.154962',158,11),(7,'2024-11-19 16:17:39.830852','2024-11-23 18:52:32.150061',197,9),(8,'2024-11-23 16:56:32.557951','2024-11-23 17:07:08.254063',480,10),(9,'2024-11-23 16:57:07.067663','2024-11-23 18:52:32.158955',17,8),(10,'2024-11-23 18:34:02.966944','2024-11-23 18:34:02.966944',150,12);
/*!40000 ALTER TABLE `rawmaterialstock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retailers`
--

DROP TABLE IF EXISTS `retailers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retailers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address_line` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK9sh8a8x09n83j55tj12pta02o` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retailers`
--

LOCK TABLES `retailers` WRITE;
/*!40000 ALTER TABLE `retailers` DISABLE KEYS */;
/*!40000 ALTER TABLE `retailers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_logged_out` bit(1) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKe32ek7ixanakfqsdaokm4q9y2` (`user_id`),
  CONSTRAINT `FKe32ek7ixanakfqsdaokm4q9y2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cell` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_lock` bit(1) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKob8kqyqqgmefl0aco34akdtpe` (`email`),
  UNIQUE KEY `UK19ln9le9v947dp777koraktgy` (`cell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouses`
--

DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `location` varchar(255) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK2qm0l82n5ivhyqwmgejxxefm1` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouses`
--

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
INSERT INTO `warehouses` VALUES (2,'Dhaka, Bangladesh','Warehouse 1'),(3,'Chattogram, Bangladesh','Warehouse 2'),(4,'Naoga, Bangladesh','Warehouse 3');
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-27 18:23:56
