/*
Daily append-only load for dbo.fact_sales_doc_snapshot.
Pattern:
1) Read current state from three feeds: RefSR, Order Pipeline, Projection.
2) Normalize into a shared shape while preserving native source identifiers.
3) Append ONLY if snapshot_date for today has not already been loaded.
*/

DECLARE @snapshot_date date = CAST(SYSUTCDATETIME() AS date);

IF EXISTS (
    SELECT 1
    FROM dbo.fact_sales_doc_snapshot
    WHERE snapshot_date = @snapshot_date
)
BEGIN
    THROW 50001, 'Snapshot for today already exists. Append-only policy prevents overwrite.', 1;
END;

WITH refs AS (
    SELECT
        @snapshot_date AS snapshot_date,
        CAST(r.sales_doc_id AS nvarchar(64)) AS sales_doc_id,
        CAST(r.material_id AS nvarchar(64)) AS material_id,
        CAST(r.region AS nvarchar(100)) AS region,
        CAST(r.bo AS nvarchar(100)) AS bo,
        CAST(r.product_manager AS nvarchar(150)) AS product_manager,
        CAST(r.product AS nvarchar(200)) AS product,
        CAST('RefSR' AS nvarchar(50)) AS source,
        CAST(r.refsr_id AS nvarchar(128)) AS source_record_id,
        CAST(r.qty_mt AS decimal(18,3)) AS qty_mt,
        CAST(r.order_status AS nvarchar(100)) AS order_status,
        LEFT(CONVERT(varchar(10), r.rdd_date, 23), 7) AS rdd_month
    FROM dbo.stg_refsr r
),
order_pipeline AS (
    SELECT
        @snapshot_date AS snapshot_date,
        CAST(o.sales_document AS nvarchar(64)) AS sales_doc_id,
        CAST(o.material_id AS nvarchar(64)) AS material_id,
        CAST(o.region AS nvarchar(100)) AS region,
        CAST(o.bo AS nvarchar(100)) AS bo,
        CAST(o.product_manager AS nvarchar(150)) AS product_manager,
        CAST(o.product AS nvarchar(200)) AS product,
        CAST('Order Pipeline' AS nvarchar(50)) AS source,
        CAST(o.order_pipeline_id AS nvarchar(128)) AS source_record_id,
        CAST(o.qty_mt AS decimal(18,3)) AS qty_mt,
        CAST(o.order_status AS nvarchar(100)) AS order_status,
        LEFT(CONVERT(varchar(10), o.rdd_date, 23), 7) AS rdd_month
    FROM dbo.stg_order_pipeline o
),
projection AS (
    SELECT
        @snapshot_date AS snapshot_date,
        CAST(p.sales_doc_id AS nvarchar(64)) AS sales_doc_id,
        CAST(p.material_id AS nvarchar(64)) AS material_id,
        CAST(p.region AS nvarchar(100)) AS region,
        CAST(p.bo AS nvarchar(100)) AS bo,
        CAST(p.product_manager AS nvarchar(150)) AS product_manager,
        CAST(p.product AS nvarchar(200)) AS product,
        CAST('Projection' AS nvarchar(50)) AS source,
        CAST(p.projection_id AS nvarchar(128)) AS source_record_id,
        CAST(p.qty_mt AS decimal(18,3)) AS qty_mt,
        CAST(p.order_status AS nvarchar(100)) AS order_status,
        LEFT(CONVERT(varchar(10), p.rdd_date, 23), 7) AS rdd_month
    FROM dbo.stg_projection p
),
unified AS (
    SELECT * FROM refs
    UNION ALL
    SELECT * FROM order_pipeline
    UNION ALL
    SELECT * FROM projection
)
INSERT INTO dbo.fact_sales_doc_snapshot (
    snapshot_date,
    sales_doc_id,
    material_id,
    region,
    bo,
    product_manager,
    product,
    source,
    source_record_id,
    qty_mt,
    order_status,
    rdd_month
)
SELECT
    snapshot_date,
    sales_doc_id,
    material_id,
    region,
    bo,
    product_manager,
    product,
    source,
    source_record_id,
    qty_mt,
    order_status,
    rdd_month
FROM unified;
