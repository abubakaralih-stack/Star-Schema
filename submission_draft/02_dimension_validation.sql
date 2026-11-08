-- Fisheries Data Warehouse: Dimension Validation
-- Aligned with the existing dw schema.
-- Validation only: does not insert, update, or delete data.

SELECT 'dim_date' AS dimension_name, COUNT(*) AS total_rows
FROM dw.dim_date
UNION ALL
SELECT 'dim_port', COUNT(*) FROM dw.dim_port
UNION ALL
SELECT 'dim_species', COUNT(*) FROM dw.dim_species
UNION ALL
SELECT 'dim_vessel', COUNT(*) FROM dw.dim_vessel
ORDER BY dimension_name;

-- Check for vessel codes without exactly one current version.
SELECT
    vessel_code,
    COUNT(*) FILTER (WHERE is_current) AS current_versions
FROM dw.dim_vessel
GROUP BY vessel_code
HAVING COUNT(*) FILTER (WHERE is_current) <> 1
ORDER BY vessel_code;

-- Inspect vessel history and effective dates.
SELECT
    vessel_key,
    vessel_code,
    vessel_name,
    effective_from,
    effective_to,
    is_current
FROM dw.dim_vessel
ORDER BY vessel_code, effective_from;
