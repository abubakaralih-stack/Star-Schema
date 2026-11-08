/*
====================================================
RECOVERED SQL QUERIES — FISHERIES DATA WAREHOUSE
Purpose: Reference archive for recovered Lab 1–3 SQL
IMPORTANT: This file is for reference only.
Do not execute the entire file.
====================================================
*/

-- ================================================
-- SECTION 1: EXISTING SQL FILES
-- ================================================

-- Lab 1 setup and dimension queries are preserved in:
-- 01_setup.sql
-- 02_populate_dimensions.sql

-- Lab 2–3 fact loading and analytical queries are in:
-- 03_populate_fact.sql
-- 04_star_queries.sql

-- ================================================
-- SECTION 2: DATA QUALITY CHECKS
-- Recovered from psql_history_backup.txt
-- ================================================

-- Check duplicate raw landing records
SELECT
    landing_date,
    port_code,
    species_name,
    vessel_code,
    landed_kg,
    landing_value,
    COUNT(*) AS occurrences
FROM stg.landings_raw
GROUP BY
    landing_date,
    port_code,
    species_name,
    vessel_code,
    landed_kg,
    landing_value
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- Check cleaned record status totals
SELECT
    record_status,
    COUNT(*) AS record_count
FROM stg.landings_cleaned
GROUP BY record_status
ORDER BY record_status;

-- Review recorded data-quality issues
SELECT
    landing_id,
    issue_category,
    issue_description,
    action_taken
FROM stg.data_quality_issues
ORDER BY landing_id, issue_category;

-- Count issues by category
SELECT
    issue_category,
    COUNT(*) AS issue_count
FROM stg.data_quality_issues
GROUP BY issue_category
ORDER BY issue_category;

-- ================================================
-- SECTION 3: DIMENSION VALIDATION
-- ================================================

-- Review species dimension
SELECT
    species_key,
    species_code,
    species_name
FROM dw.dim_species
ORDER BY species_key;

-- Review vessel history (SCD Type 2)
SELECT
    vessel_key,
    vessel_code,
    vessel_name,
    effective_from,
    effective_to,
    is_current
FROM dw.dim_vessel
WHERE UPPER(TRIM(vessel_code)) = 'TTV001'
ORDER BY effective_from;

-- ================================================
-- END OF REFERENCE ARCHIVE
-- ================================================