-- adding new db
create database if not exists house_price_data;

use house_price_data;
-- checking dataset after the import via wizard 
SELECT * FROM house_price_data.regression_data;

-- dropping column data
ALTER TABLE regression_data
drop column date;
-- checking if column data no longer exist in the data
SELECT * FROM house_price_data.regression_data
LIMIT 10;

-- counting rows
SELECT COUNT(*) FROM house_price_data.regression_data;

-- unique values for bedrooms
SELECT DISTINCT bedrooms FROM house_price_data.regression_data;
-- unique values for bathrooms
SELECT DISTINCT bathrooms FROM house_price_data.regression_data;
-- unique values for floors
SELECT DISTINCT floors FROM house_price_data.regression_data;
-- unique values for condition
SELECT DISTINCT `condition` FROM house_price_data.regression_data;
-- unique values for grade
SELECT DISTINCT grade FROM house_price_data.regression_data;

-- 10 most expensive houses
SELECT * FROM house_price_data.regression_data
ORDER BY price DESC
LIMIT 10;

-- avarage price of all properties
SELECT AVG(price) FROM house_price_data.regression_data;

-- average price of the houses grouped by bedrooms
SELECT bedrooms, ROUND(AVG(price),0) AS avg_price FROM house_price_data.regression_data
GROUP BY bedrooms;

-- average `sqft_living` of the houses grouped by bedrooms, shown in m2
SELECT bedrooms, ROUND((AVG(sqft_living)*0.092),0) AS squarefeet_living_meters FROM house_price_data.regression_data
GROUP BY bedrooms;

-- the average price of the houses with a waterfront and without a waterfront
SELECT CASE 
WHEN waterfront = 1 THEN 'Yes'
ELSE 'No'
END AS 'waterfront',
ROUND(AVG(price),0) as avg_price
FROM house_price_data.regression_data
GROUP BY waterfront;

/*
SELECT `condition`, avg(grade), COUNT(*) FROM house_price_data.regression_data
GROUP BY `condition`
order by `condition`;
*/

-- correlation between the columns `condition` and `grade`
SELECT (AVG(`condition` * grade) - (AVG(`condition`) * AVG(grade))) / (STDDEV(`condition`) * STDDEV(grade)) AS correlation
FROM house_price_data.regression_data;


-- checking number of houses in different categories
SELECT `condition`, COUNT(id) AS number_of_houses FROM house_price_data.regression_data 
GROUP BY `condition`;

SELECT waterfront, COUNT(id) AS number_of_houses FROM house_price_data.regression_data
GROUP BY waterfront;

SELECT view, COUNT(id) AS number_of_houses FROM house_price_data.regression_data
GROUP BY view;

SELECT grade, COUNT(id) AS number_of_houses FROM house_price_data.regression_data
GROUP BY grade
ORDER BY grade ASC;

/*
Customer request:
    - Number of bedrooms either 3 or 4
    - Bathrooms more than 3
    - One Floor
    - No waterfront
    - Condition should be 3 at least
    - Grade should be 5 at least
    - Price less than 300000
*/
SELECT * FROM house_price_data.regression_data
WHERE bedrooms = 3 or bedrooms = 4 AND bathrooms > 3 AND floors = 1 AND waterfront = 0 AND `condition` >= 3 AND grade >= 5 AND price < 300000
ORDER BY price ASC;

-- list of properties whose prices are twice more than the average of all the properties
SELECT * FROM house_price_data.regression_data
WHERE price > (
	SELECT (AVG(price)*2) AS avg_price FROM house_price_data.regression_data
    )
ORDER BY price ASC;

-- view for list of properties whose prices are twice more than the average of all the properties
CREATE VIEW Houses_with_higher_than_double_average_price AS
SELECT * FROM house_price_data.regression_data
WHERE price > (
	SELECT (AVG(price)*2) AS avg_price FROM house_price_data.regression_data
    )
ORDER BY price ASC;

SELECT * FROM Houses_with_higher_than_double_average_price;

-- average prices of the properties with three and four bedrooms
SELECT bedrooms, AVG(price) AS avg_price FROM house_price_data.regression_data
WHERE bedrooms = 3 or bedrooms = 4
GROUP BY bedrooms;

-- different locations where properties are available
SELECT DISTINCT (zipcode) FROM house_price_data.regression_data;

-- list of all the properties that were renovated
/*SELECT * FROM house_price_data.regression_data
WHERE sqft_living15 <> sqft_living AND sqft_lot15 <> sqft_lot;
*/
SELECT * FROM house_price_data.regression_data
WHERE yr_renovated > 0;


-- details of the property that is the 11th most expensive property
SELECT * FROM (
	SELECT *, ROW_NUMBER() OVER (ORDER BY price DESC) AS number FROM house_price_data.regression_data
    )sub1
where number = 11;

select count(distinct(zipcode)) from house_price_data.regression_data;
select count(zipcode) from house_price_data.regression_data;
    