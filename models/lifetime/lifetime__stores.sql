{{config(
    catalog = 'hive',
    schema = 'preview_trino',
    materialize = 'view'
)}}
with store_sales_by_product as (
    select
        Store_ID as store_id,
        Product_ID as product_id,
        count(Sale_ID) as num_sales,
        sum(cast(Units as int)) as total_units
    from
        Snowflake.CUSTOMER_DEMO.TOY_SALES
    group by
        store_id,
        product_id
),
top_products_by_store as (
    select
        ssp.store_id,
        max_by(p.Product_Name, ssp.total_units * p.Product_Price) as top_product_by_revenue,
        max(ssp.total_units * p.Product_Price) as top_product_total_revenue,
        max_by(p.Product_Name, ssp.total_units * (p.product_price - p.Product_Cost)) as top_product_by_profit,
        max(ssp.total_units * (p.Product_Price - p.Product_Cost)) as top_product_total_profit
    from
        store_sales_by_product ssp
    inner join
        postgresql.customer_demo.toy_products p on ssp.product_id = p.Product_ID
    group by
        store_id
),
store_metrics as (
    select
        ssp.store_id,
        sum(ssp.num_sales) as total_store_sales,
        sum(ssp.total_units * products.Product_Price) as total_store_revenue,
        sum(ssp.total_units * (products.Product_Price - products.Product_Cost)) as total_store_profit,
        sum(ssp.total_units * products.Product_Price) / sum(ssp.total_units) as avg_store_revenue_per_unit_sold,
        sum(ssp.total_units * (products.Product_Price - products.Product_Cost)) / sum(ssp.total_units) as avg_store_profit_per_unit_sold
    from
        store_sales_by_product ssp
    left join
        postgresql.customer_demo.toy_products products on ssp.product_id = products.Product_ID
    group by
        store_id
)
select
    sm.store_id,
    stores.Store_Name as store_name,
    stores.Store_City as store_city,
    stores.Store_Location as store_location,
    stores.Store_Open_Date as store_open_date,
    stores.Latitude as store_latitude,
    stores.Longitude as store_longitude,
    sm.total_store_sales,
    sm.total_store_revenue,
    sm.total_store_profit,
    sm.avg_store_revenue_per_unit_sold,
    sm.avg_store_profit_per_unit_sold,
    tps.top_product_by_revenue,
    tps.top_product_total_revenue,
    tps.top_product_total_revenue / sm.total_store_revenue as top_product_revenue_share,
    tps.top_product_by_profit,
    tps.top_product_total_profit,
    tps.top_product_total_profit / sm.total_store_profit as top_product_profit_share
from
    store_metrics sm
inner join
    postgresql.customer_demo.toy_stores stores on sm.store_id = stores.store_id
left join
    top_products_by_store tps on tps.store_id = sm.store_id
