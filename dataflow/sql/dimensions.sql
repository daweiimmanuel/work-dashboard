-- Conformed dimensions replacing ad-hoc CombinedData attributes.

create or replace view dim_region as
select distinct
  coalesce(region_code, 'UNKNOWN') as region_key,
  coalesce(region_name, 'Unknown') as region_name
from (
  select region_code, region_name from stg_sr_ot
  union all
  select region_code, region_name from stg_order_pipeline
  union all
  select region_code, region_name from stg_projection
  union all
  select region_code, region_name from stg_bpc_data
) src;

create or replace view dim_product as
select distinct
  coalesce(product_sku, 'UNKNOWN') as product_key,
  coalesce(product_name, 'Unknown') as product_name,
  coalesce(product_family, 'Unknown') as product_family
from (
  select product_sku, product_name, product_family from stg_sr_ot
  union all
  select product_sku, product_name, product_family from stg_order_pipeline
  union all
  select product_sku, product_name, product_family from stg_projection
  union all
  select product_sku, product_name, product_family from stg_bpc_data
) src;

create or replace view dim_sales_owner as
select distinct
  coalesce(sales_owner_id, 'UNASSIGNED') as sales_owner_key,
  coalesce(sales_owner_name, 'Unassigned') as sales_owner_name,
  coalesce(sales_team, 'Unknown') as sales_team
from (
  select sales_owner_id, sales_owner_name, sales_team from stg_sr_ot
  union all
  select sales_owner_id, sales_owner_name, sales_team from stg_order_pipeline
  union all
  select sales_owner_id, sales_owner_name, sales_team from stg_projection
  union all
  select sales_owner_id, sales_owner_name, sales_team from stg_bpc_data
) src;

create or replace view dim_date as
with all_dates as (
  select order_date as d from stg_sr_ot
  union all
  select pipeline_date as d from stg_order_pipeline
  union all
  select projection_date as d from stg_projection
  union all
  select target_date as d from stg_bpc_data
)
select distinct
  cast(d as date) as date_key,
  extract(year from d) as year,
  extract(quarter from d) as quarter,
  extract(month from d) as month,
  extract(week from d) as iso_week
from all_dates
where d is not null;
