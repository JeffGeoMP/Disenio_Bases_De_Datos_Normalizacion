USE Proyecto2;

/*
-------------------------- CONSULTA NO. 1 --------------------------------------
Desplegar para cada elección el país y el partido político que obtuvo 
mayor porcentaje de votos en su país. Debe desplegar el nombre de la elección, 
el año de la elección, el país, el nombre del partido político y el porcentaje
que obtuvo de votos en su país.
*/
SELECT 
	e.nombre AS Eleccion, 
    e.año AS Año, 
    p.nombre AS Pais, 
    pt.nombre AS Partido,
    calculo_porcentaje(SUM(analfabetos + alfabetos), (SELECT SUM(analfabetos + alfabetos) FROM detalle_eleccion de2
															INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
															INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
															WHERE z2.id_pais = p.id_pais)) AS Porcentaje
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN partido pt ON de.id_partido = pt.id_partido
GROUP BY e.nombre, e.año, p.nombre, pt.nombre
HAVING Porcentaje = (SELECT MAX(tp.Porcentaje) AS Porcentaje_Maximo FROM (
	SELECT calculo_porcentaje (SUM(analfabetos + alfabetos), (SELECT SUM(analfabetos + alfabetos) FROM detalle_eleccion de3
																INNER JOIN eleccion e3 ON de3.id_eleccion = e3.id_eleccion
																INNER JOIN zona z3 ON e3.id_zona = z3.id_zona
                                                                INNER JOIN pais p3 ON z3.id_pais = p3.id_pais
																WHERE p3.nombre = Pais)) AS Porcentaje
	FROM detalle_eleccion de4
	INNER JOIN eleccion e4 ON de4.id_eleccion = e4.id_eleccion
	INNER JOIN zona z4 ON e4.id_zona = z4.id_zona
	INNER JOIN pais p4 ON z4.id_pais = p4.id_pais
    WHERE p4.nombre = Pais
	GROUP by e4.nombre, z4.id_pais, de4.id_partido) tp);

/*
-------------------------- CONSULTA NO. 2 --------------------------------------
Desplegar total de votos y porcentaje de votos de mujeres por departamento y país.
El ciento por ciento es el total de votos de mujeres por país. (Tip: Todos los
porcentajes por departamento de un país deben sumar el 100%)
*/
-- Total de Votos con Porcentaje
SELECT p.nombre AS Pais, 
	   d.nombre AS Departamento, 
       SUM(analfabetos + alfabetos) AS Votos,
       calculo_porcentaje(SUM(analfabetos + alfabetos), (SELECT SUM(analfabetos + alfabetos) AS Total 
																						FROM detalle_eleccion de2
																						INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_zona
																						INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
																						WHERE de2.sexo = 'mujeres' AND z2.id_pais = z.id_pais)) AS Porcentaje 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_zona
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
WHERE de.sexo = 'mujeres' 
GROUP BY z.id_pais, z.id_departamento;

/*
-------------------------- CONSULTA NO. 3 --------------------------------------
Desplegar el nombre del país, nombre del partido político y número de alcaldías de
los partidos políticos que ganaron más alcaldías por país.
*/

SELECT p.nombre AS Pais,
	   pt.nombre AS Partido,
       COUNT(td2.Partido) AS Alcaldias
FROM (SELECT  z.id_zona AS Zona,
				z.id_pais AS Pais,
				z.id_municipio AS Municipio,
				de.id_partido AS Partido, 
				SUM((de.alfabetos + de.analfabetos)) AS Votos
		FROM detalle_eleccion de
		INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
		INNER JOIN zona z ON e.id_zona = z.id_zona
		GROUP BY z.id_zona, de.id_partido
		HAVING Votos = (SELECT MAX(td1.votos) FROM(SELECT z2.id_pais, z2.id_municipio, de2.id_partido, SUM((de2.alfabetos + de2.analfabetos)) AS Votos
									FROM detalle_eleccion de2
									INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
									INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
									WHERE z2.id_zona = Zona
									GROUP BY z2.id_zona, de2.id_partido) td1)) td2
INNER JOIN Pais p ON td2.Pais = p.id_pais
INNER JOIN Partido pt On td2.Partido = pt.id_partido
GROUP BY td2.Pais, td2.Partido
HAVING Alcaldias = (SELECT MAX(Alcaldias3) FROM (SELECT td2.Pais2 AS Pais3,
							   td2.Partido2 AS Partido3,
							   COUNT(td2.Partido2) AS Alcaldias3
						FROM (SELECT  z.id_zona AS Zona2,
										z.id_pais AS Pais2,
										z.id_municipio AS Municipio2,
										de.id_partido AS Partido2, 
										SUM((de.alfabetos + de.analfabetos)) AS Votos
								FROM detalle_eleccion de
								INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
								INNER JOIN zona z ON e.id_zona = z.id_zona
								GROUP BY z.id_zona, de.id_partido
								HAVING Votos = (SELECT MAX(td1.votos) FROM(SELECT z2.id_pais, z2.id_municipio, de2.id_partido, SUM((de2.alfabetos + de2.analfabetos)) AS Votos
															FROM detalle_eleccion de2
															INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
															INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
															WHERE z2.id_zona = Zona2
															GROUP BY z2.id_zona, de2.id_partido) td1)) td2
						GROUP BY td2.Pais2, td2.Partido2) td3
						WHERE Pais3 = Pais);

/*
-------------------------- CONSULTA NO. 4 --------------------------------------
Desplegar todas las regiones por país en las que predomina la raza indígena. 
Es decir, hay más votos que las otras razas.
*/
SELECT p.nombre AS Pais,
		d.region AS Region,
        r.nombre AS Raza,
        SUM(de.analfabetos + de.alfabetos) AS Votos 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN raza r ON de.id_raza = r.id_raza
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
GROUP BY z.id_pais, d.region, de.id_raza
HAVING Votos = (SELECT MAX(td1.Votos) FROM (SELECT SUM(de2.analfabetos + de2.alfabetos) AS Votos 
						FROM detalle_eleccion de2
						INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
						INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
						INNER JOIN raza r2 ON de2.id_raza = r2.id_raza
						INNER JOIN departamento d2 ON z2.id_departamento = d2.id_departamento
						WHERE z2.id_pais = z.id_pais AND d2.region = d.region
						GROUP BY z2.id_pais, d2.region, de2.id_raza) td1) AND
		r.nombre = 'INDIGENAS';

/*
-------------------------- CONSULTA NO. 5 --------------------------------------
Desplegar el nombre del país, el departamento, el municipio, el partido político y
la cantidad de votos universitarios de todos aquellos partidos políticos que 
obtuvieron una cantidad de votos de universitarios mayor que el 25% de votos 
de primaria y menor que el 30% de votos de nivel medio 
(correspondiente a ese municipio y al partido político).  
Ordene sus resultados de mayor a menor.
*/
SELECT p.nombre,
		d.nombre, 
		m.nombre,
        pt.nombre,
        (SUM(primaria) * 0.25) AS Primaria_25P,
        (SUM(media) * 0.30) AS Media_30P,
        SUM(universitario) AS Votos_Universitarios
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
INNER JOIN municipio m ON z.id_municipio = m.id_municipio
INNER JOIN partido pt ON de.id_partido = pt.id_partido
GROUP BY z.id_municipio, de.id_partido
HAVING Votos_Universitarios>Primaria_25P AND Votos_Universitarios<Media_30P
ORDER BY Votos_Universitarios DESC;

/*
-------------------------- CONSULTA NO. 6 --------------------------------------
Desplegar el porcentaje de mujeres universitarias y hombres universitarios que 
votaron por departamento, donde las mujeres universitarias que votaron fueron más 
que los hombres universitarios que votaron.
*/
SELECT d5.nombre AS Departamento,
		td1.Porcentaje_Votos_Mujeres,
        td1.Porcentaje_Votos_Hombres
        FROM (SELECT z.id_pais AS Pais,
							z.id_departamento AS Departamento,
							calculo_porcentaje((SELECT SUM(de2.universitario) FROM detalle_eleccion de2
								INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
								INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
								WHERE de2.sexo = 'mujeres' AND z2.id_pais = Pais AND z2.id_departamento = Departamento
								GROUP BY z2.id_pais, z2.id_departamento), SUM(universitario)) AS Porcentaje_Votos_Mujeres,		
							calculo_porcentaje((SELECT SUM(de3.universitario) AS Votos_Hombres
								FROM detalle_eleccion de3
								INNER JOIN eleccion e3 ON de3.id_eleccion = e3.id_eleccion
								INNER JOIN zona z3 ON e3.id_zona = z3.id_zona
								WHERE de3.sexo = 'hombres' AND z3.id_pais = Pais AND z3.id_departamento = Departamento
								GROUP BY z3.id_pais, z3.id_departamento),SUM(universitario)) AS Porcentaje_Votos_Hombres
					FROM detalle_eleccion de
					INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
					INNER JOIN zona z ON e.id_zona = z.id_zona
					GROUP  BY z.id_pais, z.id_departamento
					HAVING Porcentaje_Votos_Mujeres>Porcentaje_Votos_Hombres) td1
INNER JOIN departamento d5 ON td1.Departamento = d5.id_departamento;

/*
-------------------------- CONSULTA NO. 7 --------------------------------------
Desplegar el nombre del país, la región y el promedio de votos por departamento. 
Por ejemplo: si la región tiene tres departamentos, se debe sumar todos los votos 
de la región y dividirlo dentro de tres (número de departamentos de la región).
*/
SELECT p.nombre AS Pais, d.region, SUM(de.analfabetos + de.alfabetos)/(SELECT COUNT(*) FROM (SELECT DISTINCT z2.id_pais, d2.region, z2.id_departamento FROM zona z2
						INNER JOIN departamento d2 ON z2.id_departamento = d2.id_departamento
						WHERE z2.id_pais = z.id_pais AND d2.region = d.region) td1) AS Promedio
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
INNER JOIN pais p ON z.id_pais = p.id_pais
GROUP BY z.id_pais, d.region
ORDER BY p.nombre, d.region;

/*
-------------------------- CONSULTA NO. 8 --------------------------------------
Desplegar el nombre del municipio y el nombre de los dos partidos políticos con 
más votos en el municipio, ordenados por país.
*/
SELECT p.nombre AS Pais,
        m.nombre AS Municipio,
        pt.nombre AS Partido,
        td2.Votos
FROM(SELECT *, RANK() OVER (PARTITION BY td1.Municipio ORDER BY td1.Votos DESC) Ranking
	FROM (SELECT z.id_pais AS Pais,
			z.id_departamento AS Departamento,
			z.id_municipio AS Municipio,
			de.id_partido AS Partido,
			SUM(analfabetos + alfabetos) AS Votos 
			FROM detalle_eleccion de
			INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
			INNER JOIN zona z ON e.id_zona = z.id_zona
			GROUP BY z.id_zona, de.id_partido) td1) td2
INNER JOIN pais p ON td2.Pais = p.id_pais
INNER JOIN departamento d ON td2.Departamento = d.id_departamento
INNER JOIN municipio m ON td2.Municipio = m.id_municipio
INNER JOIN partido pt ON td2.Partido = pt.id_partido
WHERE td2.Ranking <= 2
ORDER BY p.nombre, m.nombre;
/*

-------------------------- CONSULTA NO. 9 --------------------------------------
Desplegar el total de votos de cada nivel de escolaridad (primario, medio, universitario) 
por país, sin importar raza o sexo.
*/
SELECT p.nombre AS Pais,
		SUM(de.primaria) AS Votos_Primaria,
        SUM(de.media) AS Votos_Media,
        SUM(de.universitario) AS Votos_Universitario
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
GROUP BY z.id_pais;
/*

-------------------------- CONSULTA NO. 10 -------------------------------------
Desplegar el nombre del país y el porcentaje de votos por raza.
*/
SELECT p.nombre AS Pais,
	r.nombre AS Raza,
    calculo_porcentaje(SUM(de.analfabetos + de.alfabetos), (SELECT SUM(de2.analfabetos + de2.alfabetos) 
															FROM detalle_eleccion de2
															INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
															INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
															WHERE z2.id_pais = z.id_pais
															GROUP BY z2.id_pais)) AS PORCENTAJE
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN raza r ON de.id_raza = r.id_raza
GROUP BY z.id_pais, de.id_raza;

/*
-------------------------- CONSULTA NO. 11 -------------------------------------
Desplegar el nombre del país en el cual las elecciones han sido más peleadas. 
Para determinar esto se debe calcular la diferencia de porcentajes de votos entre 
el partido que obtuvo más votos y el partido que obtuvo menos votos.
*/
SELECT p.nombre AS Pais,
		(td3.Votos_Maximo - td3.Votos_Minimo) AS Diferencia
FROM(SELECT z.id_pais AS Pais, 
			(SELECT MAX(td1.Votos_MAX) AS Votos_Maximo 
				FROM(SELECT SUM(de2.analfabetos + de2.alfabetos) AS Votos_MAX
					FROM detalle_eleccion de2
					INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
					INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
					WHERE z2.id_pais = z.id_pais
					GROUP BY z2.id_pais, de2.id_partido) td1) AS Votos_Maximo,
			(SELECT MIN(td2.Votos_MIN) AS Votos_Minimo 
				FROM(SELECT SUM(de3.analfabetos + de3.alfabetos) AS Votos_MIN
					FROM detalle_eleccion de3
					INNER JOIN eleccion e3 ON de3.id_eleccion = e3.id_eleccion
					INNER JOIN zona z3 ON e3.id_zona = z3.id_zona
					WHERE z3.id_pais = z.id_pais
					GROUP BY z3.id_pais, de3.id_partido) td2) AS Votos_Minimo
	FROM detalle_eleccion de
	INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
	INNER JOIN zona z ON e.id_zona = z.id_zona
	GROUP BY z.id_pais) td3
    INNER JOIN pais p ON td3.Pais = p.id_pais
    HAVING Diferencia = (SELECT MIN(td4.Diferencia) 
FROM(SELECT td3.Pais,
			(td3.Votos_Maximo - td3.Votos_Minimo) AS Diferencia
	FROM(SELECT z.id_pais AS Pais, 
				(SELECT MAX(td1.Votos_MAX) AS Votos_Maximo 
					FROM(SELECT SUM(de2.analfabetos + de2.alfabetos) AS Votos_MAX
						FROM detalle_eleccion de2
						INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
						INNER JOIN zona z2 ON e2.id_zona = z2.id_zona
						WHERE z2.id_pais = z.id_pais
						GROUP BY z2.id_pais, de2.id_partido) td1) AS Votos_Maximo,
				(SELECT MIN(td2.Votos_MIN) AS Votos_Minimo 
					FROM(SELECT SUM(de3.analfabetos + de3.alfabetos) AS Votos_MIN
						FROM detalle_eleccion de3
						INNER JOIN eleccion e3 ON de3.id_eleccion = e3.id_eleccion
						INNER JOIN zona z3 ON e3.id_zona = z3.id_zona
						WHERE z3.id_pais = z.id_pais
						GROUP BY z3.id_pais, de3.id_partido) td2) AS Votos_Minimo
		FROM detalle_eleccion de
		INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
		INNER JOIN zona z ON e.id_zona = z.id_zona
		GROUP BY z.id_pais) td3) td4);
/*
-------------------------- CONSULTA NO. 12 -------------------------------------
Desplegar el total de votos y el porcentaje de votos emitidos por mujeres 
indígenas alfabetas.
*/
SELECT e.nombre, e.año, SUM(analfabetos + alfabetos) AS Votos, calculo_porcentaje((SELECT SUM(de2.alfabetos) FROM detalle_eleccion de2
																					INNER JOIN eleccion e2 ON de2.id_eleccion = e2.id_eleccion
																					INNER JOIN raza r2 ON de2.id_raza = r2.id_raza
																					WHERE de2.sexo = 'mujeres' AND r2.nombre = 'INDIGENAS' AND e2.año = e.año
																					GROUP BY e2.nombre, e2.año),(SUM(analfabetos + alfabetos))) AS Porcentaje 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
GROUP BY e.nombre, e.año;
/*
-------------------------- CONSULTA NO. 13 -------------------------------------
Desplegar el nombre del país, el porcentaje de votos de ese país en el que han 
votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre de país, 
el de mayor porcentaje).
*/

SELECT p.nombre AS Pais, calculo_porcentaje(SUM(de.analfabetos), SUM(de.analfabetos + alfabetos)) AS Porcentaje FROM detalle_eleccion de 
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
GROUP BY z.id_pais
HAVING Porcentaje = (SELECT MAX(td1.Porcentaje) 
					FROM (SELECT z.id_pais, calculo_porcentaje(SUM(de.analfabetos), SUM(de.analfabetos + alfabetos)) AS Porcentaje 
                    FROM detalle_eleccion de 
							INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
							INNER JOIN zona z ON e.id_zona = z.id_zona
							GROUP BY z.id_pais) td1);

/*
-------------------------- CONSULTA NO. 14 -------------------------------------
Desplegar la lista de departamentos de Guatemala y número de votos obtenidos, 
para los departamentos que obtuvieron más votos que el departamento de Guatemala.
*/
SELECT d.nombre AS Departamento,  SUM(de.analfabetos + de.alfabetos) AS Votos 
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN pais p ON z.id_pais = p.id_pais
INNER JOIN departamento d ON z.id_departamento = d.id_departamento
WHERE p.nombre = 'GUATEMALA'
GROUP BY z.id_pais, z.id_departamento
HAVING Votos > (SELECT SUM(de.analfabetos + de.alfabetos) FROM detalle_eleccion de
				INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
				INNER JOIN zona z ON e.id_zona = z.id_zona
				INNER JOIN pais p ON z.id_pais = p.id_pais
				INNER JOIN departamento d ON z.id_departamento = d.id_departamento
				WHERE p.nombre = 'GUATEMALA' AND d.nombre = 'GUATEMALA'
				GROUP BY z.id_pais, z.id_departamento);

/*
-------------------------- CONSULTA NO. 15 -------------------------------------
Desplegar el total de votos de los municipios agrupados por su letra inicial. 
Es decir, agrupar todos los municipios con letra A y calcular su número de votos, 
lo mismo para los de letra inicial B, y así sucesivamente hasta la Z.
*/
SELECT SUBSTRING(m.nombre,1,1) AS Letra,
		SUM(de.analfabetos + de.alfabetos) AS Votos
FROM detalle_eleccion de
INNER JOIN eleccion e ON de.id_eleccion = e.id_eleccion
INNER JOIN zona z ON e.id_zona = z.id_zona
INNER JOIN municipio m ON z.id_municipio = m.id_municipio
GROUP BY ASCII(SUBSTRING(m.nombre,1,1))
ORDER BY m.nombre;
