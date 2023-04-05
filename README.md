# Data-Cleaning-Project-SQL

## About the Project
This repository contains a data cleaning project for a real estate dataset. The objective of this project is to clean the dataset and prepare it for analysis.

## Data Source
The data used for this project was obtained from the public dataset repository, Kaggle. The dataset contains information on real estate properties, including their unique_id, parcel_id, land_use, sale_date, sale_price, legal_reference, sold_as_vacant, owner_name, acre_age, land_value, building_value, total_value, year_built, bedrooms, full_bath, and half_bath

## Tech Stack 
The data cleaning project was conducted using SQL (PostGRESQL)

## Cleaning Process
#### 1. Creating the database
#### 2. Check for Duplicate row
#### 3. Removing duplicates processes
#### 4. Standardize date format April 9, 2013
#### 5. Populate property address which contains null data (Replacing the null value with the existing value)
#### 6. Breaking out owner address into Individual columns (Address, City, State)
#### 8. Change Y and N to Yes and NO in Sold as Vacant field
#### 9. Remove Duplicates
#### 10. DELETE unused columns

## Results
The cleaned dataset is now ready for analysis. It contains 10,000 rows and 15 columns, with no missing values or outliers.
