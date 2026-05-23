# Curated semantic model (replacing `CombinedData`)

This folder replaces monolithic `CombinedData` logic with conformed dimensions and curated facts.

## Conformed dimensions

- `dim_region`
- `dim_product`
- `dim_sales_owner`
- `dim_date`

## Curated facts

- `fact_order_intake` from SR/OT (`stg_sr_ot`)
- `fact_pipeline` from Order Pipeline (`stg_order_pipeline`)
- `fact_projection` from Projection (`stg_projection`)
- `fact_target` from BPCData (`stg_bpc_data`)

## Modeling rules

- Keep business logic in SQL transforms (`where` clauses, derivations, conformed keys).
- Keep reporting layer formulas lightweight (aggregation/presentation only).
- Join facts to dimensions via `{date_key, region_key, product_key, sales_owner_key}`.
