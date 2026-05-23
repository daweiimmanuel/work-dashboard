-- Fabric Warehouse table for daily immutable snapshots at sales document grain.
CREATE TABLE dbo.fact_sales_doc_snapshot (
    snapshot_date      date            NOT NULL,
    sales_doc_id       nvarchar(64)    NOT NULL,
    material_id        nvarchar(64)    NULL,
    region             nvarchar(100)   NULL,
    bo                 nvarchar(100)   NULL,
    product_manager    nvarchar(150)   NULL,
    product            nvarchar(200)   NULL,
    source             nvarchar(50)    NOT NULL,
    source_record_id   nvarchar(128)   NOT NULL,
    qty_mt             decimal(18, 3)  NULL,
    order_status       nvarchar(100)   NULL,
    rdd_month          char(7)         NULL,
    inserted_at_utc    datetime2       NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Optional index for typical date + key slicing.
CREATE INDEX IX_fact_sales_doc_snapshot_date_doc
ON dbo.fact_sales_doc_snapshot (snapshot_date, sales_doc_id, material_id);
GO
