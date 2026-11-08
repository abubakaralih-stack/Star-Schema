-- Fisheries Data Warehouse: Fact Loading
-- Targets the existing dw and stg schemas.
-- Save for review; do not execute until the loading logic is approved.

BEGIN;

WITH matched_landings AS (
    SELECT
        c.landing_id,
        d.date_key,
        p.port_key,
        s.species_key,
        v.vessel_key,
        c.landed_kg,
        c.landing_value
    FROM stg.landings_cleaned AS c
    JOIN dw.dim_date AS d
        ON d.full_date = c.landing_date
    JOIN dw.dim_port AS p
        ON UPPER(TRIM(p.port_code)) = UPPER(TRIM(c.port_code))
    JOIN dw.dim_species AS s
        ON UPPER(TRIM(s.species_name)) = UPPER(TRIM(c.species_name))
    JOIN dw.dim_vessel AS v
        ON UPPER(TRIM(v.vessel_code)) = UPPER(TRIM(c.vessel_code))
       AND c.landing_date BETWEEN v.effective_from AND v.effective_to
    WHERE c.record_status = 'ACCEPTED'
      AND c.landing_date IS NOT NULL
      AND c.landed_kg IS NOT NULL
      AND c.landing_value IS NOT NULL
),
insertable_landings AS (
    SELECT m.*
    FROM matched_landings AS m
    WHERE NOT EXISTS (
        SELECT 1
        FROM dw.fact_landing AS f
        WHERE f.date_key = m.date_key
          AND f.port_key = m.port_key
          AND f.species_key = m.species_key
          AND f.vessel_key = m.vessel_key
          AND f.landed_kg = m.landed_kg
          AND f.landing_value = m.landing_value
    )
)
INSERT INTO dw.fact_landing (
    date_key,
    port_key,
    species_key,
    vessel_key,
    landed_kg,
    landing_value
)
SELECT
    date_key,
    port_key,
    species_key,
    vessel_key,
    landed_kg,
    landing_value
FROM insertable_landings;

COMMIT;

SELECT COUNT(*) AS total_fact_records
FROM dw.fact_landing;
