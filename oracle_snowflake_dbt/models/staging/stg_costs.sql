{{
    config(
        materialized='view',
        tags=['staging', 'fact']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'COSTS') }}
),

cleaned AS (
    SELECT
        -- Foreign Keys
        PROD_ID AS product_id,
        TIME_ID AS cost_date,
        PROMO_ID AS promotion_id,
        CHANNEL_ID AS channel_id,

        -- Measures
        UNIT_COST AS unit_cost,
        UNIT_PRICE AS unit_price,

        -- Calculated Fields
        CASE
            WHEN UNIT_PRICE > 0 AND UNIT_COST > 0
            THEN ROUND(UNIT_PRICE - UNIT_COST, 2)
            ELSE NULL
        END AS unit_margin,

        CASE
            WHEN UNIT_PRICE > 0 AND UNIT_COST > 0
            THEN ROUND(((UNIT_PRICE - UNIT_COST) / UNIT_PRICE) * 100, 2)
            ELSE NULL
        END AS margin_percentage,

        -- Data Quality Flags
        CASE
            WHEN UNIT_COST IS NULL OR UNIT_COST < 0 THEN FALSE
            WHEN UNIT_PRICE IS NULL OR UNIT_PRICE < 0 THEN FALSE
            ELSE TRUE
        END AS is_valid_cost,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
WHERE is_valid_cost = TRUE
