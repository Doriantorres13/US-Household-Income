# MySQL-Project
Automated Data Cleaning for US Household Income Data

I developed a comprehensive automated data-cleaning process for US household income data in this project. This was achieved by creating a stored procedure named 'Copy_and_Clean_data' and setting up an event to execute this procedure on a regular schedule.

Steps Undertaken:

1. Table Creation: I created a new table, us_household_income_cleaned, to store the cleaned data with an additional timestamp column to track when each record was processed.

2. Data Copying: The procedure begins by copying all records from the original dataset, us_household_income_og, into the new table. This ensures that the raw data remains intact while the cleaned data is stored separately.

3. Removing Duplicates: I implemented a method to identify and remove duplicate records based on the ID and TimeStamp columns. This step ensures that each record in the cleaned dataset is unique.

4. Data Standardization and Correction:
- Fixed typos and standardized text fields for consistency (e.g., correcting "georia" to "Georgia").
- Converted values in the County, City, Place, and State_Name columns to uppercase to maintain uniformity.
- Corrected values in the Type column to ensure consistency (e.g., changing "CPD" to "CDP" and standardizing "Borough" entries).

5. Procedure Execution: After defining the procedure, I executed it to clean the initial batch of data.

6. Scheduled Execution: To maintain data integrity over time, I created an event named run_data_cleaning to call the Copy_and_Clean_data procedure every 30 days. This automation ensures that the dataset remains up-to-date and clean without manual intervention.

7. Validation and Debugging: I included queries to validate the cleaning process by comparing the old and new datasets. These queries check for duplicates, count the number of records, and group data by state to ensure the cleaning process works as intended.

This automated approach ensures that the US household income dataset remains clean, standardized, and always ready for analysis. The full SQL script for this project is included in the repository for reference and reuse.





