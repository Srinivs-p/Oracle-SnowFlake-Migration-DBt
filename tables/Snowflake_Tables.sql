-- =====================================================
-- SNOWFLAKE TABLE CREATION SCRIPT
-- Converted from Oracle DDL
-- Database: ORACLE_MIGRATION
-- Schema: STAGING
-- Total Tables: 10
-- =====================================================

USE DATABASE ORACLE_MIGRATION;
USE SCHEMA STAGING;
USE WAREHOUSE MIGRATION_WH;

-- =====================================================
-- 1. CHANNELS
-- =====================================================
CREATE TABLE IF NOT EXISTS CHANNELS (
    CHANNEL_ID NUMBER,
    CHANNEL_DESC VARCHAR(20),
    CHANNEL_CLASS VARCHAR(20),
    CHANNEL_CLASS_ID NUMBER,
    CHANNEL_TOTAL VARCHAR(13),
    CHANNEL_TOTAL_ID NUMBER
);

-- =====================================================
-- 2. COSTS (Partitioned table in Oracle - storing as regular table in Snowflake)
-- =====================================================
CREATE TABLE IF NOT EXISTS COSTS (
    PROD_ID NUMBER,
    TIME_ID TIMESTAMP_NTZ,
    PROMO_ID NUMBER,
    CHANNEL_ID NUMBER,
    UNIT_COST NUMBER(10,2),
    UNIT_PRICE NUMBER(10,2)
);

-- Note: Oracle partitions converted to regular Snowflake table
-- You can add clustering on TIME_ID for better query performance

-- =====================================================
-- 3. COUNTRIES
-- =====================================================
CREATE TABLE IF NOT EXISTS COUNTRIES (
    COUNTRY_ID NUMBER,
    COUNTRY_ISO_CODE CHAR(2),
    COUNTRY_NAME VARCHAR(40),
    COUNTRY_SUBREGION VARCHAR(30),
    COUNTRY_SUBREGION_ID NUMBER,
    COUNTRY_REGION VARCHAR(20),
    COUNTRY_REGION_ID NUMBER,
    COUNTRY_TOTAL VARCHAR(11),
    COUNTRY_TOTAL_ID NUMBER
);

-- =====================================================
-- 4. CUSTOMERS
-- =====================================================
CREATE TABLE IF NOT EXISTS CUSTOMERS (
    CUST_ID NUMBER,
    CUST_FIRST_NAME VARCHAR(20),
    CUST_LAST_NAME VARCHAR(40),
    CUST_GENDER CHAR(1),
    CUST_YEAR_OF_BIRTH NUMBER(4,0),
    CUST_MARITAL_STATUS VARCHAR(20),
    CUST_STREET_ADDRESS VARCHAR(40),
    CUST_POSTAL_CODE VARCHAR(10),
    CUST_CITY VARCHAR(30),
    CUST_CITY_ID NUMBER,
    CUST_STATE_PROVINCE VARCHAR(40),
    CUST_STATE_PROVINCE_ID NUMBER,
    COUNTRY_ID NUMBER,
    CUST_MAIN_PHONE_NUMBER VARCHAR(25),
    CUST_INCOME_LEVEL VARCHAR(30),
    CUST_CREDIT_LIMIT NUMBER,
    CUST_EMAIL VARCHAR(50),
    CUST_TOTAL VARCHAR(14),
    CUST_TOTAL_ID NUMBER,
    CUST_SRC_ID NUMBER,
    CUST_EFF_FROM TIMESTAMP_NTZ,
    CUST_EFF_TO TIMESTAMP_NTZ,
    CUST_VALID VARCHAR(1)
);

-- =====================================================
-- 5. PRODUCTS
-- =====================================================
CREATE TABLE IF NOT EXISTS PRODUCTS (
    PROD_ID NUMBER(6,0),
    PROD_NAME VARCHAR(50),
    PROD_DESC VARCHAR(4000),
    PROD_SUBCATEGORY VARCHAR(50),
    PROD_SUBCATEGORY_ID NUMBER,
    PROD_SUBCATEGORY_DESC VARCHAR(2000),
    PROD_CATEGORY VARCHAR(50),
    PROD_CATEGORY_ID NUMBER,
    PROD_CATEGORY_DESC VARCHAR(2000),
    PROD_WEIGHT_CLASS NUMBER(3,0),
    PROD_UNIT_OF_MEASURE VARCHAR(20),
    PROD_PACK_SIZE VARCHAR(30),
    SUPPLIER_ID NUMBER(6,0),
    PROD_STATUS VARCHAR(20),
    PROD_LIST_PRICE NUMBER(8,2),
    PROD_MIN_PRICE NUMBER(8,2),
    PROD_TOTAL VARCHAR(13),
    PROD_TOTAL_ID NUMBER,
    PROD_SRC_ID NUMBER,
    PROD_EFF_FROM TIMESTAMP_NTZ,
    PROD_EFF_TO TIMESTAMP_NTZ,
    PROD_VALID VARCHAR(1)
);

-- =====================================================
-- 6. PROMOTIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS PROMOTIONS (
    PROMO_ID NUMBER(6,0),
    PROMO_NAME VARCHAR(30),
    PROMO_SUBCATEGORY VARCHAR(30),
    PROMO_SUBCATEGORY_ID NUMBER,
    PROMO_CATEGORY VARCHAR(30),
    PROMO_CATEGORY_ID NUMBER,
    PROMO_COST NUMBER(10,2),
    PROMO_BEGIN_DATE TIMESTAMP_NTZ,
    PROMO_END_DATE TIMESTAMP_NTZ,
    PROMO_TOTAL VARCHAR(15),
    PROMO_TOTAL_ID NUMBER
);

-- =====================================================
-- 7. SALES
-- =====================================================
CREATE TABLE IF NOT EXISTS SALES (
    PROD_ID NUMBER(6,0),
    CUST_ID NUMBER,
    TIME_ID TIMESTAMP_NTZ,
    CHANNEL_ID NUMBER(1,0),
    PROMO_ID NUMBER(6,0),
    QUANTITY_SOLD NUMBER(3,0),
    AMOUNT_SOLD NUMBER(10,2)
);

-- =====================================================
-- 8. SUPPLEMENTARY_DEMOGRAPHICS
-- =====================================================
CREATE TABLE IF NOT EXISTS SUPPLEMENTARY_DEMOGRAPHICS (
    CUST_ID NUMBER,
    EDUCATION VARCHAR(21),
    OCCUPATION VARCHAR(21),
    HOUSEHOLD_SIZE VARCHAR(21),
    YRS_RESIDENCE NUMBER,
    AFFINITY_CARD NUMBER(10,0),
    CRICKET NUMBER(10,0),
    BASEBALL NUMBER(10,0),
    TENNIS NUMBER(10,0),
    SOCCER NUMBER(10,0),
    GOLF NUMBER(10,0),
    UNKNOWN NUMBER(10,0),
    MISC NUMBER(10,0),
    COMMENTS VARCHAR(4000)
);

-- =====================================================
-- 9. TEST_MIGRATION
-- =====================================================
CREATE TABLE IF NOT EXISTS TEST_MIGRATION (
    ID NUMBER,
    NAME VARCHAR(100),
    CREATED_DATE TIMESTAMP_NTZ,
    AMOUNT NUMBER(10,2)
);

-- =====================================================
-- 10. TIMES
-- =====================================================
CREATE TABLE IF NOT EXISTS TIMES (
    TIME_ID TIMESTAMP_NTZ,
    DAY_NAME VARCHAR(9),
    DAY_NUMBER_IN_WEEK NUMBER(1,0),
    DAY_NUMBER_IN_MONTH NUMBER(2,0),
    CALENDAR_WEEK_NUMBER NUMBER(2,0),
    FISCAL_WEEK_NUMBER NUMBER(2,0),
    WEEK_ENDING_DAY TIMESTAMP_NTZ,
    WEEK_ENDING_DAY_ID NUMBER,
    CALENDAR_MONTH_NUMBER NUMBER(2,0),
    FISCAL_MONTH_NUMBER NUMBER(2,0),
    CALENDAR_MONTH_DESC VARCHAR(8),
    CALENDAR_MONTH_ID NUMBER,
    FISCAL_MONTH_DESC VARCHAR(8),
    FISCAL_MONTH_ID NUMBER,
    DAYS_IN_CAL_MONTH NUMBER,
    DAYS_IN_FIS_MONTH NUMBER,
    END_OF_CAL_MONTH TIMESTAMP_NTZ,
    END_OF_FIS_MONTH TIMESTAMP_NTZ,
    CALENDAR_MONTH_NAME VARCHAR(9),
    FISCAL_MONTH_NAME VARCHAR(9),
    CALENDAR_QUARTER_DESC CHAR(7),
    CALENDAR_QUARTER_ID NUMBER,
    FISCAL_QUARTER_DESC CHAR(7),
    FISCAL_QUARTER_ID NUMBER,
    DAYS_IN_CAL_QUARTER NUMBER,
    DAYS_IN_FIS_QUARTER NUMBER,
    END_OF_CAL_QUARTER TIMESTAMP_NTZ,
    END_OF_FIS_QUARTER TIMESTAMP_NTZ,
    CALENDAR_QUARTER_NUMBER NUMBER(1,0),
    FISCAL_QUARTER_NUMBER NUMBER(1,0),
    CALENDAR_YEAR NUMBER(4,0),
    CALENDAR_YEAR_ID NUMBER,
    FISCAL_YEAR NUMBER(4,0),
    FISCAL_YEAR_ID NUMBER,
    DAYS_IN_CAL_YEAR NUMBER,
    DAYS_IN_FIS_YEAR NUMBER,
    END_OF_CAL_YEAR TIMESTAMP_NTZ,
    END_OF_FIS_YEAR TIMESTAMP_NTZ
);

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- List all tables created
SHOW TABLES IN SCHEMA STAGING;

-- Count tables
SELECT COUNT(*) as total_tables
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'STAGING'
  AND TABLE_CATALOG = 'ORACLE_MIGRATION';

-- Check table structures
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'STAGING'
  AND TABLE_CATALOG = 'ORACLE_MIGRATION'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- =====================================================
-- KEY CONVERSIONS MADE:
-- =====================================================
-- 1. VARCHAR2 → VARCHAR
-- 2. DATE → TIMESTAMP_NTZ
-- 3. Removed Oracle-specific clauses (SEGMENT CREATION, PCTFREE, STORAGE, etc.)
-- 4. Removed TABLESPACE references
-- 5. Removed BYTE specifications from VARCHAR/CHAR
-- 6. Converted partitioned COSTS table to regular table
-- 7. Kept NUMBER data types as-is (Snowflake supports them)
-- 8. Removed PRIMARY KEY constraints (add them later if needed)
-- 9. Comments not included (can add separately if needed)

-- =====================================================
-- NOTES:
-- =====================================================
-- - All tables use IF NOT EXISTS for safety
-- - DATE fields converted to TIMESTAMP_NTZ (no timezone)
-- - VARCHAR2/CHAR BYTE specifications removed (Snowflake uses characters by default)
-- - Partitioning removed (Snowflake uses micro-partitions automatically)
-- - Consider adding clustering keys for large tables (COSTS, SALES, TIMES)
-- - Consider adding primary keys after initial data load

-- =====================================================
-- OPTIONAL: Add Clustering for Performance
-- =====================================================
-- Run these AFTER loading data for better query performance:

-- ALTER TABLE COSTS CLUSTER BY (TIME_ID);
-- ALTER TABLE SALES CLUSTER BY (TIME_ID);
-- ALTER TABLE TIMES CLUSTER BY (TIME_ID);

-- =====================================================
-- READY TO RUN!
-- =====================================================
-- Execute this script in Snowflake, then run your ADF pipeline
