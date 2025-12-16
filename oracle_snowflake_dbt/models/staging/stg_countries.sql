{{
    config(
        materialized='view',
        tags=['staging', 'dimension']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'COUNTRIES') }}
),

cleaned AS (
    SELECT
        -- Primary Key
        COUNTRY_ID AS country_id,

        -- Country Information
        UPPER(TRIM(COUNTRY_ISO_CODE)) AS country_iso_code,
        TRIM(COUNTRY_NAME) AS country_name,

        -- Geographic Hierarchy
        TRIM(COUNTRY_REGION) AS region,
        COUNTRY_REGION_ID AS region_id,
        TRIM(COUNTRY_SUBREGION) AS subregion,
        COUNTRY_SUBREGION_ID AS subregion_id,
        TRIM(COUNTRY_TOTAL) AS country_total,
        COUNTRY_TOTAL_ID AS country_total_id,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
