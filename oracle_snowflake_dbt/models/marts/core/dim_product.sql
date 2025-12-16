{{
    config(
        materialized='table',
        tags=['mart', 'dimension', 'product']
    )
}}

WITH products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

final AS (
    SELECT
        -- Product Info
        product_id,
        product_name,
        product_description,

        -- Category Hierarchy
        category,
        category_id,
        category_description,
        subcategory,
        subcategory_id,
        subcategory_description,

        -- Attributes
        weight_class,
        unit_of_measure,
        pack_size,
        status,
        supplier_id,

        -- Pricing
        list_price,
        min_price,
        max_discount_percentage,

        -- Product Classification
        CASE
            WHEN list_price < 50 THEN 'Budget'
            WHEN list_price < 200 THEN 'Mid-Range'
            ELSE 'Premium'
        END AS price_tier,

        CASE
            WHEN status = 'obs' THEN 'Obsolete'
            WHEN status = 'orderable' THEN 'Active'
            ELSE 'Unknown'
        END AS product_status,

        -- Metadata
        effective_from,
        effective_to,
        is_valid,
        CURRENT_TIMESTAMP() AS dbt_updated_at

    FROM products
)

SELECT * FROM final
