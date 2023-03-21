--Creamos la tabla de aterrizaje donde estara el CSV

DROP TABLE stage

create temp table stage(
index int,
product varchar(35),
helpful_count varchar(35),	
total_comments	int,
url	varchar(150),
review_country	varchar(10),
reviewed_at	varchar(15),
review_text	varchar(10000),
review_rating	varchar(20),
product_company	varchar(10),
profile_name	varchar(100),
review_title	varchar(500),
Sentimientos	varchar(10),
Resultado   int
)
--Importador
copy stage from 'C:\datos_con_Resultado.csv' DELIMITER ',' CSV HEADER
select * from stage

--Analizando la data 

select count(*) from stage--El primer count nos da 5010 


--Identificando valores unicos por cada columna 
--Como vemos tenemos duplicados 
select count(profile_name) as cantidad,profile_name,review_text,helpful_count,
product,helpful_count,total_comments,url,review_country,reviewed_at,
review_rating,product_company,profile_name,review_title,Sentimientos,Resultado
from stage
group by profile_name,review_text,helpful_count,
product,helpful_count,total_comments,url,review_country,reviewed_at,
review_rating,product_company,profile_name,review_title,Sentimientos,Resultado
having count(profile_name)>1
order by cantidad,profile_name desc
--Tenemos 10 filas con duplicados , claro esta con duplicados pero el el unico dato diferente es le numero de la columna index , pero el resto de columnas es la misma 
--informacion en base a esto si que tenemos duplicados , asi que se le reporta al cliente si se dejan o eliminan, y esto cambiara un poco el total pero 
--vale la pena tenerlo en cuenta

--Ahora quitando los duplicados vemos los datos totales 
select * into stage2 from
	(
select count(profile_name) as cantidad,profile_name,review_text,helpful_count,
product,total_comments,url,review_country,reviewed_at,
review_rating,product_company,review_title,Sentimientos,Resultado
from stage
group by profile_name,review_text,
product,helpful_count,total_comments,url,review_country,reviewed_at,
review_rating,product_company,review_title,Sentimientos,Resultado
having count(profile_name)>=1
order by cantidad desc
) as a

select  index,profile_name,review_text,helpful_count,
product,helpful_count,total_comments,url,review_country,reviewed_at,
review_rating,product_company,profile_name,review_title,Sentimientos,Resultado
from stage


select count(*) from stage2 --5000

select count(*) from stage --5010


4992 dice en excel recuento
select distinct(index) from stage order by index desc
 
---en resumen no son 5010 registros a contemplar son 5000 quitando las filas duplicadas en contenido y creando una nueva columna de indice
--Sumado a ello debemos contemplar que afectaria el total de puntos por producto y duplicaria el dato real que se tiene de de helpful_count
--lo que cuando deseamos ver el alcance de persona ayudadas por el comentario segun usuario tendriamos difernete dato
--tambien el total comnetarios afectaria el dato , si deseamos saber la reseña mas cpmentada segun usuario.
--y si deseamos saber los cantidad de titulos diferentes o cantidad de apariciones por titulos de las reseñas tambien afecatria este dato 
--por eso como analista siempre es fundamental conteplar duplicados en los que respecta a la data asi tenga una columna index de referencia como este es el caso

