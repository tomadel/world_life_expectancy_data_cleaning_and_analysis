# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy;


#Compare the highest and lowest Life expectancy in each country to observe the progress
SELECT Country, 
MIN(`Life expectancy`) , 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND  MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years  DESC;


#Finding the average life expectancy
SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE (`Life expectancy`) <> 0
GROUP BY Year
ORDER BY Year;

#Check the possible correlation in between GDP and Life Expectancy
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp <> 0
AND GDP > 0
ORDER BY GDP ASC;


SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_expectancy
FROM world_life_expectancy;

#Find the average life expectancy by grouping by their status (Developing and Developed)
SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status;

SELECT Status, Count(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status;




# check if there is a correlation in between BMI and life expectancy
SELECT  Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp <> 0
AND BMI > 0
ORDER BY BMI DESC;


SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
;