USE Proyecto2;

/* ------------- Verificaciones Iniciales ------------------
-- Extraemos la ruta preestablecida para cargar el archivo CSV,
-- con el siguiente comando, posteriormente copiamos nuestro archivo
-- csv a esta ruta.

SHOW VARIABLES LIKE "secure_file_priv";
--------------------------------------------------------------*/

/*------------ Creamos La tabla que contendra la Informacion del Archivo CSV ------------*/
DROP TABLE IF EXISTS data_temporal;

CREATE TEMPORARY TABLE data_temporal (
NOMBRE_ELECCION		VARCHAR(50),
AÑO_ELECCION		YEAR,
PAIS				VARCHAR(50),
REGION				VARCHAR(50),
DEPTO				VARCHAR(50),
MUNICIPIO			VARCHAR(50),
PARTIDO				VARCHAR(10),
NOMBRE_PARTIDO		VARCHAR(50),
SEXO				VARCHAR(10),
RAZA				VARCHAR(15),
ANALFABETOS			INT,
ALFABETOS			INT,
PRIMARIA			INT,
NIVEL_MEDIO			INT,
UNIVERSITARIOS		INT
);
/*----------------------------------------------------------------------------------------*/

/*-------------------- Carga Masiva de Datos a partir del CSV ----------------------------*/
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ICE-FUENTE.csv'
INTO TABLE Proyecto2.data_temporal
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
/*----------------------------------------------------------------------------------------*/