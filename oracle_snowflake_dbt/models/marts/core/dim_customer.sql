{{
    config(
        materialized='table',
        tags=['mart', 'dimension', 'customer']
    )
}}

WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

demographics AS (
    SELECT * FROM {{ ref('stg_supplementary_demographics') }}
),

countries AS (
    SELECT * FROM {{ ref('stg_countries') }}
),

customer_enriched AS (
    SELECT
        -- Customer Info
        c.customer_id,
        c.first_name,
        c.last_name,
        c.full_name,
        c.gender,
        c.birth_year,
        c.age,
        c.marital_status,

        -- Contact
        c.street_address,
        c.postal_code,
        c.city,
        c.state_province,
        c.phone_number,
        c.email,

        -- Geography
        co.country_name,
        co.country_iso_code,
        co.region,
        co.subregion,

        -- Financial
        c.income_level,
        c.credit_limit,

        -- Demographics
        d.education_level,
        d.occupation,
        d.household_size,
        d.years_of_residence,
        d.has_affinity_card,
        d.total_sports_interests,
        d.interest_cricket,
        d.interest_baseball,
        d.interest_tennis,
        d.interest_soccer,
        d.interest_golf,

        -- Segmentation
        CASE
            WHEN c.age < 25 THEN '18-24'
            WHEN c.age < 35 THEN '25-34'
            WHEN c.age < 45 THEN '35-44'
            WHEN c.age < 55 THEN '45-54'
            WHEN c.age < 65 THEN '55-64'
            ELSE '65+'
        END AS age_segment,

        CASE
            WHEN c.credit_limit < 5000 THEN 'Low'
            WHEN c.credit_limit < 10000 THEN 'Medium'
            ELSE 'High'
        END AS credit_segment,

        -- Metadata
        c.effective_from,
        c.effective_to,
        c.is_valid,
        CURRENT_TIMESTAMP() AS dbt_updated_at

    FROM customers c
    LEFT JOIN demographics d ON c.customer_id = d.customer_id
    LEFT JOIN countries co ON c.country_id = co.country_id
)

SELECT * FROM customer_enriched
