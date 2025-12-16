{{
    config(
        materialized='view',
        tags=['staging', 'fact']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'SALES') }}
),

cleaned AS (
    SELECT
        -- Foreign Keys
        PROD_ID AS product_id,
        CUST_ID AS customer_id,
        TIME_ID AS transaction_date,
        CHANNEL_ID AS channel_id,
        PROMO_ID AS promotion_id,

        -- Measures
        QUANTITY_SOLD AS quantity_sold,
        AMOUNT_SOLD AS amount_sold,

        -- Calculated Fields
        CASE
            WHEN QUANTITY_SOLD > 0
            THEN ROUND(AMOUNT_SOLD / QUANTITY_SOLD, 2)
            ELSE NULL
        END AS unit_price,

        -- Data Quality Flags
        CASE
            WHEN AMOUNT_SOLD IS NULL OR AMOUNT_SOLD < 0 THEN FALSE
            WHEN QUANTITY_SOLD IS NULL OR QUANTITY_SOLD <= 0 THEN FALSE
            ELSE TRUE
        END AS is_valid_sale,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
WHERE is_valid_sale = TRUE  -- Filter out invalid sales
