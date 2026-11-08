
CREATE SCHEMA IF NOT EXISTS fisheries;

SET search_path TO fisheries, public;

CREATE TABLE IF NOT EXISTS dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    day_num INTEGER NOT NULL,
    month_num INTEGER NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    quarter_num INTEGER NOT NULL,
    year_num INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_port (
    port_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    port_code VARCHAR(20) UNIQUE NOT NULL,
    port_name VARCHAR(100) NOT NULL,
    municipality VARCHAR(100),
    province VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_species (
    species_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    species_code VARCHAR(20) UNIQUE NOT NULL,
    species_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_vessel (
    vessel_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vessel_code VARCHAR(20) NOT NULL,
    vessel_name VARCHAR(100) NOT NULL,
    vessel_type VARCHAR(50),
    home_port VARCHAR(100),
    effective_from DATE NOT NULL,
    effective_to DATE NOT NULL DEFAULT DATE '9999-12-31',
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_vessel_current
ON dim_vessel (vessel_code)
WHERE is_current = TRUE;

CREATE TABLE IF NOT EXISTS fact_landing (
    landing_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_key INTEGER NOT NULL REFERENCES dim_date(date_key),
    port_key INTEGER NOT NULL REFERENCES dim_port(port_key),
    species_key INTEGER NOT NULL REFERENCES dim_species(species_key),
    vessel_key INTEGER NOT NULL REFERENCES dim_vessel(vessel_key),
    landed_kg NUMERIC(12,2) NOT NULL CHECK (landed_kg >= 0),
    landing_value NUMERIC(14,2) NOT NULL CHECK (landing_value >= 0)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'fisheries'
ORDER BY table_name;
