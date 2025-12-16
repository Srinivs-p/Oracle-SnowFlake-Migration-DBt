{{
    config(
        materialized='view',
        tags=['staging', 'dimension']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'CHANNELS') }}
),

cleaned AS (
    SELECT
        -- Primary Key
        CHANNEL_ID AS channel_id,

        -- Channel Information
        TRIM(CHANNEL_DESC) AS channel_description,
        TRIM(CHANNEL_CLASS) AS channel_class,
        CHANNEL_CLASS_ID AS channel_class_id,
        TRIM(CHANNEL_TOTAL) AS channel_total,
        CHANNEL_TOTAL_ID AS channel_total_id,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
