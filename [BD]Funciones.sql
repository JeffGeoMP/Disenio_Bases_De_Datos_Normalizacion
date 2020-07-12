USE Proyecto2;

DELIMITER $$
CREATE FUNCTION calculo_porcentaje (Dato INTEGER, Total INTEGER)
RETURNS FLOAT
DETERMINISTIC
BEGIN 
	DECLARE porcentaje FLOAT;
    SET porcentaje = Dato*100;
    SET porcentaje = porcentaje/Total;
RETURN porcentaje;
END $$