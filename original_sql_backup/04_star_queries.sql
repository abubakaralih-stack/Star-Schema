
SET search_path TO dw, public;

-- Query 1: Total kilograms per month
SELECT
    d.year_num,
    d.month_num,
    d.month_name,
    ROUND(SUM(f.landed_kg), 2) AS total_landed_kg
FROM dw.fact_landing f
JOIN dw.dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year_num,
    d.month_num,
    d.month_name
ORDER BY
    d.year_num,
    d.month_num;


-- Query 2: Top species per port
WITH species_totals AS (
    SELECT
        p.port_key,
        p.port_name,
        s.species_name,
        SUM(f.landed_kg) AS total_landed_kg
    FROM dw.fact_landing f
    JOIN dw.dim_port p
        ON f.port_key = p.port_key
    JOIN dw.dim_species s
        ON f.species_key = s.species_key
    GROUP BY
        p.port_key,
        p.port_name,
        s.species_name
),
ranked_species AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY port_key
            ORDER BY total_landed_kg DESC
        ) AS rank_num
    FROM species_totals
)
SELECT
    port_name,
    species_name,
    ROUND(total_landed_kg, 2) AS total_landed_kg
FROM ranked_species
WHERE rank_num = 1
ORDER BY port_name;


-- Query 3: Total landing value per cooperative
SELECT
    p.cooperative_name,
    ROUND(SUM(f.landing_value), 2) AS total_landing_value
FROM dw.fact_landing f
JOIN dw.dim_port p
    ON f.port_key = p.port_key
GROUP BY p.cooperative_name
ORDER BY total_landing_value DESC;