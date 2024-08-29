-- Automated Data Cleaning 

SELECT *
FROM `US Household Income`.us_household_income;

SELECT * 
FROM `US Household Income`.us_household_income_cleaned;

DROP PROCEDURE IF EXISTS Copy_and_Clean_data;

DELIMITER $$
CREATE PROCEDURE Copy_and_Clean_data()
BEGIN

-- CREATING OUR TABLE 

	CREATE TABLE IF NOT EXISTS `us_household_income_cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` BIGINT,
	  `AWater` BIGINT,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	`TimeStamp` TIMESTAMP DEFAULT NULL
	) ;
    
-- COPY DATA TO NEW TABLE 

INSERT INTO `us_household_income_cleaned`
SELECT 
    row_id,
    id,
    State_Code,
    State_Name,
    State_ab,
    County,
    City,
    Place,
    `Type`,
    `Primary`,
    Zip_Code,
    CASE WHEN Area_Code = 'M' THEN NULL ELSE Area_Code END AS Area_Code,
    ALand,
    AWater,
    Lat,
    Lon,
    CURRENT_TIMESTAMP AS TimeStamp
  FROM bakery.us_household_income_og
  WHERE ALand BETWEEN -2147483648 AND 2147483647
  AND AWater BETWEEN -2147483648 AND 2147483647 
; 

-- Data Cleaning Steps

-- Removing Duplicates

DELETE FROM `US Household Income`.us_household_income_cleaned 
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id,
		ROW_NUMBER() OVER (PARTITION BY id, `TimeStamp`
        ORDER BY id, `TimeStamp`) AS row_num
		FROM bakery.us_household_income_cleaned ) AS duplicates
		WHERE row_num > 1
	);
    
-- Fixing some data quality issues by fixing typos and general standardization
UPDATE `US Household Income`.us_household_income_cleaned 
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE `US Household Income`.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

UPDATE `US Household Income`.us_household_income_cleaned 
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs';

UPDATE `US Household Income`.us_household_income_cleaned 
SET `Type` = 'CDP'
WHERE `Type` = 'CPD';

UPDATE `US Household Income`.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

UPDATE `US Household Income`.us_household_income_cleaned 
SET County = UPPER(County);

UPDATE `US Household Income`.us_household_income_cleaned 
SET City = UPPER(City);

UPDATE `US Household Income`.us_household_income_cleaned 
SET Place = UPPER(Place);

UPDATE `US Household Income`.us_household_income_cleaned 
SET State_Name = UPPER(State_Name);

END $$
DELIMITER ;

CALL Copy_and_Clean_data();

-- CREATE EVENT 
DROP EVENT run_data_cleaning;
CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_data();





