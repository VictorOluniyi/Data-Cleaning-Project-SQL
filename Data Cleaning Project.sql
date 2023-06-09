CREATE TABLE Nashville (
	unique_id INTEGER,
	parcel_id VARCHAR(150),
	land_use VARCHAR(150),
	property_address VARCHAR(150),
	sale_date VARCHAR(50),
	sale_price VARCHAR(50),
	legal_reference VARCHAR(150),
	sold_as_vacant VARCHAR(200),
	owner_name VARCHAR (250),
	owner_address VARCHAR(200),
	acreage NUMERIC,
	tax_district VARCHAR(100),
	land_value INTEGER,
	building_value INTEGER,
	total_value INTEGER,
	year_built INTEGER,
	bedrooms INTEGER,
	full_bath INTEGER,
	half_bath INTEGER
);

SELECT *
FROM nashville;

-- Check for Duplicate row
SELECT unique_id, COUNT(*)
FROM nashville
GROUP BY unique_id
HAVING COUNT(*) > 1;

-- Removing duplicates processes
SELECT DISTINCT *
FROM nashville;
-- Then create a new table for the distinct
CREATE TABLE non_dup_data
SELECT DISTINCT *
FROM nashville;
--Then DROP the original table
DROP TABLE original_data;
-- Then alter the non_dup_data to original
ALTER TABLE non_dup_data RENAME original_data

-- Standardize date format April 9, 2013
SELECT sale_date
FROM nashville

SELECT TO_DATE(sale_date, 'MM-DD-YYYY') AS standardized_date
FROM nashville;

ALTER TABLE nashville
ADD SaleDateStandardized DATE;

UPDATE nashville
SET SaleDateStandardized = TO_DATE(sale_date, 'DD/MM/YYYY');

-- Populate property address which contains null data (Replacing the null value with the existing value)
SELECT *
FROM nashville
WHERE property_address IS NULL;

SELECT pa.parcel_id, 
	pa.property_address, 
	pb.parcel_id, 
	pb.property_address, 
	COALESCE(pa.property_address, pb.property_address)
FROM nashville pa
JOIN nashville pb
	ON pa.parcel_id = pb.parcel_id
	AND pa.unique_id <> pb.unique_id
WHERE pa.property_address IS NULL

UPDATE nashville pa
SET property_address = COALESCE(pa.property_address, pb.property_address)
FROM nashville pa
JOIN nashville pb
	ON pa.parcel_id = pb.parcel_id
	AND pa.unique_id <> pb.unique_id
WHERE pa.property_address IS NULL

UPDATE nashville pa
SET property_address = COALESCE(pa.property_address, pb.property_address)
FROM nashville pb
WHERE pa.parcel_id = pb.parcel_id
	AND pa.unique_id <> pb.unique_id
	AND pa.property_address IS NULL;

-- Breaking out property address into Individual columns (Address, City)
SELECT property_address
FROM nashville

SELECT 
	SUBSTRING(property_address FROM 1 FOR POSITION(',' IN property_address) -1) as Address,
	SUBSTRING(property_address FROM POSITION(',' IN property_address) + 1) AS address2
FROM nashville;

ALTER TABLE nashville
ADD COLUMN property_split_address VARCHAR(255);

UPDATE nashville
SET property_split_address = SUBSTRING(property_address FROM 1 FOR POSITION(',' IN property_address) -1);

ALTER TABLE nashville
ADD COLUMN property_split_city VARCHAR(255);

UPDATE nashville
SET property_split_city = SUBSTRING(property_address FROM POSITION(',' IN property_address) + 1);

SELECT *
FROM nashville

-- Breaking out property address into Individual columns (Address, City, State)
SELECT owner_address
FROM nashville;

SELECT 
	SPLIT_PART(REPLACE(owner_address, ',', '.') , '.', 1) AS street,
	SPLIT_PART(REPLACE(owner_address, ',', '.') , '.', 2) AS City,
	SPLIT_PART(REPLACE(owner_address, ',', '.') , '.', 3) AS state
FROM nashville;

ALTER TABLE nashville
ADD COLUMN owner_split_address VARCHAR(255);

UPDATE nashville
SET owner_split_address = SPLIT_PART(REPLACE(owner_address, ',', '.') , '.', 1);

ALTER TABLE nashville
ADD COLUMN owner_split_city VARCHAR(255);

UPDATE nashville
SET owner_split_city = SPLIT_PART(REPLACE(owner_address, ',', '.') , '.', 2);

ALTER TABLE nashville
ADD COLUMN owner_split_state VARCHAR(255);

UPDATE nashville
SET owner_split_state = SPLIT_PART(REPLACE(owner_address, ',', '.') , '.', 3);

SELECT *
FROM nashville

-- Change Y and N to Yes and NO in Sold as Vacant field
SELECT DISTINCT sold_as_vacant, COUNT(*)
FROM nashville
GROUP BY sold_as_vacant
ORDER BY 2;

SELECT sold_as_vacant, 
	(CASE WHEN sold_as_vacant = 'Y' THEN 'Yes'
		WHEN sold_as_vacant = 'N' THEN 'No'
		ELSE sold_as_vacant
		END) AS "sold_as_vacant2"
FROM nashville;

UPDATE nashville
SET sold_as_vacant = CASE WHEN sold_as_vacant = 'Y' THEN 'Yes'
		WHEN sold_as_vacant = 'N' THEN 'No'
		ELSE sold_as_vacant
		END;
		
--Remove Duplicates

DELETE FROM nashville
WHERE unique_id IN (
  SELECT unique_id
  FROM (
    SELECT unique_id,
           ROW_NUMBER() OVER (
             PARTITION BY parcel_id,
                          property_address,
                          sale_price,
                          sale_date,
                          legal_reference
             ORDER BY unique_id
           ) AS row_num
    FROM nashville
  ) AS RowNumCTE
  WHERE row_num > 1
);

OR

SELECT *
FROM nashville
WHERE unique_id NOT IN (
  SELECT MIN(unique_id)
  FROM nashville
  GROUP BY parcel_id, property_address, sale_price, sale_date, legal_reference
);

-- DELETE unused columns
ALTER TABLE nashville
DROP COLUMN owner_address,
DROP COLUMN tax_district,
DROP COLUMN property_address;

SELECT *
FROM nashville
