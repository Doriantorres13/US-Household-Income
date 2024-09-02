# US Household Income Overview

This project comprehensively analyzes household income data across the United States. The data was cleaned, transformed, and analyzed to reveal insights into income distribution by state, city, and other geographical classifications. The final results were visualized using Tableau to create a dashboard, providing a user-friendly way to explore the data.

Data Cleaning and Preparation

The initial dataset, us_household_income, contained raw data with inconsistencies and errors. To prepare this data for analysis, the following steps were taken:

Creation of a Cleaned Table:
1. A new table, us_household_income_cleaned, was created to store the cleaned and standardized data. 
2. Automated Data Cleaning Stored Procedure:
  A stored procedure named Copy_and_Clean_data was created to automate the data-cleaning process.
  This procedure:
    - Copies data from the original table, us_household_income_og, into the new us_household_income_cleaned table.
    - Includes conditional logic to handle specific cases, such as replacing the string 'M' with NULL in the Area_Code column.
    - Applies constraints to ensure only data with ALand and AWater values within a specific range are included.
    - A timestamp is added to track when the data was processed.
3. Data Cleaning Steps within the Procedure:
  - Removing Duplicates: Duplicates were identified and removed using a subquery that assigned row numbers based on the id and      TimeStamp. Rows with a row number greater than one were deleted to retain unique entries.
  - Fixing Typos and Standardizing Data: Specific updates were made to correct typos and standardize data entries:
      - Correcting misspellings of state names (e.g., 'georia' to 'Georgia').
      - Standardizing type names (e.g., 'Boroughs' to 'Borough,' 'CPD' to 'CDP').
      - Correcting mismatches in place names (e.g., setting Place to 'Autaugaville' based on County and City values).
      - Converting all text entries for County, City, Place, and State_Name to uppercase for consistency.
  4. Scheduled Data Cleaning Event:
  - An event named run_data_cleaning was created to automate the execution of the Copy_and_Clean_data procedure every 30 days.      This ensures that the data remains up-to-date and is cleaned regularly.

Exploratory Data Analysis (EDA)

After cleaning the data, several SQL queries were executed to analyze various aspects of household income across different geographical regions:

1. State and Area Analysis:
  - Queries were run to calculate the total land (ALand) and water (AWater) areas by state, identifying the largest states by       land and water area. This helps to understand the geographical context of the data.
2. Income Analysis:
  - By joining the cleaned data with income statistics from us_household_income_statistics, insights into mean and median           household incomes across states, cities, and region types were gathered.
  Analysis included:
    - Listing the top 10 states with the highest and lowest average mean income.
    - Identifying the top 5 types of regions (e.g., city, community) with the highest average mean and median incomes.
    - Investigating the regions with unusually low incomes (e.g., regions classified as 'Community').
    - Filtering to focus on region types with a significant count (over 100) to ensure reliability in the findings.
    - Identifying the top 10 cities with the highest average mean income.

Tableau Dashboard Creation

The cleaned and analyzed data was imported into Tableau, where various visualizations were created to provide an interactive way to explore the results:

1. Bar Charts for Area Analysis:
  - Visualizations showing the top 10 states by land and water area. These bar charts clearly show the states with the largest      geographical footprint.
2. Income Distribution Charts:
  - Bar charts displaying the top and bottom ten states by average mean income.
  - Bar charts showing the top 5 region types by mean incomes, providing insights into how different types of areas                 compare in household income.
  - A focused bar chart highlighting the top 10 cities with the highest average mean income, allowing for a more granular look      into urban income distribution.
3. Interactivity and Filters:
  - The dashboard includes interactive filters, allowing users to drill down into specific states, cities, or region types.         This interactivity enhances the user experience by enabling tailored exploration of the data.
4. Styling and Presentation:
  - Consistent color schemes, clear labels, and concise titles ensured the dashboard was visually appealing and easy to             understand.
    
Conclusion:

This project demonstrates the power of data cleaning, analysis, and visualization in extracting meaningful insights from raw data. By automating the cleaning process and leveraging SQL for detailed analysis, we can maintain a robust data pipeline. The final Tableau dashboard provides an accessible and engaging way for users to explore household income distribution across the United States, offering valuable perspectives on economic patterns.





