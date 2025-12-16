{{
    config(
        materialized='view',
        tags=['staging', 'dimension']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'CUSTOMERS') }}
),

cleaned AS (
    SELECT
        -- Primary Key
        CUST_ID AS customer_id,

        -- Customer Name
        TRIM(CUST_FIRST_NAME) AS first_name,
        TRIM(CUST_LAST_NAME) AS last_name,
        CONCAT(TRIM(CUST_FIRST_NAME), ' ', TRIM(CUST_LAST_NAME)) AS full_name,

        -- Demographics
        CUST_GENDER AS gender,
        CUST_YEAR_OF_BIRTH AS birth_year,
        CASE
            WHEN CUST_YEAR_OF_BIRTH IS NOT NULL
            THEN YEAR(CURRENT_DATE()) - CUST_YEAR_OF_BIRTH
            ELSE NULL
        END AS age,
        CUST_MARITAL_STATUS AS marital_status,

        -- Contact Information
        TRIM(CUST_STREET_ADDRESS) AS street_address,
        TRIM(CUST_POSTAL_CODE) AS postal_code,
        TRIM(CUST_CITY) AS city,
        CUST_CITY_ID AS city_id,
        TRIM(CUST_STATE_PROVINCE) AS state_province,
        CUST_STATE_PROVINCE_ID AS state_province_id,
        COUNTRY_ID AS country_id,
        CUST_MAIN_PHONE_NUMBER AS phone_number,
        LOWER(TRIM(CUST_EMAIL)) AS email,

        -- Financial Information
        CUST_INCOME_LEVEL AS income_level,
        CUST_CREDIT_LIMIT AS credit_limit,

        -- SCD Fields
        CUST_EFF_FROM AS effective_from,
        CUST_EFF_TO AS effective_to,
        CUST_VALID AS is_valid,
        CUST_SRC_ID AS source_id,

        -- Audit Fields
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
