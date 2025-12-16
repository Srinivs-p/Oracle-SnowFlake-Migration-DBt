{{
    config(
        materialized='view',
        tags=['staging', 'dimension']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'SUPPLEMENTARY_DEMOGRAPHICS') }}
),

cleaned AS (
    SELECT
        -- Foreign Key
        CUST_ID AS customer_id,

        -- Demographics
        TRIM(EDUCATION) AS education_level,
        TRIM(OCCUPATION) AS occupation,
        TRIM(HOUSEHOLD_SIZE) AS household_size,
        YRS_RESIDENCE AS years_of_residence,

        -- Interests/Affinities
        AFFINITY_CARD AS has_affinity_card,
        CRICKET AS interest_cricket,
        BASEBALL AS interest_baseball,
        TENNIS AS interest_tennis,
        SOCCER AS interest_soccer,
        GOLF AS interest_golf,
        UNKNOWN AS interest_unknown,
        MISC AS interest_misc,

        -- Total Sports Interests
        COALESCE(CRICKET, 0) +
        COALESCE(BASEBALL, 0) +
        COALESCE(TENNIS, 0) +
        COALESCE(SOCCER, 0) +
        COALESCE(GOLF, 0) AS total_sports_interests,

        -- Comments
        TRIM(COMMENTS) AS comments,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
