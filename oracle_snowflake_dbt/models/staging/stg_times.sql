{{
    config(
        materialized='view',
        tags=['staging', 'dimension']
    )
}}

WITH source AS (
    SELECT * FROM {{ source('oracle_raw', 'TIMES') }}
),

cleaned AS (
    SELECT
        -- Primary Key
        TIME_ID AS date_day,

        -- Day Attributes
        TRIM(DAY_NAME) AS day_name,
        DAY_NUMBER_IN_WEEK AS day_of_week,
        DAY_NUMBER_IN_MONTH AS day_of_month,

        -- Week Attributes
        CALENDAR_WEEK_NUMBER AS calendar_week_number,
        FISCAL_WEEK_NUMBER AS fiscal_week_number,
        WEEK_ENDING_DAY AS week_ending_date,

        -- Month Attributes
        CALENDAR_MONTH_NUMBER AS calendar_month_number,
        FISCAL_MONTH_NUMBER AS fiscal_month_number,
        TRIM(CALENDAR_MONTH_NAME) AS calendar_month_name,
        TRIM(FISCAL_MONTH_NAME) AS fiscal_month_name,
        TRIM(CALENDAR_MONTH_DESC) AS calendar_month_desc,
        TRIM(FISCAL_MONTH_DESC) AS fiscal_month_desc,
        DAYS_IN_CAL_MONTH AS days_in_calendar_month,
        DAYS_IN_FIS_MONTH AS days_in_fiscal_month,
        END_OF_CAL_MONTH AS end_of_calendar_month,
        END_OF_FIS_MONTH AS end_of_fiscal_month,

        -- Quarter Attributes
        TRIM(CALENDAR_QUARTER_DESC) AS calendar_quarter_desc,
        TRIM(FISCAL_QUARTER_DESC) AS fiscal_quarter_desc,
        CALENDAR_QUARTER_NUMBER AS calendar_quarter_number,
        FISCAL_QUARTER_NUMBER AS fiscal_quarter_number,
        DAYS_IN_CAL_QUARTER AS days_in_calendar_quarter,
        DAYS_IN_FIS_QUARTER AS days_in_fiscal_quarter,
        END_OF_CAL_QUARTER AS end_of_calendar_quarter,
        END_OF_FIS_QUARTER AS end_of_fiscal_quarter,

        -- Year Attributes
        CALENDAR_YEAR AS calendar_year,
        FISCAL_YEAR AS fiscal_year,
        DAYS_IN_CAL_YEAR AS days_in_calendar_year,
        DAYS_IN_FIS_YEAR AS days_in_fiscal_year,
        END_OF_CAL_YEAR AS end_of_calendar_year,
        END_OF_FIS_YEAR AS end_of_fiscal_year,

        -- Audit
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source
)

SELECT * FROM cleaned
