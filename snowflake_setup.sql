-- =====================================================
-- SNOWFLAKE INITIAL SETUP SCRIPT
-- Oracle to Snowflake Migration
-- =====================================================

-- =====================================================
-- STEP 1: Create Warehouse (Compute Resources)
-- =====================================================
-- Warehouse handles compute for queries and data loading

CREATE WAREHOUSE IF NOT EXISTS MIGRATION_WH
  WAREHOUSE_SIZE = 'MEDIUM'           -- Options: XSMALL, SMALL, MEDIUM, LARGE, XLARGE
  AUTO_SUSPEND = 300                  -- Auto-suspend after 5 minutes of inactivity
  AUTO_RESUME = TRUE                  -- Auto-resume when query is submitted
  INITIALLY_SUSPENDED = FALSE
  COMMENT = 'Warehouse for Oracle to Snowflake migration';

-- Use the warehouse
USE WAREHOUSE MIGRATION_WH;


-- =====================================================
-- STEP 2: Create Database
-- =====================================================
-- Database is the top-level container

CREATE DATABASE IF NOT EXISTS ORACLE_MIGRATION
  COMMENT = 'Database for migrated Oracle data';

USE DATABASE ORACLE_MIGRATION;


-- =====================================================
-- STEP 3: Create Schemas
-- =====================================================
-- Organize data into logical schemas

-- Raw/Staging schema - for data as-is from Oracle
CREATE SCHEMA IF NOT EXISTS STAGING
  COMMENT = 'Raw data from Oracle source';

-- Intermediate schema - for transformations
CREATE SCHEMA IF NOT EXISTS INTERMEDIATE
  COMMENT = 'Intermediate transformations';

-- Mart schema - for final reporting tables
CREATE SCHEMA IF NOT EXISTS MART
  COMMENT = 'Final reporting tables';


-- =====================================================
-- STEP 4: Create Roles for Access Control
-- =====================================================

-- Create functional roles
CREATE ROLE IF NOT EXISTS MIGRATION_ADMIN
  COMMENT = 'Admin role for migration project';

CREATE ROLE IF NOT EXISTS MIGRATION_DEVELOPER
  COMMENT = 'Developer role for building pipelines';

CREATE ROLE IF NOT EXISTS MIGRATION_READER
  COMMENT = 'Read-only access to migrated data';


-- =====================================================
-- STEP 5: Grant Privileges to Roles
-- =====================================================

-- Grant warehouse usage
GRANT USAGE ON WAREHOUSE MIGRATION_WH TO ROLE MIGRATION_ADMIN;
GRANT USAGE ON WAREHOUSE MIGRATION_WH TO ROLE MIGRATION_DEVELOPER;
GRANT USAGE ON WAREHOUSE MIGRATION_WH TO ROLE MIGRATION_READER;

-- Grant database privileges to ADMIN
GRANT ALL PRIVILEGES ON DATABASE ORACLE_MIGRATION TO ROLE MIGRATION_ADMIN;

-- Grant schema privileges to ADMIN
GRANT ALL PRIVILEGES ON SCHEMA ORACLE_MIGRATION.STAGING TO ROLE MIGRATION_ADMIN;
GRANT ALL PRIVILEGES ON SCHEMA ORACLE_MIGRATION.INTERMEDIATE TO ROLE MIGRATION_ADMIN;
GRANT ALL PRIVILEGES ON SCHEMA ORACLE_MIGRATION.MART TO ROLE MIGRATION_ADMIN;

-- Grant schema privileges to DEVELOPER
GRANT USAGE ON DATABASE ORACLE_MIGRATION TO ROLE MIGRATION_DEVELOPER;
GRANT USAGE ON SCHEMA ORACLE_MIGRATION.STAGING TO ROLE MIGRATION_DEVELOPER;
GRANT ALL PRIVILEGES ON SCHEMA ORACLE_MIGRATION.INTERMEDIATE TO ROLE MIGRATION_DEVELOPER;
GRANT ALL PRIVILEGES ON SCHEMA ORACLE_MIGRATION.MART TO ROLE MIGRATION_DEVELOPER;

-- Grant future table privileges (tables created in the future)
GRANT SELECT ON FUTURE TABLES IN SCHEMA ORACLE_MIGRATION.STAGING TO ROLE MIGRATION_DEVELOPER;
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA ORACLE_MIGRATION.INTERMEDIATE TO ROLE MIGRATION_DEVELOPER;
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA ORACLE_MIGRATION.MART TO ROLE MIGRATION_DEVELOPER;

-- Grant read-only privileges to READER
GRANT USAGE ON DATABASE ORACLE_MIGRATION TO ROLE MIGRATION_READER;
GRANT USAGE ON SCHEMA ORACLE_MIGRATION.STAGING TO ROLE MIGRATION_READER;
GRANT USAGE ON SCHEMA ORACLE_MIGRATION.INTERMEDIATE TO ROLE MIGRATION_READER;
GRANT USAGE ON SCHEMA ORACLE_MIGRATION.MART TO ROLE MIGRATION_READER;
GRANT SELECT ON ALL TABLES IN SCHEMA ORACLE_MIGRATION.STAGING TO ROLE MIGRATION_READER;
GRANT SELECT ON ALL TABLES IN SCHEMA ORACLE_MIGRATION.INTERMEDIATE TO ROLE MIGRATION_READER;
GRANT SELECT ON ALL TABLES IN SCHEMA ORACLE_MIGRATION.MART TO ROLE MIGRATION_READER;
GRANT SELECT ON FUTURE TABLES IN SCHEMA ORACLE_MIGRATION.STAGING TO ROLE MIGRATION_READER;
GRANT SELECT ON FUTURE TABLES IN SCHEMA ORACLE_MIGRATION.INTERMEDIATE TO ROLE MIGRATION_READER;
GRANT SELECT ON FUTURE TABLES IN SCHEMA ORACLE_MIGRATION.MART TO ROLE MIGRATION_READER;


-- =====================================================
-- STEP 6: Assign Roles to Users
-- =====================================================
-- Replace 'YOUR_USERNAME' with your actual Snowflake username

-- GRANT ROLE MIGRATION_ADMIN TO USER YOUR_USERNAME;
-- GRANT ROLE MIGRATION_DEVELOPER TO USER YOUR_USERNAME;
-- GRANT ROLE MIGRATION_READER TO USER YOUR_USERNAME;

-- Note: Uncomment and update the username above


-- =====================================================
-- STEP 7: Create File Format for Data Loading
-- =====================================================
-- This defines how to parse CSV files from Oracle export

USE SCHEMA STAGING;

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null', '')
  EMPTY_FIELD_AS_NULL = TRUE
  COMPRESSION = 'GZIP'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
  COMMENT = 'CSV format for Oracle data import';


-- =====================================================
-- STEP 8: Create Stage for Azure Blob Storage
-- =====================================================
-- External stage pointing to Azure Blob Storage
-- You'll need: Storage Account Name, Container Name, SAS Token

-- CREATE OR REPLACE STAGE AZURE_STAGE
--   URL = 'azure://<storage_account>.blob.core.windows.net/<container>/'
--   CREDENTIALS = (AZURE_SAS_TOKEN = '<your_sas_token>')
--   FILE_FORMAT = CSV_FORMAT
--   COMMENT = 'Azure Blob Storage stage for Oracle data';

-- Note: Uncomment and update the Azure details above


-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Verify warehouse
SHOW WAREHOUSES LIKE 'MIGRATION_WH';

-- Verify database and schemas
SHOW DATABASES LIKE 'ORACLE_MIGRATION';
SHOW SCHEMAS IN DATABASE ORACLE_MIGRATION;

-- Verify roles
SHOW ROLES LIKE 'MIGRATION%';

-- Verify file format
SHOW FILE FORMATS IN SCHEMA ORACLE_MIGRATION.STAGING;

-- Verify current context
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA(), CURRENT_ROLE();
