-- Curated fact tables that replace monolithic CombinedData business logic.

create or replace view fact_order_intake as
select
  s.order_id,
  cast(s.order_date as date) as date_key,
  coalesce(s.region_code, 'UNKNOWN') as region_key,
  coalesce(s.product_sku, 'UNKNOWN') as product_key,
  coalesce(s.sales_owner_id, 'UNASSIGNED') as sales_owner_key,
  s.source_type,
  s.quantity,
  s.intake_amount_usd
from stg_sr_ot s
where s.order_status in ('Submitted', 'Confirmed');

create or replace view fact_pipeline as
select
  p.pipeline_id,
  cast(p.pipeline_date as date) as date_key,
  coalesce(p.region_code, 'UNKNOWN') as region_key,
  coalesce(p.product_sku, 'UNKNOWN') as product_key,
  coalesce(p.sales_owner_id, 'UNASSIGNED') as sales_owner_key,
  p.stage,
  p.probability,
  p.pipeline_amount_usd
from stg_order_pipeline p
where p.is_active = true;

create or replace view fact_projection as
select
  pr.projection_id,
  cast(pr.projection_date as date) as date_key,
  coalesce(pr.region_code, 'UNKNOWN') as region_key,
  coalesce(pr.product_sku, 'UNKNOWN') as product_key,
  coalesce(pr.sales_owner_id, 'UNASSIGNED') as sales_owner_key,
  pr.scenario,
  pr.projected_amount_usd,
  pr.projected_units
from stg_projection pr
where pr.snapshot_flag = 'latest';

create or replace view fact_target as
select
  t.target_id,
  cast(t.target_date as date) as date_key,
  coalesce(t.region_code, 'UNKNOWN') as region_key,
  coalesce(t.product_sku, 'UNKNOWN') as product_key,
  coalesce(t.sales_owner_id, 'UNASSIGNED') as sales_owner_key,
  t.fiscal_version,
  t.target_amount_usd,
  t.target_units
from stg_bpc_data t
where t.target_amount_usd is not null;
