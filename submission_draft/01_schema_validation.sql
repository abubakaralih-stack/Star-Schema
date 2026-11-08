-- Fisheries Data Warehouse: Schema Verification
-- Checks the existing dw and stg schemas.
-- Read-only: does not create, alter, or drop database objects.

SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name IN ('dw', 'stg')
ORDER BY schema_name;

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema IN ('dw', 'stg')
  AND table_type = 'BASE TABLE'
ORDER BY table_schema, table_name;

-- Check the required core warehouse tables.
WITH required_tables(schema_name, table_name) AS (
    VALUES
        ('dw', 'dim_date'),
        ('dw', 'dim_port'),
        ('dw', 'dim_species'),
        ('dw', 'dim_vessel'),
        ('dw', 'fact_landing'),
        ('stg', 'landings_raw'),
        ('stg', 'landings_cleaned'),
        ('stg', 'data_quality_issues'),
        ('stg', 'species_mapping')
)
SELECT
    r.schema_name,
    r.table_name,
    CASE
        WHEN t.table_name IS NOT NULL THEN 'EXISTS'
        ELSE 'MISSING'
    END AS table_status
FROM required_tables AS r
LEFT JOIN information_schema.tables AS t
    ON t.table_schema = r.schema_name
   AND t.table_name = r.table_name
   AND t.table_type = 'BASE TABLE'
ORDER BY r.schema_name, r.table_name;
