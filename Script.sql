CREATE SCHEMA `rockingdata` ;

use rockingdata;

CREATE TABLE `rockingdata`.`title` (
  `Title` VARCHAR(120) NOT NULL,
  `Release_Year` INT NULL,
  `Duration` int NULL,
  `Type` VARCHAR(45) NULL,
  `Rating` VARCHAR(45) NULL,
  `Listed_In` VARCHAR(1000) NULL,
  `Description` VARCHAR(1000) NULL,
  `Id_Title` INT NOT NULL,
  PRIMARY KEY (`Id_Title`));

LOAD DATA INFILE 'C:\\Users\\mariano\\Desktop\\Rocking data\\Tabla_Title.csv' 
INTO TABLE `title` 
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

select count(*) from title;

CREATE TABLE `Tabla_Carga`
(
 `Id_Carga`   integer NOT NULL ,
 `Date_Added` datetime  NULL ,
 `Plataform`  varchar(45) NOT NULL ,
 `Id_Title`   integer NOT NULL ,
 
 PRIMARY KEY (`Id_Carga`)
);

LOAD DATA INFILE 'C:\\Users\\mariano\\Desktop\\Rocking data\\Tabla_Carga.csv' 
INTO TABLE `Tabla_Carga` 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

CREATE TABLE `title_cast` (
  `Id_Title` int NOT NULL,
  `Id_Cast` varchar(45) NOT NULL
);

LOAD DATA INFILE 'C:\\Users\\mariano\\Desktop\\Rocking data\\Tabla_Title_Actor.csv' 
INTO TABLE `title_cast` 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

CREATE TABLE `cast` (
  `Cast` varchar(1000) DEFAULT NULL,
  `Id_Cast` int NOT NULL,
  
  PRIMARY KEY (`Id_Cast`)
);

LOAD DATA INFILE 'C:\\Users\\mariano\\Desktop\\Rocking data\\Tabla_Cast.csv' 
INTO TABLE `cast` 
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

/*
4. SQL
Responder en base al modelo de datos realizado en el punto anterior:
*/

/*
Considerando únicamente la plataforma de Netflix, ¿qué actor aparece 
más veces? */
Select c.Id_cast,
		c.Cast,
        count(t.Id_title) as Participaciones 
from title_cast t
join cast c
on c.Id_cast=t.Id_cast
where t.Id_title in (select Id_title 
					from tabla_carga
                    where Plataform ="Netflix")
group by c.Id_cast
order by Participaciones desc
limit 1;



/*- Top 10 de actores participantes considerando ambas plataformas en el 
año actual. Se aprecia flexibilidad.
*/

Select c.Id_cast,
		c.Cast, 
        count(t.Id_title) as Participaciones 
from title_cast t
join cast c
on c.Id_cast=t.Id_cast
where t.Id_title in (select Id_title 
					from tabla_carga
                    where Year(date_added) =2021
                    )
				
group by c.Id_cast
order by Participaciones desc
limit 10;

Select c.Id_cast,
		c.Cast, 
        count(t.Id_title) as Participaciones 
from title_cast t
join cast c
on c.Id_cast=t.Id_cast
where t.Id_title in (select Id_title 
					from tabla_carga
                    where Year(date_added) =2021
                    and Plataform ="Netflix"
                    and Id_title in (select Id_title from title
									where Type="movie"	))
group by c.Id_cast
order by Participaciones desc
limit 10;


				
/*- Crear un Stored Proceadure que tome como parámetro un año y 
devuelva una tabla con las 5 películas con mayor duración en minutos*/


delimiter !
create procedure TopPeli_Duracion(
  in v1 int)
	begin
		select Title , Duration from title
				where Id_title in (select Id_title 
										from tabla_carga
										where year(Date_added)= v1
                                        and type="movie")	
		order by Duration desc
		limit 5;
	end;!
delimiter ;

call TopPeli_Duracion(2008);
            
                    
                    

