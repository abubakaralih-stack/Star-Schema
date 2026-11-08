# Fisheries Data Warehouse — Lab 1–3

## Project Overview
This project uses PostgreSQL to organize fisheries landing data
in a star-schema data warehouse.

The current working database uses the `dw` and `stg` schemas.

## Files

1. `01_schema_validation.sql`
   - Checks that required schemas and tables exist.
   - Read-only; does not create or modify database objects.

2. `02_dimension_validation.sql`
   - Checks dimension row counts and vessel SCD Type 2 history.
   - Read-only; does not insert, update, or delete data.

3. `03_populate_fact.sql`
   - Loads accepted staging records into `dw.fact_landing`.
   - Contains INSERT and COMMIT statements.
   - Review before execution. Do not rerun without checking the
     existing fact records and the loading logic.

4. `04_star_queries.sql`
   - Runs analytical queries for monthly landings, top species
     per port, and landing value per cooperative.
   - Intended for analysis; verify the schema and columns first.

## Data Note
The current test dataset is generated sample data, not official
fisheries statistics. Sample locations, vessels, and cooperatives
must not be presented as verified real-world records.

## Safety Notes
- Preserve the original SQL files and backups.
- Do not run the old root setup and dimension scripts against
  the current `dw`/`stg` workflow without reviewing them.
- Confirm the instructor's requirements before final submission.
