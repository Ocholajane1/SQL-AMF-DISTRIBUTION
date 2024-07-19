-- Creating the database
CREATE DATABASE llin_analysis;

-- select the "llin_analysis" for use by the database
USE llin_analysis;

-- create the table to store distribution data
CREATE TABLE llin_distributions(        
    ID INT,                       -- shows ID of each distribution
    Number_disributed INT,        -- shows number of llins distributed   
    Location VARCHAR(255),        -- shows location of the delivery
    Country VARCHAR(255),         -- shows country of distribution 
    DATE INT,                     -- shows year of distribution
    By_whom VARCHAR(255),         -- shows organization of distribution
    Country_code VARCHAR(10)      -- shows country code for the distributions  
);

-- Descriptive Statistics
-- total number of LLINs distributed in each country
SELECT
Country,
SUM(Number_disributed)AS total_llins
FROM llin_distributions
GROUP BY country;

-- avarage number of LLINs distributed per distribution event
SELECT 
AVG(Number_disributed) AS avarage_llins
FROM llin_distributions;

-- earliest and latest distribution dates
SELECT 
MIN(DATE) AS earliest_date,                         -- shows earliest date
MAX(DATE) AS latest_date                            -- shows lattest date  
FROM llin_distributions;

-- TRENDS AND PATTERNS
-- total number of LLINs distributed by each organization
SELECT By_whom,                                     -- By_whom to sort which organization
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY By_whom;                                    -- group by type of organizattion

-- total number of LLINs distributed each year
SELECT
DATE_FORMAT(DATE,'%y') AS year_date,              -- Format date as 'YYYY' to group by year
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY year_date;                              -- group by year date    

-- VOLUME INSIGHTS
-- Location with the highest number of LLINs distributed
SELECT 
Location,
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY Location
ORDER BY total_llins DESC                          -- Order results by total_llins in descending order to get lowest value
LIMIT 1;

-- Location with the lowest number of LLINs distributed
SELECT 
Location, 
SUM(Number_disributed) AS total_llins
FROM llin_distributions
GROUP BY Location                           -- group by location
ORDER BY total_llins ASC                    -- Order results by total_llins in ascending order to get lowest value
LIMIT 1;

--  IDENTIFYING EXTREMES
-- Using quartiles to identify extremes (outliers)
-- This identifies the 1st and 4th quartile distributions
SELECT * FROM (
    SELECT *, 
           NTILE(4) OVER (ORDER BY Number_disributed) AS quartile                -- NTILE returns groups of two sizes with the difference of by one(partitions each category into approx. equal number of rows)
    FROM llin_distributions
) subquery
WHERE quartile = 1 OR quartile = 4;

-- Using IQR(interquartile range)/midspread method to identify outliers
-- IQR shows the spread of data of the number of LLINs distributed in specific locationws within different periods
SELECT * FROM llin_distributions
WHERE Number_disributed < (SELECT Number_disributed FROM llin_distributions ORDER BY Number_disributed LIMIT 1)
   OR Number_disributed > (SELECT Number_disributed FROM llin_distributions ORDER BY Number_disributed LIMIT 1)
;


