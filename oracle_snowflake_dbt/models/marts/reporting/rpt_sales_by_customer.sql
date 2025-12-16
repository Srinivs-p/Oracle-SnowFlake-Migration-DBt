{{
    config(
        materialized='table',
        tags=['mart', 'report', 'customer']
    )
}}

WITH sales AS (
    SELECT * FROM {{ ref('fct_sales') }}
),

customers AS (
    SELECT * FROM {{ ref('dim_customer') }}
),

customer_sales_summary AS (
    SELECT
        -- Customer Dimensions
        c.customer_id,
        c.full_name,
        c.email,
        c.country_name,
        c.region,
        c.age_segment,
        c.credit_segment,

        -- Sales Metrics
        COUNT(DISTINCT s.transaction_date) AS total_transactions,
        SUM(s.quantity_sold) AS total_quantity,
        SUM(s.amount_sold) AS total_revenue,
        SUM(s.total_cost) AS total_cost,
        SUM(s.gross_profit) AS total_profit,

        -- Averages
        ROUND(AVG(s.amount_sold), 2) AS avg_transaction_value,
        ROUND(AVG(s.profit_margin_percentage), 2) AS avg_profit_margin_pct,

        -- First and Last Purchase
        MIN(s.transaction_date) AS first_purchase_date,
        MAX(s.transaction_date) AS last_purchase_date,

        -- Customer Lifetime Value
        ROUND(SUM(s.gross_profit), 2) AS customer_lifetime_value,

        -- Recency (days since last purchase)
        DATEDIFF(day, MAX(s.transaction_date), CURRENT_DATE()) AS days_since_last_purchase,

        -- Customer Segment
        CASE
            WHEN COUNT(DISTINCT s.transaction_date) >= 10 AND SUM(s.amount_sold) >= 10000 THEN 'VIP'
            WHEN COUNT(DISTINCT s.transaction_date) >= 5 AND SUM(s.amount_sold) >= 5000 THEN 'Gold'
            WHEN COUNT(DISTINCT s.transaction_date) >= 2 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment,

        -- Metadata
        CURRENT_TIMESTAMP() AS dbt_updated_at

    FROM customers c
    INNER JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.full_name,
        c.email,
        c.country_name,
        c.region,
        c.age_segment,
        c.credit_segment
)

SELECT * FROM customer_sales_summary
