USE Proyecto2;

/* ------------- Verificaciones Iniciales ------------------
-- Verificamos que la carga este activa
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Verificamos la ruta preestablecida para cargar el archivo CSV
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
SEXO2				VARCHAR(10),
RAZA2				VARCHAR (15),
PRIMARIA			INT,
NIVEL_MEDIO			INT,
UNIVERSITARIOS		INT
);
/*----------------------------------------------------------------------------------------*/

/*-------------------- Carga Masiva de Datos a partir del CSV ----------------------------*/
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ICE-Fuente.csv'
INTO TABLE Proyecto2.data_temporal
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
/*----------------------------------------------------------------------------------------*/