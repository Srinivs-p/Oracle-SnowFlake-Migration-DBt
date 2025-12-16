{{
    config(
        materialized='view',
        tags=['staging', 'dimension']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'PROMOTIONS') }}
),

cleaned AS (
    SELECT
        -- Primary Key
        PROMO_ID AS promotion_id,

        -- Promotion Information
        TRIM(PROMO_NAME) AS promotion_name,
        TRIM(PROMO_SUBCATEGORY) AS subcategory,
        PROMO_SUBCATEGORY_ID AS subcategory_id,
        TRIM(PROMO_CATEGORY) AS category,
        PROMO_CATEGORY_ID AS category_id,

        -- Financial
        PROMO_COST AS promotion_cost,

        -- Dates
        PROMO_BEGIN_DATE AS begin_date,
        PROMO_END_DATE AS end_date,

        -- Calculated Fields
        CASE
            WHEN PROMO_BEGIN_DATE IS NOT NULL AND PROMO_END_DATE IS NOT NULL
            THEN DATEDIFF(day, PROMO_BEGIN_DATE, PROMO_END_DATE)
            ELSE NULL
        END AS promotion_duration_days,

        CASE
            WHEN CURRENT_DATE() BETWEEN PROMO_BEGIN_DATE AND PROMO_END_DATE THEN TRUE
            ELSE FALSE
        END AS is_active,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
