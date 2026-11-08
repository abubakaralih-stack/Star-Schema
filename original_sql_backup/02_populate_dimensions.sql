
-- Tawi-Tawi Fisheries Star Schema
SET search_path TO fisheries, public;

-- 1. Date dimension: 2020-2030
INSERT INTO dim_date (
    date_key, full_date, day_num, month_num,
    month_name, quarter_num, year_num
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER,
    d::DATE,
    EXTRACT(DAY FROM d)::INTEGER,
    EXTRACT(MONTH FROM d)::INTEGER,
    TO_CHAR(d, 'FMMonth'),
    EXTRACT(QUARTER FROM d)::INTEGER,
    EXTRACT(YEAR FROM d)::INTEGER
FROM GENERATE_SERIES(
    DATE '2020-01-01',
    DATE '2030-12-31',
    INTERVAL '1 day'
) AS series(d)
ON CONFLICT (date_key) DO NOTHING;

-- 2. Tawi-Tawi landing locations
-- Only Batu-Batu and Tapian are named documented sites.
-- Other entries are sample locations, not verified official port names.
INSERT INTO dim_port (
    port_code, port_name, municipality, province
)
VALUES
    ('TT001', 'Panglima Sugala Municipal Fish Port',
     'Panglima Sugala (Batu-Batu)', 'Tawi-Tawi'),
    ('TT002', 'Tapian Fish Landing Facility',
     'Tandubas (Barangay Tapian)', 'Tawi-Tawi'),
    ('TT003', 'Sample Landing Site - Bongao',
     'Bongao', 'Tawi-Tawi'),
    ('TT004', 'Sample Landing Site - Sitangkai',
     'Sitangkai', 'Tawi-Tawi'),
    ('TT005', 'Sample Landing Site - Languyan',
     'Languyan', 'Tawi-Tawi'),
    ('TT006', 'Sample Landing Site - Simunul',
     'Simunul', 'Tawi-Tawi')
ON CONFLICT (port_code) DO NOTHING;

-- 3. Sample fish and aquatic-product categories
INSERT INTO dim_species (species_code, species_name)
VALUES
    ('TTSP01', 'Yellowfin Tuna'),
    ('TTSP02', 'Skipjack Tuna'),
    ('TTSP03', 'Trevally'),
    ('TTSP04', 'Mackerel'),
    ('TTSP05', 'Sardines'),
    ('TTSP06', 'Squid'),
    ('TTSP07', 'Shrimp'),
    ('TTSP08', 'Seaweed')
ON CONFLICT (species_code) DO NOTHING;

-- 4. Sample vessels assigned to Tawi-Tawi locations
INSERT INTO dim_vessel (
    vessel_code, vessel_name, vessel_type, home_port,
    effective_from, effective_to, is_current
)
VALUES
    ('TTV001', 'Sample Vessel 001', 'Small-scale',
     'Bongao', DATE '2024-01-01', DATE '9999-12-31', TRUE),
    ('TTV002', 'Sample Vessel 002', 'Small-scale',
     'Panglima Sugala (Batu-Batu)', DATE '2024-01-01',
     DATE '9999-12-31', TRUE),
    ('TTV003', 'Sample Vessel 003', 'Small-scale',
     'Tandubas (Tapian)', DATE '2024-01-01',
     DATE '9999-12-31', TRUE),
    ('TTV004', 'Sample Vessel 004', 'Small-scale',
     'Sitangkai', DATE '2024-01-01', DATE '9999-12-31', TRUE),
    ('TTV005', 'Sample Vessel 005', 'Small-scale',
     'Languyan', DATE '2024-01-01', DATE '9999-12-31', TRUE),
    ('TTV006', 'Sample Vessel 006', 'Small-scale',
     'Simunul', DATE '2024-01-01', DATE '9999-12-31', TRUE)
ON CONFLICT DO NOTHING;

-- 5. Verify dimension counts
SELECT 'dim_date' AS table_name, COUNT(*) AS total_rows
FROM dim_date
UNION ALL
SELECT 'dim_port', COUNT(*) FROM dim_port
UNION ALL
SELECT 'dim_species', COUNT(*) FROM dim_species
UNION ALL
SELECT 'dim_vessel', COUNT(*) FROM dim_vessel;


SELECT
    port_code,
    port_name,
    municipality,
    province
FROM dim_port
ORDER BY port_code;
