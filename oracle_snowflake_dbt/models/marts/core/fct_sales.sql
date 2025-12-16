{{
    config(
        materialized='table',
        tags=['mart', 'fact', 'sales']
    )
}}

WITH sales AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

costs AS (
    SELECT * FROM {{ ref('stg_costs') }}
),

sales_with_costs AS (
    SELECT
        -- Foreign Keys
        s.product_id,
        s.customer_id,
        s.transaction_date,
        s.channel_id,
        s.promotion_id,

        -- Sales Measures
        s.quantity_sold,
        s.amount_sold,
        s.unit_price,

        -- Cost Measures (from costs table)
        c.unit_cost,
        c.unit_price AS cost_unit_price,

        -- Calculated Measures
        s.quantity_sold * COALESCE(c.unit_cost, 0) AS total_cost,
        s.amount_sold - (s.quantity_sold * COALESCE(c.unit_cost, 0)) AS gross_profit,

        CASE
            WHEN s.amount_sold > 0
            THEN ROUND(
                ((s.amount_sold - (s.quantity_sold * COALESCE(c.unit_cost, 0))) / s.amount_sold) * 100,
                2
            )
            ELSE 0
        END AS profit_margin_percentage,

        -- Revenue Tiers
        CASE
            WHEN s.amount_sold < 100 THEN 'Small'
            WHEN s.amount_sold < 500 THEN 'Medium'
            WHEN s.amount_sold < 1000 THEN 'Large'
            ELSE 'Very Large'
        END AS transaction_size,

        -- Metadata
        CURRENT_TIMESTAMP() AS dbt_updated_at

    FROM sales s
    LEFT JOIN costs c
        ON s.product_id = c.product_id
        AND s.transaction_date = c.cost_date
        AND s.channel_id = c.channel_id
        AND COALESCE(s.promotion_id, -1) = COALESCE(c.promotion_id, -1)
)

SELECT * FROM sales_with_costs
