{{
    config(
        materialized='view',
        tags=['staging', 'dimension']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'PRODUCTS') }}
),

cleaned AS (
    SELECT
        -- Primary Key
        PROD_ID AS product_id,

        -- Product Information
        TRIM(PROD_NAME) AS product_name,
        TRIM(PROD_DESC) AS product_description,

        -- Category Hierarchy
        TRIM(PROD_CATEGORY) AS category,
        PROD_CATEGORY_ID AS category_id,
        TRIM(PROD_CATEGORY_DESC) AS category_description,
        TRIM(PROD_SUBCATEGORY) AS subcategory,
        PROD_SUBCATEGORY_ID AS subcategory_id,
        TRIM(PROD_SUBCATEGORY_DESC) AS subcategory_description,

        -- Product Attributes
        PROD_WEIGHT_CLASS AS weight_class,
        TRIM(PROD_UNIT_OF_MEASURE) AS unit_of_measure,
        TRIM(PROD_PACK_SIZE) AS pack_size,
        TRIM(PROD_STATUS) AS status,

        -- Supplier
        SUPPLIER_ID AS supplier_id,

        -- Pricing
        PROD_LIST_PRICE AS list_price,
        PROD_MIN_PRICE AS min_price,
        CASE
            WHEN PROD_LIST_PRICE > 0 AND PROD_MIN_PRICE > 0
            THEN ROUND(((PROD_LIST_PRICE - PROD_MIN_PRICE) / PROD_LIST_PRICE) * 100, 2)
            ELSE NULL
        END AS max_discount_percentage,

        -- SCD Fields
        PROD_EFF_FROM AS effective_from,
        PROD_EFF_TO AS effective_to,
        PROD_VALID AS is_valid,
        PROD_SRC_ID AS source_id,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
