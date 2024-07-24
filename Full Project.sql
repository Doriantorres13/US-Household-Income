-- Automated Data Cleaning 

SELECT *
FROM bakery.us_household_income_og;

SELECT * 
FROM bakery.us_household_income_cleaned;

DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_and_Clean_data;
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
	  `ALand` INTEGER,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	`TimeStamp` TIMESTAMP DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- COPY DATA TO NEW TABLE 

INSERT INTO `us_household_income_cleaned`
SELECT *, CURRENT_TIMESTAMP -- every time this runs its going to take the current day, month, year, and time and its gonna place it in that column 
FROM bakery.us_household_income_og;

-- Data Cleaning Steps 

	-- 1. Remove Duplicates
	DELETE FROM us_household_income_cleaned 
	WHERE 
		row_id IN (
		SELECT row_id
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id, `TimeStamp`
				ORDER BY id, `TimeStamp`) AS row_num
		FROM 
			us_household_income_cleaned 
	) duplicates
	WHERE 
		row_num > 1
	);

	-- 2. Fixing some data quality issues by fixing typos and general standardization
	UPDATE us_household_income_cleaned 
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE us_household_income_cleaned 
	SET County = UPPER(County);

	UPDATE us_household_income_cleaned 
	SET City = UPPER(City);

	UPDATE us_household_income_cleaned 
	SET Place = UPPER(Place);

	UPDATE us_household_income_cleaned 
	SET State_Name = UPPER(State_Name);

	UPDATE us_household_income_cleaned 
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE us_household_income_cleaned 
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';


END $$
DELIMITER ;

CALL Copy_and_Clean_data();

-- CREATE EVENT 
DROP EVENT run_data_cleaning;
CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_data();

SELECT DISTINCT TIMESTAMP;

-- DEBUGGING OR CHECKING STORED PROCEDURE WORKS 
-- LOOKING AT THE OLD DATA FIRST 
		SELECT row_id, id, row_num
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id
				ORDER BY id) AS row_num
		FROM 
			us_household_income_cleaned_og
	) duplicates
	WHERE 
		row_num > 1;
    
SELECT COUNT(row_id)
FROM us_household_income_cleaned_og;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income_cleaned_og
GROUP BY State_Name;

-- NOW WE ARE LOOKING AT THE NEW DATA 
SELECT row_id, id, row_num
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id
				ORDER BY id) AS row_num
		FROM 
			us_household_income_cleaned
	) duplicates
	WHERE 
		row_num > 1;
    
SELECT COUNT(row_id)
FROM us_household_income_cleaned;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income_cleaned
GROUP BY State_Name;



