CREATE DATABASE llin_analysis;

USE llin_analysis;

CREATE TABLE llin_distributions(
    ID INT,
    Number_disributed INT,
    Location VARCHAR(255),
    Country VARCHAR(255),
	DATE INT,
    By_whom VARCHAR(255),
    Country_code VARCHAR(10)
);

SELECT
Country,
SUM(Number_disributed)AS total_llins
FROM llin_distributions
GROUP BY country;

SELECT 
AVG(Number_disributed) AS avarage_llins
FROM llin_distributions;

SELECT 
MIN(DATE) AS earliest_date,
MAX(DATE) AS latest_date
FROM llin_distributions;

SELECT 
By_whom,
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY By_whom;

SELECT
DATE_FORMAT(DATE,'%y') AS year_date,
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY year_date;

SELECT 
Location, 
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY Location
ORDER BY total_llins DESC
LIMIT 1;

SELECT 
Location, 
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY Location
ORDER BY total_llins ASC
LIMIT 1;

SELECT * FROM (
    SELECT *, 
           NTILE(4) OVER (ORDER BY Number_disributed) AS quartile
    FROM llin_distributions
) subquery
WHERE quartile = 1 OR quartile = 4;

SELECT * FROM llin_distributions
WHERE 
Number_disributed < (SELECT Number_disributed FROM llin_distributions ORDER BY Number_disributed LIMIT 1 )
   OR 
   Number_disributed > (SELECT Number_disributed FROM llin_distributions ORDER BY Number_disributed LIMIT 1 )
   ;

