# `fact_sales_doc_snapshot` (Microsoft Fabric)

This folder defines an append-only daily snapshot design for sales documents.

## Grain
- Primary grain is **sales document + source**, with optional material detail via `material_id`.
- To analyze at pure sales document level, aggregate material-level rows.

## Artifacts
- `fact_sales_doc_snapshot.sql`: table DDL.
- `pipeline_fact_sales_doc_snapshot.sql`: daily append pipeline SQL.

## Pipeline behavior
1. Uses `SYSUTCDATETIME()` date as `snapshot_date`.
2. Checks if today's snapshot already exists and aborts if yes.
3. Reads from `stg_refsr`, `stg_order_pipeline`, `stg_projection`.
4. Preserves source identity through:
   - `source` (`RefSR`, `Order Pipeline`, `Projection`)
   - `source_record_id` (native source key)
5. Appends full snapshot rows (never updates or deletes prior dates).

## Orchestration recommendation
Schedule `pipeline_fact_sales_doc_snapshot.sql` in a Fabric Data Factory pipeline once per day after landing/refining all three sources.
