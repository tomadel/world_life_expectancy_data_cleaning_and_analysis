# World Life Expectancy Project (Data Cleaning)

SELECT  * 
FROM world_lifee_expectancy.world_life_expectancy;

#Check Duplicates
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

#Find the Row_ID of the duplicates by Window function
SELECT *
FROM
(
SELECT Row_ID,
CONCAT(Country, Year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS Row_Num
FROM world_life_expectancy
) AS Row_Table
WHERE Row_Num > 1;

#Delete the duplicates
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
	SELECT Row_ID
	FROM
(
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS Row_Num
	FROM world_life_expectancy
) 	AS Row_Table
WHERE Row_Num > 1
); 

#Check the empty rows in Status column
SELECT Country, Year, Status
FROM world_life_expectancy
WHERE Status = '';

#Select all the countries with status of developing
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

# Update all the developing countries' status data by using the previous filter
# and populate the missing data
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (
	SELECT DISTINCT(Country)
	FROM world_life_expectancy
	WHERE Status = 'Developing');
    
#update for the developing country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

#update for the developed country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

#Check the life expectancy for the missing data
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

#Since life expectancy is not linear and seemed is increasing,
# populating the missing data by takin average of the next and previous year's life expectancy
SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

#Update the missing values in the life expectancy column
UPDATE  world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
WHERE t1.`Life expectancy` = ''
;
